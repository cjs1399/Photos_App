//
//  CustomNavigationBar.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit

final class CustomPhotoNavigationBar: BaseView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    private let optionButton = UIButton()
    
    // MARK: - Initializer
    
    init(frame: CGRect, title: String, backButtonImage: UIImage, optionButtonImage: UIImage, backgroundColor: UIColor) {
        super.init(frame: frame)
        setNavigationBarItem(titleString: title, backButtonImage: backButtonImage,
                             optionButtonImage: optionButtonImage, backgroundColor: backgroundColor)
    }
    
    override func setStyles() {
        titleLabel.do {
            $0.textColor = UIColor(hex: "#3D3D3F")
            $0.font = .fontGuide(.noticeLabel)
            $0.textAlignment = .center
        }
    }
    
    override func setLayout() {
        self.addSubviews(titleLabel, backButton, optionButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(SizeLiterals.Screen.screenHeight * 57 / 844)
            $0.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(SizeLiterals.Screen.screenWidth * 26 / 390)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(24)
        }
        
        optionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-SizeLiterals.Screen.screenWidth * 26 / 390)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(24)
        }
    }
    

    
    private func setNavigationBarItem(titleString: String, backButtonImage: UIImage, optionButtonImage: UIImage, backgroundColor: UIColor) {
        titleLabel.text = titleString
        backButton.setImage(backButtonImage, for: .normal)
        optionButton.setImage(optionButtonImage, for: .normal)
        self.backgroundColor = backgroundColor
    }
    
    
    func getBackButtonTappedInNavigationBar() -> UIButton {
        return backButton
    }
    
    
    func getOptionButtonTappedInNavigationBar() -> UIButton {
        return optionButton
    }
    
    func getTitleLabel() -> UILabel {
        return titleLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
