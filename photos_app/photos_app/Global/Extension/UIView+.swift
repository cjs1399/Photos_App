//
//  UIView+.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
