//
//  CustomToastView.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit

class CustomToastView: UIView {
    private var toastView: UIView?
    
    func showToast(in view: UIView, message: String) {
        if let existingToast = toastView {
                existingToast.layer.removeAllAnimations()
                existingToast.removeFromSuperview()
                toastView = nil
            }

        let tint: UIColor = UIColor(hex: "#FFFFFF")

        let toastLabel = UILabel()
        toastLabel.textColor = tint
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.font = .fontGuide(.noticeSelectFilter)
        toastLabel.alpha = 0.0
        toastLabel.clipsToBounds = true

        let toastWidth = UIScreen.main.bounds.width - 38 * 2.0
        let toastHeight: CGFloat = 50.0

        let toastFrame = CGRect(
            x: (SizeLiterals.Screen.screenWidth - toastWidth) / 2,
            y: SizeLiterals.Screen.screenHeight / 2 - toastHeight / 2 - 100,
            width: toastWidth,
            height: toastHeight
        )

        let shadowView = UIView(frame: toastFrame)
        shadowView.backgroundColor = .clear
        shadowView.addSubview(toastLabel)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 4

        toastLabel.frame = CGRect(x: 0, y: 0, width: toastWidth, height: toastHeight)

        view.addSubview(shadowView)

        toastView = shadowView

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 1.0
        })
        UIView.animate(withDuration: 0.3, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { [weak self] _ in
            shadowView.removeFromSuperview()
            self?.toastView = nil
        })
    }
}
