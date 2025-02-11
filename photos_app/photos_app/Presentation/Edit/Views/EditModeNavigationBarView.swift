//
//  EditModeNavigationBarView.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit

class EditModeNavigationBarView: BaseView {
    
    // MARK: - UI Components
    
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let shareButton = UIButton()
    
    override func setStyles() {
        backgroundColor = UIColor(hex: "#1C1C1C")
        
        backButton.do {
            $0.setImage(ImageLiterals.EditView.back_ic, for: .normal)
        }
        
        titleLabel.do {
            $0.text = "편집"
            $0.textColor = UIColor(hex: "#FFFFFF")
            $0.font = .fontGuide(.titleLabel)
        }
        
        shareButton.do {
            $0.setImage(ImageLiterals.EditView.share_ic, for: .normal)
        }
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        addSubviews(backButton, titleLabel, shareButton)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-SizeLiterals.Screen.screenHeight * 20 / 844)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalToSuperview().offset(SizeLiterals.Screen.screenWidth * 10 / 390)
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 20.53 / 844)
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 15 / 390)
        }
        
        shareButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-SizeLiterals.Screen.screenWidth * 10 / 390)
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 26.47 / 844)
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 17.7 / 390)
        }
    }
    
    // MARK: - Methods
    
    func getbackButton() -> UIButton {
        return backButton
    }
}
