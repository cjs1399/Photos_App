//
//  PhotoDetailViewController.swift
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

final class PhotoDetailViewController: BaseViewController {

    private var viewModel: EditImageViewModel
    private let disposeBag = DisposeBag()

    // MARK: - UI Components

    private let customNavigationBar = CustomPhotoNavigationBar(
        frame: .zero,
        title: "",
        backButtonImage: ImageLiterals.EditView.back_dark_ic,
        optionButtonImage: ImageLiterals.EditView.share_dark_ic,
        backgroundColor: UIColor(hex: "#E9E2DD")
    )

    private lazy var detailCollectionView = GalleryCollectionView(
        collectViewType: .detail,
        itemsInRow: 1,
        itemSpacing: 0
    )
    private let bottomActionBar = BottomActionBar()

    // MARK: - Properties
    private var assets: [PHAsset]
    private var currentIndex: Int
    private let imageManager = PHImageManager.default()
    private var isMenuVisible = false
    private var panGestureRecognizer: UIPanGestureRecognizer!

    // MARK: - Initializer
    init(viewModel: EditImageViewModel, assets: [PHAsset], currentIndex: Int) {
        self.assets = assets
        self.currentIndex = currentIndex
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPanGesture()
        updateNavigationBarTitle()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
    }

    override func bindViewModel() {
        customNavigationBar.getBackButtonTappedInNavigationBar().rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.didTapBackButtonInPhotoDetailViewController()
            })
            .disposed(by: disposeBag)
        
        bottomActionBar.getButton().rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.didTapEditButtonInPhotoDetailViewController()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.dismissToPhotoDetailViewController
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
                self?.viewModel.outputs.dismissToPhotoDetailViewController.accept(false)
                self?.viewModel.outputs.isMenuVisible.accept(true)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.isMenuVisible
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isVisible in
                UIView.animate(withDuration: 0.3) {
                    self?.customNavigationBar.alpha = isVisible ? 1.0 : 0.0
                    self?.bottomActionBar.alpha = isVisible ? 1.0 : 0.0
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.currentIndex
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                self?.updateNavigationBarTitle(with: index)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.presnetToEditViewController
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.presentToEditViewController()
                self?.viewModel.outputs.presnetToEditViewController.accept(false)
            })
            .disposed(by: disposeBag)
    }

    override func setStyles() {
        view.backgroundColor = UIColor(hex: "#FFFFFF")
    }

    override func setLayout() {
        view.addSubviews(detailCollectionView, customNavigationBar, bottomActionBar)
        
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 91 / 844)
        }
        
        detailCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomActionBar.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 108 / 844)
        }
    }
    
    override func setRegister() {
        detailCollectionView.register(PhotoDetailCell.self, forCellWithReuseIdentifier: "PhotoDetailCell")
    }

    override func setDelegates() {
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
    }
    
    private func updateNavigationBarTitle() {
        customNavigationBar.getTitleLabel().text = "\(currentIndex + 1) / \(assets.count)"
    }
    
    private func updateNavigationBarTitle(with index: Int) {
        customNavigationBar.getTitleLabel().text = "\(index + 1) / \(assets.count)"
    }
    
    private func setupPanGesture() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func presentToEditViewController() {
        guard let selectedCell = detailCollectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? PhotoDetailCell,
              let selectedImageView = selectedCell.getImageView() else { return }
        
        let startingFrame = selectedImageView.superview?.convert(selectedImageView.frame, to: nil) ?? .zero
        
        let editVC = EditViewController(viewModel: viewModel, image: selectedImageView.image ?? UIImage(), startingFrame: startingFrame)
        editVC.modalPresentationStyle = .fullScreen
        present(editVC, animated: false, completion: nil)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            let velocity = panGestureRecognizer.velocity(in: view)
            return abs(velocity.y) > abs(velocity.x)
        }
        return false
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func handleCellTap() {
        viewModel.inputs.didTapCellInPhotoDetailViewController()
    }
    
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let progress = max(0, translation.y / view.bounds.height)

        switch gesture.state {
        case .changed:
            let translationTransform = CGAffineTransform(translationX: 0, y: translation.y)
            view.transform = translationTransform
            view.alpha = max(0.5, 1 - progress)
        case .ended:
            if progress > 0.3 {
                viewModel.inputs.didSwipeDownInPhotoDetailViewController(with: progress, isCompleted: true)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                    self.view.alpha = 1
                }
            }
        default:
            break
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoDetailCell", for: indexPath) as? PhotoDetailCell else {
            return UICollectionViewCell()
        }

        let asset = assets[indexPath.item]
        let targetSize = UIScreen.main.bounds.size
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil) { image, _ in
            cell.configure(with: image)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        cell.contentView.addGestureRecognizer(tapGesture)
        cell.contentView.isUserInteractionEnabled = true
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        let visibleIndex = Int(scrollView.contentOffset.x / collectionView.bounds.width)
        currentIndex = visibleIndex
        viewModel.inputs.didScrollToIndexInPhotoDetailViewController(currentIndex)
    }
}
