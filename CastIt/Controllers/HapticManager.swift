//
//  HapticManager.swift
//  CastIt
//
//  Created by Guilerme Barciki on 01/03/22.
//

import Foundation
import UIKit

final class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    public func vibrate(for style: UIImpactFeedbackGenerator.FeedbackStyle) {
       
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
        if style == .light {
            print("vibrate called light")
        } else if style == .heavy {
            print("vibrate called heavy")
        } else {
            print("vibrate called \(style)")
        }
    }
    
}
