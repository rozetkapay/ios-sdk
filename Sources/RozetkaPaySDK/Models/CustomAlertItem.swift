//
//  CustomAlertItem.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 19.04.2025.
//


import SwiftUI

struct CustomAlertItem: Identifiable {
    let id = UUID()
    let type: CustomAlertType
    let title: String
    let message: String
}


enum CustomAlertType {
    case success
    case error
    case info
    case soon
    case custom(emoji: String)
    
    var color: Color {
        switch self {
        case .success:
            return .green
        case .error:
            return .red
        case .info:
            return .blue
        case .soon:
            return .blue
        case .custom:
            return .white
        }
    }
    
    var textColor: Color {
        switch self {
        case .success:
            return .white
        case .error:
            return .white
        case .info:
            return .white
        case .soon:
            return .white
        case .custom:
            return .black
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .success:
            return .white
        case .error:
            return .white
        case .info:
            return .white
        case .soon:
            return .white
        case .custom:
            return .green
        }
    }
    
    var emoji: String {
        switch self {
        case .success: 
            return "✅"
        case .error:
            return "❌"
        case .info:
            return "ℹ️"
        case .soon:
            return "🔜"
        case .custom(let emoji):
            return emoji
        }
    }
    
    var circleColor: Color {
        switch self {
        case .success:
            return .white
        case .error:
            return .white
        case .info:
            return .white
        case .soon:
            return .white
        case .custom:
            return .gray
        }
    }
}
