//
//  CustomAlertView.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit

class CustomAlertViewController: BaseViewController {
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let messageLabel = UILabel()
    private let yesButton = UIButton()
    private let noButton = UIButton()
    private let horizontalWall = UIView()
    private let verticalWall = UIView()
    
    
    // MARK: - Initializer
    init(frame: CGRect, alertText: String) {
        super.init(nibName: nil, bundle: nil)
        messageLabel.text = alertText
    }
    
    override func setStyles() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 배경
        
        containerView.do {
            $0.backgroundColor = UIColor(hex: "#F9F9F9")
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        messageLabel.do {
            $0.textColor = UIColor(hex:"#242424")
            $0.font = .fontGuide(.noticeLabel)
            $0.textAlignment = .center
        }

        yesButton.do {
            $0.setTitle("네", for: .normal)
            $0.setTitleColor(UIColor(hex: "#000000"), for: .normal)
        }
        
        noButton.do {
            $0.setTitle("아니요", for: .normal)
            $0.setTitleColor(UIColor(hex: "#FF4F17"), for: .normal)
        }
        
        horizontalWall.do {
            $0.backgroundColor = UIColor(hex:"#242424")
        }
        
        verticalWall.do {
            $0.backgroundColor = UIColor(hex:"#242424")
        }
        
    }
    
    override func setLayout() {
        view.addSubviews(containerView)
        containerView.addSubviews(messageLabel, yesButton, noButton, horizontalWall, verticalWall)
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 300 / 390)
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 150 / 844)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(SizeLiterals.Screen.screenHeight * 50 / 844)
            $0.centerX.equalToSuperview()
        }
        
        yesButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 40 / 844)
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 149.5 / 390)
        }
        
        noButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 40 / 844)
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 149.5 / 390)
        }
        
        horizontalWall.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(noButton.snp.top)
            $0.height.equalTo(1)
        }
        
        verticalWall.snp.makeConstraints {
            $0.leading.equalTo(yesButton.snp.trailing)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 40 / 844)
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 1 / 390)
        }
    }
    
    func getYesButton() -> UIButton {
        return yesButton
    }
    
    func getNoButton() -> UIButton {
        return noButton
    }
    
    func dismissAlertViewController() {
        self.dismiss(animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
