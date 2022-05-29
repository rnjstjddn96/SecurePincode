//
//  PinInput.swift
//  SecurePincode
//
//  Created by 권성우 on 2022/05/29.
//

import Foundation
import UIKit

enum PinInput {
    case delete
    case number(number: String)
    case clear
}

enum PinType {
    case dot
    case rect
    
    var size: CGFloat {
        switch self {
        case .dot:
            return 3.2.asPercent(with: .WIDTH)
        case .rect:
            return 9.6.asPercent(with: .WIDTH)
        }
    }
    
    var spaceSize: CGFloat {
        switch self {
        case .dot:
            return 3.7.asPercent(with: .WIDTH)
        case .rect:
            return 1.6.asPercent(with: .WIDTH)
        }
    }
    
    var view: UIView {
        
        switch self {
        case .dot:
            return PinDotView(isEmpty: false)
        case .rect:
            return PinRectView(isEmpty: false)
        }
    }
    
    var emptyView: UIView {
        switch self {
        case .dot:
            return PinDotView(isEmpty: true)
        case .rect:
            return PinRectView(isEmpty: true)
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .dot:
            return self.size / 2
        case .rect:
            return 6
        }
    }
}
