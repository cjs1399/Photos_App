//
//  GalleryEmptyView.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//


import UIKit

import Then
import SnapKit

class GalleryEmptyView: BaseView {
    
    // MARK: - UI Components
    
    private let emptyLabel = UILabel()
    
    override func setStyles() {
        backgroundColor = .clear
        
        emptyLabel.do {
            $0.text = "갤러리에 사진이 없습니다😥\n사진을 편집하기 위해 사진을 촬영해주세요"
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.textColor = UIColor(hex: "#1C1C1C")
            $0.font = .fontGuide(.noticeLabel)
        }
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        addSubviews(emptyLabel)
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    // MARK: - @objc Methods
    
}
