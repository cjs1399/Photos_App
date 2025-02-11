//
//  FontLiterals.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

enum AppleSDGothicNeo: String {
    case bold = "AppleSDGothicNeo-Bold"
    case medium = "AppleSDGothicNeo-Medium"
    case regular = "AppleSDGothicNeo-Regular"
}

enum FontLevel {
    case noticeLabel
    case editLabel
    case titleLabel
    case editBottomLabel
    case noticeSelectFilter
}

extension FontLevel {
    var fontWeight: String {
        switch self {
        case .noticeLabel, .editLabel, .titleLabel, .editBottomLabel, .noticeSelectFilter:
            return AppleSDGothicNeo.regular.rawValue
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .noticeSelectFilter:
            return 28
        case .noticeLabel:
            return 17
        case .editLabel:
            return 12
        case .titleLabel:
            return 19
        case .editBottomLabel:
            return 10
        }
    }
}

extension UIFont {
    static func fontGuide(_ fontLevel: FontLevel) -> UIFont {
        return UIFont(name: fontLevel.fontWeight, size: fontLevel.fontSize)!
    }
}
