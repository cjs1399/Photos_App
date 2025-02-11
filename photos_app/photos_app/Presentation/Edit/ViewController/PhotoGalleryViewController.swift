//
//  PhotoGalleryViewController.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Photos
import Then
import SnapKit
import RxSwift
import RxCocoa

final class PhotoGalleryViewController: BaseViewController {
    
    private var viewModel: EditImageViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let customNavigationBar = CustomPhotoNavigationBar(
        frame: .zero,
        title: "최근 항목",
        backButtonImage: ImageLiterals.EditView.back_dark_ic,
        optionButtonImage: ImageLiterals.EditView.grid_ic_3,
        backgroundColor: UIColor(hex: "#E9E2DD")
    )
    private lazy var galleryCollectionView = GalleryCollectionView(collectViewType: .gallery, itemsInRow: 4, itemSpacing: 1)
    private let emptyView = GalleryEmptyView()
    
    // MARK: - Properties
    
    private var assets: [PHAsset] = []
    private var itemsInRow: CGFloat = 4
    private let itemSpacing: CGFloat = 1
    
    // MARK: - Initializer
    
    init(viewModel: EditImageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEmptyViewVisibility()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !assets.isEmpty {
            let lastIndexPath = IndexPath(item: assets.count - 1, section: 0)
            galleryCollectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: false)
        }
    }
    
    override func bindViewModel() {
        customNavigationBar.getBackButtonTappedInNavigationBar().rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.didTapBackButtonInPhotoGalleryViewController()
            })
            .disposed(by: disposeBag)
        
        customNavigationBar.getOptionButtonTappedInNavigationBar().rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.didTapOptionButtonInPhotoGalleryViewController()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.photos
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] assets in
                self?.assets = assets
                self?.galleryCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.popToPhotoGalleryViewController
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
                self?.viewModel.outputs.popToPhotoGalleryViewController.accept(false)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.itemsInRow
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] itemsInRow in
                self?.galleryCollectionView.updateItemsInRow(itemsInRow)
                self?.toggleGridLayout()
            })
            .disposed(by: disposeBag)
    }
    
    override func setStyles() {
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        emptyView.do {
            $0.isHidden = true
        }
    }
    
    override func setLayout() {
        view.addSubviews(customNavigationBar, galleryCollectionView, emptyView)
        
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 91 / 844)
        }
        
        galleryCollectionView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.edges.equalTo(galleryCollectionView)
        }
    }
    
    override func setRegister() {
        galleryCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }
    
    override func setDelegates() {
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
    }
    
    private func toggleGridLayout() {
        guard let firstVisibleIndexPath = galleryCollectionView.indexPathsForVisibleItems.min() else { return }
        DispatchQueue.main.async {
            self.galleryCollectionView.scrollToItem(at: firstVisibleIndexPath, at: .top, animated: false)
        }
    }
    
    private func updateEmptyViewVisibility() {
        if assets.isEmpty {
            emptyView.isHidden = false
            galleryCollectionView.isHidden = true
        } else {
            emptyView.isHidden = true
            galleryCollectionView.isHidden = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        let asset = assets[indexPath.item]
        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: cell.bounds.width, height: cell.bounds.height)
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { image, _ in
            cell.configure(with: image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = PhotoDetailViewController(viewModel: viewModel, assets: assets, currentIndex: indexPath.item)
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true, completion: nil)
    }
}
