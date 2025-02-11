//
//  EditModeBottomView.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit

class EditModeBottomView: BaseView {
    
    // MARK: - UI Components
    
    private let closeButton = UIButton()
    private let optionNoticeLabel = UILabel()
    private let checkButton = UIButton()
    
    override func setStyles() {
        backgroundColor = UIColor(hex: "#000000")
        
        closeButton.do {
            $0.setImage(ImageLiterals.editModeMenu.close_ic, for: .normal)
        }
        
        optionNoticeLabel.do {
            $0.textColor = UIColor(hex: "#FFFFFF")
            $0.font = .fontGuide(.noticeLabel)
        }
        
        checkButton.do {
            $0.setImage(ImageLiterals.editModeMenu.check_ic, for: .normal)
        }
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        addSubviews(closeButton, optionNoticeLabel, checkButton)
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(SizeLiterals.Screen.screenHeight * 11 / 844)
            $0.leading.equalToSuperview().offset(SizeLiterals.Screen.screenWidth * 7 / 390)
            $0.width.height.equalTo(SizeLiterals.Screen.screenHeight * 24 / 844)
        }
        
        optionNoticeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(SizeLiterals.Screen.screenHeight * 10 / 844)
        }
        
        checkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(SizeLiterals.Screen.screenHeight * 11 / 844)
            $0.trailing.equalToSuperview().offset(-SizeLiterals.Screen.screenWidth * 7 / 390)
            $0.width.height.equalTo(SizeLiterals.Screen.screenHeight * 24 / 844)
        }
    }
    
    // MARK: - Methods
    
    func getCloseButtonButton() -> UIButton {
        return closeButton
    }
    
    func getCheckButton() -> UIButton {
        return checkButton
    }
    
    func getOptionNoticeLabel() -> UILabel {
        return optionNoticeLabel
    }
}
