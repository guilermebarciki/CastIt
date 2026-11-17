#!/usr/bin/env python3
"""Run the actual manager against controlled UIKit/GameKit doubles (not SDK integration)."""
from pathlib import Path
import subprocess
import tempfile

root = Path(__file__).resolve().parents[1]
source = (root / "CastIt/LeaderBoardManager.swift").read_text().replace("import GameKit", "import Foundation")
stubs = r"""
class UIView { var window: Int? = 1 }
class UIViewController: NSObject {
    var isViewLoaded = true
    var view = UIView()
    var presentedViewController: UIViewController?
    var navigationController: UIViewController?
    var isBeingDismissed = false
    var isBeingPresented = false
    var presentationCount = 0
    func present(_ vc: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentationCount += 1
        presentedViewController = vc
        completion?()
    }
    func dismiss(animated: Bool) {}
}
protocol GKGameCenterControllerDelegate: AnyObject {}
enum PlayerScope { case global }
enum TimeScope { case allTime }
class GKGameCenterViewController: UIViewController {
    weak var gameCenterDelegate: GKGameCenterControllerDelegate?
    init(leaderboardID: String, playerScope: PlayerScope, timeScope: TimeScope) { super.init() }
}
class GKLocalPlayer {
    static let local = GKLocalPlayer()
    var isAuthenticated = false
    var handlerAssignments = 0
    var authenticateHandler: ((UIViewController?, Error?) -> Void)? {
        didSet { handlerAssignments += 1 }
    }
    var loads: [(String?, Error?) -> Void] = []
    func loadDefaultLeaderboardIdentifier(completionHandler: @escaping (String?, Error?) -> Void) {
        loads.append(completionHandler)
    }
}
class GKLeaderboard {
    static var submissions: [[String]] = []
    static var error: Error?
    static func submitScore(_ score: Int, context: Int, player: GKLocalPlayer,
                            leaderboardIDs: [String], completionHandler: (Error?) -> Void) {
        submissions.append(leaderboardIDs)
        completionHandler(error)
    }
}
"""
tests = r"""
enum Failure: Error { case expected }
func drain() { RunLoop.main.run(until: Date().addingTimeInterval(0.02)) }
var checks = 0
func check(_ condition: @autoclosure () -> Bool, _ message: String) {
    precondition(condition(), message)
    checks += 1
}
let manager = LeaderboardManager()
let player = GKLocalPlayer.local
let presenter = UIViewController()
manager.authenticateLocalPlayer(presentingVC: nil)
presenter.view.window = nil
manager.authenticateLocalPlayer(presentingVC: presenter)
check(player.handlerAssignments == 0, "No handler without visible presenter")
presenter.view.window = 1
manager.authenticateLocalPlayer(presentingVC: presenter)
check(player.handlerAssignments == 1, "One handler installed")
player.authenticateHandler?(nil, nil)
drain()
check(!manager.gcEnabled && manager.gcDefaultLeaderBoard == nil, "Nil error without authentication")
manager.updateScore(with: 7)
manager.navigateToLeaderboard(presentingVC: presenter)
drain()
check(GKLeaderboard.submissions.isEmpty && presenter.presentationCount == 0, "Offline paths are no-ops")
player.authenticateHandler?(nil, Failure.expected)
drain()
check(!manager.gcEnabled, "Authentication error")
let login = UIViewController()
presenter.view.window = nil
player.authenticateHandler?(login, nil)
drain()
check(presenter.presentationCount == 0, "Callback cannot present on hidden menu")
presenter.view.window = 1
manager.authenticateLocalPlayer(presentingVC: presenter)
check(presenter.presentedViewController === login, "Pending login presented on visible menu")
presenter.presentedViewController = nil
player.authenticateHandler?(nil, nil)
drain()
manager.authenticateLocalPlayer(presentingVC: presenter)
check(player.handlerAssignments == 1 && presenter.presentationCount == 1, "Cancel does not reprompt")
player.isAuthenticated = true
player.authenticateHandler?(nil, nil)
drain()
player.loads.removeFirst()(nil, nil)
drain()
manager.updateScore(with: 8)
manager.navigateToLeaderboard(presentingVC: presenter)
drain()
check(manager.gcEnabled && manager.gcDefaultLeaderBoard == nil, "Missing leaderboard is safe")
check(GKLeaderboard.submissions.isEmpty && presenter.presentationCount == 1, "Missing leaderboard blocks API calls")
player.authenticateHandler?(nil, nil)
drain()
player.loads.removeFirst()("board", Failure.expected)
drain()
check(manager.gcDefaultLeaderBoard == nil, "Load error leaves no leaderboard")
player.authenticateHandler?(nil, nil)
drain()
player.loads.removeFirst()("  ", nil)
drain()
check(manager.gcDefaultLeaderBoard == nil, "Blank identifier rejected")
player.authenticateHandler?(nil, nil)
drain()
let stale = player.loads.removeFirst()
player.isAuthenticated = false
player.authenticateHandler?(nil, nil)
drain()
player.isAuthenticated = true
stale("old-board", nil)
drain()
check(!manager.gcEnabled && manager.gcDefaultLeaderBoard == nil, "Stale load cannot restore old state")
player.authenticateHandler?(nil, nil)
drain()
player.loads.removeFirst()("current-board", nil)
drain()
check(manager.gcDefaultLeaderBoard == "current-board", "Valid leaderboard accepted")
GKLeaderboard.error = Failure.expected
manager.updateScore(with: 9)
drain()
check(GKLeaderboard.submissions == [["current-board"]], "Valid submission and submission error")
manager.navigateToLeaderboard(presentingVC: nil)
presenter.isBeingDismissed = true
manager.navigateToLeaderboard(presentingVC: presenter)
drain()
check(presenter.presentationCount == 1, "Invalid presenters blocked")
presenter.isBeingDismissed = false
manager.navigateToLeaderboard(presentingVC: presenter)
drain()
check(presenter.presentedViewController is GKGameCenterViewController, "Valid leaderboard presented")
manager.navigateToLeaderboard(presentingVC: presenter)
drain()
check(presenter.presentationCount == 2, "Existing modal prevents duplicate presentation")
player.isAuthenticated = false
manager.updateScore(with: 10)
drain()
check(GKLeaderboard.submissions.count == 1, "Sign-out blocks submission before callback")
print("PASS: \(checks) controlled checks; no Apple SDK or account integration exercised.")
"""
with tempfile.TemporaryDirectory(prefix="castit-gamecenter-") as directory:
    main = Path(directory) / "main.swift"
    main.write_text(stubs + "\n" + source + "\n" + tests)
    binary = Path(directory) / "checks"
    subprocess.run(["swiftc", "-swift-version", "5", str(main), "-o", str(binary)], check=True)
    subprocess.run([str(binary)], check=True)
