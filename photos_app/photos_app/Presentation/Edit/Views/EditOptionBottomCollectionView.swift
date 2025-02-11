//
//  EditOptionBottomCollectionView.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit

final class EditOptionBottomCollectionView: UICollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
            $0.itemSize = CGSize(width: SizeLiterals.Screen.screenWidth * 65 / 390, height: SizeLiterals.Screen.screenHeight * 120 / 844)
        }
        
        super.init(frame: .zero, collectionViewLayout: layout)
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
        self.register(EditCollectionViewCell.self, forCellWithReuseIdentifier: "EditCollectionViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
