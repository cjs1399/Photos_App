//
//  FilterCollectionViewCell.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit

final class FilterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView()
    private let buttonTitle = UILabel()
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyles()
        setLayout()
    }
    
    private func setStyles() {
        backgroundColor = .clear
        
        imageView.do {
            $0.layer.cornerRadius = 5
        }
        
        buttonTitle.do {
            $0.font = .fontGuide(.editBottomLabel)
            $0.textColor = UIColor(hex: "#FFFFFF")
        }
    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        contentView.addSubviews(imageView, buttonTitle)
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(SizeLiterals.Screen.screenHeight * 50 / 844)
        }
        
        buttonTitle.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(SizeLiterals.Screen.screenHeight * 2 / 844)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func configureCell(title: String, image: UIImage) {
        buttonTitle.text = title
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
