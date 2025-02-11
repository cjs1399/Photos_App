//
//  EnterSelectGalleryView.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit

class EnterSelectGalleryView: BaseView {
    
    // MARK: - UI Components
    
    private let enterSelectViewButton = UIButton()
    private let noticeLabel = UILabel()
    
    override func setStyles() {
        enterSelectViewButton.do {
            $0.setImage(ImageLiterals.EditView.add_photo_ic, for: .normal)
            $0.clipsToBounds = true
        }
        
        noticeLabel.do {
            $0.text = "편집을 원하는 사진을 선택해주세요"
            $0.font = .fontGuide(.noticeLabel)
            $0.textColor = UIColor(hex: "#000000")
        }
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        addSubviews(enterSelectViewButton, noticeLabel)
        
        enterSelectViewButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 100 / 844)
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 138.39 / 390)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(enterSelectViewButton.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func getEnterSelectViewButton() -> UIButton {
        return enterSelectViewButton
    }
}
