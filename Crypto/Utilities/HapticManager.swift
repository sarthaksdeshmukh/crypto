//
//  HapticManager.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 27/05/25.
//

import Foundation
import SwiftUI

class HapticManager {
    static let generate = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generate.notificationOccurred(type) 
    }
}
