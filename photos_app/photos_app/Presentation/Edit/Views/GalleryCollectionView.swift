//
//  GalleryCollectionView.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit

enum CollectionViewType {
    case gallery
    case detail
}

final class GalleryCollectionView: UICollectionView {
    
    // MARK: - Properties
    private var itemsInRow: CGFloat
    private let itemSpacing: CGFloat
    private var collectionViewType: CollectionViewType
    
    // MARK: - Initializer
    init(collectViewType: CollectionViewType,itemsInRow: CGFloat, itemSpacing: CGFloat) {
        self.itemsInRow = itemsInRow
        self.itemSpacing = itemSpacing
        self.collectionViewType = collectViewType
        
        switch collectionViewType {
        case .detail:
            let layout = UICollectionViewFlowLayout().then {
                $0.scrollDirection = .horizontal
                $0.minimumLineSpacing = 0
                $0.itemSize = UIScreen.main.bounds.size
            }

            super.init(frame: .zero, collectionViewLayout: layout)
            self.isPagingEnabled = true
            self.showsHorizontalScrollIndicator = false
            self.clipsToBounds = true
        case .gallery:
            let layout = UICollectionViewFlowLayout().then {
                $0.minimumLineSpacing = itemSpacing
                $0.minimumInteritemSpacing = itemSpacing
                let totalSpacing = itemSpacing * (itemsInRow - 1)
                let itemWidth = (SizeLiterals.Screen.screenWidth - totalSpacing) / itemsInRow
                $0.itemSize = CGSize(width: itemWidth, height: itemWidth)
            }
            super.init(frame: .zero, collectionViewLayout: layout)
        }
        self.backgroundColor = .clear
    }

    func updateItemsInRow(_ newItemsInRow: CGFloat) {
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        self.itemsInRow = newItemsInRow
        
        let totalSpacing = itemSpacing * (newItemsInRow - 1)
        let itemWidth = (SizeLiterals.Screen.screenWidth - totalSpacing) / newItemsInRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        layout.invalidateLayout() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

