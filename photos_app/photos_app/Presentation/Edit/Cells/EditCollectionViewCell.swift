//
//  EditCollectionViewCell.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit

final class EditCollectionViewCell: UICollectionViewCell {
    
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
        
        
        buttonTitle.do {
            $0.font = .fontGuide(.editBottomLabel)
            $0.textColor = UIColor(hex: "#FFFFFF")
        }
    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        
        contentView.addSubviews(imageView, buttonTitle)
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(SizeLiterals.Screen.screenHeight * 27 / 844)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(SizeLiterals.Screen.screenHeight * 24 / 844)
        }
        
        buttonTitle.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(SizeLiterals.Screen.screenHeight * 10 / 844)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func configureCell(title: String, index: Int) {
        buttonTitle.text = title
        setImage(index)
    }

    private func setImage(_ index: Int) {
        let image: UIImage
        switch index {
        case 0:
            image = ImageLiterals.BottomMenu.shopping_ic
        case 1:
            image = ImageLiterals.BottomMenu.square_ic
        case 2:
            image = ImageLiterals.BottomMenu.filter_ic
        case 3:
            image = ImageLiterals.BottomMenu.film_ic
        case 4:
            image = ImageLiterals.BottomMenu.effect_ic
        case 5:
            image = ImageLiterals.BottomMenu.texture_ic
        case 6:
            image = ImageLiterals.BottomMenu.plastic_surgery_ic
        case 7:
            image = ImageLiterals.BottomMenu.text_ic
        case 8:
            image = ImageLiterals.BottomMenu.heart_ic
        default:
            return
        }
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
