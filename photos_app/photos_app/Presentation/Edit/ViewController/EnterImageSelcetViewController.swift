//
//  EnterImageSelcetViewController.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

final class EnterImageSelcetViewController: BaseViewController {
    
    
    private let viewModel = EditImageViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let enterGalleryButton = EnterSelectGalleryView()
        
    override func bindViewModel() {
        enterGalleryButton.getEnterSelectViewButton().rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.didTapEnterImageSelectButton()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.pushToGalleryViewController
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.pushToPhotoGalleryViewController()
                self?.viewModel.outputs.pushToGalleryViewController.accept(false)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.galleryPermission
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.showPermissionAlert()
                self?.viewModel.outputs.galleryPermission.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    override func setStyles() {
        view.backgroundColor = UIColor(hex: "#F6F8F7")
        
        enterGalleryButton.do {
            $0.layer.cornerRadius = 15
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
        }
    }
    
    override func setLayout() {
        view.addSubviews(enterGalleryButton)
        
        enterGalleryButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(SizeLiterals.Screen.screenHeight * 406 / 844)
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * 348 / 390)
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 190 / 844)
        }
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "갤러리 접근 권한 필요",
            message: "사진을 불러오기 위해 갤러리 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        })
        present(alert, animated: true)
    }
    
    @objc
    private func pushToPhotoGalleryViewController() {
        let pushVC = PhotoGalleryViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
}

