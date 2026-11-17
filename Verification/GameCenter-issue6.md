# CastIt #6 — defensive Game Center patch

Date: 2026-11-17
Base: main, 0cb08176bfdbc348e70d65cea6de0bddd68141d1
Issue: https://github.com/guilermebarciki/CastIt/issues/6

## Scope and behavior

- Remove authentication from AppDelegate, which had no presenter.
- Start authentication from the menu's viewDidAppear, with a loaded view in a window, no presented modal, and no presentation/dismissal transition.
- Install one authentication handler per manager lifetime. Returning after cancellation does not automatically reinstall it or prompt again.
- Keep only a weak reference to the presenter. If login arrives while the menu is hidden/busy, hold its controller until the next eligible menu appearance.
- Serialize callback state and score/leaderboard operations on the main queue.
- Reset authentication/leaderboard state on each authentication callback. Ignore default-leaderboard responses from earlier authentication revisions.
- Handle nil errors, errors, nil/blank leaderboard identifiers and unauthenticated players without force unwraps.
- Submit and display only when authenticated with a loaded identifier; reject invalid/busy presenters. No leaderboard or failed login is a safe no-op; local game navigation/scoring is unchanged. No score retry/backfill is added.
- Submission errors are logged without interrupting gameplay.

Apple's handler contract permits both optional controller and optional error:
https://developer.apple.com/documentation/gamekit/gklocalplayer/authenticatehandler

## Verification performed

1. Run from repository root: `python3 Verification/run-gamecenter-checks.py`.
   Result: PASS, 19 controlled checks compiled with Swift 5 language mode on macOS.
   The harness executes the actual manager source against lightweight UIKit/GameKit doubles.
   Covers hidden/missing/busy/dismissing presenters, deferred login, cancellation without error, authentication/load/submission errors, missing/blank identifier, stale load after authentication change, valid submit/display, duplicate modal prevention and sign-out before callback.
   These checks do not emulate Apple's login UI, networking, account configuration or device behavior.
2. Manager-only typecheck using the real iOS Simulator SDK:
   `xcrun --sdk iphonesimulator swiftc -typecheck -swift-version 5 -target arm64-apple-ios14.0-simulator -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk CastIt/LeaderBoardManager.swift`.
   Result: passed, no diagnostics, Xcode 26.2 (17C52). This is not a linked app build.
3. `git diff --check`: passed.
4. Attempted Debug simulator workspace build with signing disabled.
   Result: FAILED before app compilation because Pods/Target Support Files/Pods-CastIt/Pods-CastIt.debug.xcconfig and CocoaPods framework xcfilelists are missing.
   No Pod installation or dependency migration performed.

## Remaining acceptance / manual verification

Issue #6 remains open; this patch supplies only defensive code coverage.
Full app compilation depends on issue #2/dependency setup. After it is restored:
- Verify signed-out launch, cancel, authentication failure/offline play, successful login and menu return on a real device.
- Leave the menu before the auth callback; ensure no hidden presenter attempts and only one login on return.
- Verify rapid score submission before/after identifier load, and actual leaderboard submission/readback.
- Verify a missing/default misconfigured leaderboard in the account without crashing.
- Check Game Center capability, signed archive entitlements, leaderboard account setup and the separately recorded push-entitlement question.

No real Game Center session, entitlement validation, archive, account change, SDK modernization or distribution was performed.
