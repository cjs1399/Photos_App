//
//  EditViewModel.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Photos
import RxCocoa
import RxSwift

protocol EditImageViewModelInput {
    func didTapEnterImageSelectButton()
    func didTapBackButtonInPhotoGalleryViewController()
    func didTapOptionButtonInPhotoGalleryViewController()
    func didTapBackButtonInPhotoDetailViewController()
    func didTapCellInPhotoDetailViewController()
    func didSwipeDownInPhotoDetailViewController(with progress: CGFloat, isCompleted: Bool)
    func didScrollToIndexInPhotoDetailViewController(_ index: Int)
    func didTapEditButtonInPhotoDetailViewController()
    func didTapBackButtonInEditViewController()
    func didTapOptionButtonInEditViewControllerNavigationBar()
    func didTapSaveInAlertViewController()
    func didTapCancelInAlertViewController()
    func didTapMenuItemInEditViewController(at index: Int)
    func didTapCloseButtonInEditViewController()
    func didTapCheckButtonInEditViewController()
}

protocol EditImageViewModelOutput {
    var galleryPermission: BehaviorRelay<Bool> { get }
    var pushToGalleryViewController: BehaviorRelay<Bool> { get }
    var popToPhotoGalleryViewController: BehaviorRelay<Bool> { get }
    var itemsInRow: BehaviorRelay<CGFloat> { get }
    var dismissToPhotoDetailViewController: BehaviorRelay<Bool> { get }
    var isMenuVisible: BehaviorRelay<Bool> { get }
    var currentIndex: BehaviorRelay<Int> { get }
    var swipeProgress: BehaviorRelay<CGFloat?> { get }
    var photos: BehaviorRelay<[PHAsset]> { get }
    var presnetToEditViewController: BehaviorRelay<Bool> { get }
    var dismissToEditViewController: BehaviorRelay<Bool> { get }
    var showAlertView: BehaviorRelay<Bool>{ get }
    var savePhoto: BehaviorRelay<Bool> { get }
    var dismissToAlertViewController: BehaviorRelay<Bool> { get }
    var selectedMenuIndex: BehaviorRelay<Int?> { get }
    var selectedMenuTitle: BehaviorRelay<String?> { get }
    var closeSelectOption: BehaviorRelay<Bool> { get }
    var checkSelectOption: BehaviorRelay<Bool> { get }
}

protocol EditViewModelType {
    var inputs: EditImageViewModelInput { get }
    var outputs: EditImageViewModelOutput { get }
}

final class EditImageViewModel: EditImageViewModelInput, EditImageViewModelOutput, EditViewModelType {

    
    var galleryPermission = BehaviorRelay<Bool>(value: false)
    var pushToGalleryViewController = BehaviorRelay<Bool>(value: false)
    var photos = BehaviorRelay<[PHAsset]>(value: [])
    var popToPhotoGalleryViewController = BehaviorRelay<Bool>(value: false)
    var itemsInRow = BehaviorRelay<CGFloat>(value: 4)
    var dismissToPhotoDetailViewController = BehaviorRelay<Bool>(value: false)
    var isMenuVisible = BehaviorRelay<Bool>(value: true)
    var currentIndex = BehaviorRelay<Int>(value: 0)
    var swipeProgress = BehaviorRelay<CGFloat?>(value: nil)
    var presnetToEditViewController = BehaviorRelay<Bool>(value: false)
    var dismissToEditViewController = BehaviorRelay<Bool>(value: false)
    
    var showAlertView = BehaviorRelay<Bool>(value: false)
    
    var savePhoto = BehaviorRelay<Bool>(value: false)
    var dismissToAlertViewController = BehaviorRelay<Bool>(value: false)
    
    
    var selectedMenuIndex = BehaviorRelay<Int?>(value: nil)
    var selectedMenuTitle = BehaviorRelay<String?>(value: nil)
    var closeSelectOption = BehaviorRelay<Bool>(value: false)
    var checkSelectOption = BehaviorRelay<Bool>(value: false)
    
    
    var inputs: EditImageViewModelInput { return self }
    var outputs: EditImageViewModelOutput { return self }
    
    var enterGalleryPermission: Bool?
    var galleryData: [PHAsset]?
    private let menuTitles = ["상점", "스퀘어", "필터", "필름", "효과", "텍스처", "성형", "텍스트", "스티커"]
    
    init() {
        fetchPhotos()
        enterGalleryPermission = false
    }
    
    func didTapEnterImageSelectButton() {
        fetchPhotos()
        photos.accept(galleryData ?? [])
        enterGalleryPermission ?? false ? pushToGalleryViewController.accept(true) : fetchPhotos()
    }
    
    func didTapBackButtonInPhotoGalleryViewController() {
        popToPhotoGalleryViewController.accept(true)
    }
    
    func didTapOptionButtonInPhotoGalleryViewController() {
        let currentRow = itemsInRow.value
        itemsInRow.accept(currentRow == 4 ? 3 : 4)
    }
    
    func didTapBackButtonInPhotoDetailViewController() {
        dismissToPhotoDetailViewController.accept(true)
        reloadGalleryPhotos()
    }
    
    func didTapCellInPhotoDetailViewController() {
        isMenuVisible.accept(!isMenuVisible.value)
    }
    
    func didScrollToIndexInPhotoDetailViewController(_ index: Int) {
        currentIndex.accept(index)
    }
    
    func didSwipeDownInPhotoDetailViewController(with progress: CGFloat, isCompleted: Bool) {
        if isCompleted && progress > 0.3 {
            dismissToPhotoDetailViewController.accept(true)
            reloadGalleryPhotos()
        } else {
            swipeProgress.accept(progress)
        }
    }
    
    func didTapEditButtonInPhotoDetailViewController() {
        presnetToEditViewController.accept(true)
    }
    
    func didTapBackButtonInEditViewController() {
        dismissToEditViewController.accept(true)
    }
    
    func didTapOptionButtonInEditViewControllerNavigationBar() {
        showAlertView.accept(true)
    }
    
    func didTapMenuItemInEditViewController(at index: Int) {
        selectedMenuIndex.accept(index)
        selectedMenuTitle.accept(menuTitles[index])
    }
    
    func didTapCloseButtonInEditViewController() {
        closeSelectOption.accept(true)
    }
    
    func didTapCheckButtonInEditViewController() {
        checkSelectOption.accept(true)
    }
    
    func didTapSaveInAlertViewController() {
        savePhoto.accept(true)
    }
    
    func didTapCancelInAlertViewController() {
        dismissToAlertViewController.accept(true)
    }
    
    private func fetchPhotos() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            loadPhotos()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self?.loadPhotos()
                    } else {
                        self?.galleryPermission.accept(true)
                    }
                }
            }
        case .denied, .restricted:
            galleryPermission.accept(true)

        @unknown default:
            print("알 수 없는 권한 상태")
        }
    }

    private func loadPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var assets: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }
        galleryData = assets
        enterGalleryPermission = true
    }
    
    private func reloadGalleryPhotos() {
        fetchPhotos()
        photos.accept(galleryData ?? [])
    }

}
