//
//  FilterCollectionView.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit

final class FilterCollectionView: UICollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 12
            $0.minimumInteritemSpacing = 0
            $0.itemSize = CGSize(width: SizeLiterals.Screen.screenWidth * 50 / 390, height: SizeLiterals.Screen.screenHeight * 78 / 844)
        }
        
        super.init(frame: .zero, collectionViewLayout: layout)
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
        self.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "FilterCollectionViewCell")

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
