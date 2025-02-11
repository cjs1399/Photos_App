//
//  BottomActionBar.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit

class BottomActionBar: BaseView {
    
    // MARK: - UI Components
    
    private let editButton = UIButton()
    private let editButtonLabel = UILabel()
    
    // MARK: - UI Components Property
    
    override func setStyles() {
        backgroundColor = UIColor(hex: "#F9F9F9")
        
        editButton.do {
            $0.setImage(ImageLiterals.EditView.edit_ic, for: .normal)
        }
        
        editButtonLabel.do {
            $0.text = "편집"
            $0.textColor = UIColor(hex: "#3D3D3F")
            $0.font = .fontGuide(.editLabel)
        }
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        addSubviews(editButton, editButtonLabel)
        
        editButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(SizeLiterals.Screen.screenHeight * 10 / 844)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 39.46 / 844)
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 40 / 390)
        }
        
        editButtonLabel.snp.makeConstraints {
            $0.top.equalTo(editButton.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func getButton() -> UIButton {
        return editButton
    }
}
