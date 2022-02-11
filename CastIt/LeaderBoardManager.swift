//
//  LeaderBoardManager.swift
//  CastIt
//
//  Created by Guilerme Barciki on 09/02/22.
//

import GameKit

class LeaderboardManager: NSObject, GKGameCenterControllerDelegate {
    static let shared = LeaderboardManager()
    
    // Leaderboard variables
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    func authenticateLocalPlayer(presentingVC: UIViewController?) {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if ((ViewController) != nil) {
                // Show game center login if player is not logged in
                presentingVC!.present(ViewController!, animated: true, completion: nil)
            }
            else if (localPlayer.isAuthenticated) {
                
                // Player is already authenticated and logged in
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
            }
            else {
                // Game center is not enabled on the user's device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }
    
    func updateScore(with value:Int) {
        if (self.gcEnabled) {
            GKLeaderboard.submitScore(value, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [self.gcDefaultLeaderBoard], completionHandler: {error in
                if error != nil {
                    print("Error updating score: \(error!)")
                }
            })
        }
    }
    
    
    func navigateToLeaderboard(presentingVC: UIViewController?) {
        let gameCenterVC = GKGameCenterViewController(leaderboardID: self.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
        gameCenterVC.gameCenterDelegate = self
        presentingVC!.present(gameCenterVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismiss(animated:true)
    }
}
