//
//  EditViewController.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

final class EditViewController: BaseViewController {
    
    private let viewModel: EditImageViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let customNavigationBar = CustomPhotoNavigationBar(
        frame: .zero,
        title: "편집",
        backButtonImage: ImageLiterals.EditView.back_ic,
        optionButtonImage: ImageLiterals.EditView.share_ic,
        backgroundColor: UIColor(hex: "#1C1C1C")
    )
    private let imageView = UIImageView()
    private let bottomEditOptionItemBar = EditOptionBottomCollectionView()
    private let bottomEditOptionCollectionView = FilterCollectionView()
    private let editModeBottomBarView = EditModeBottomView()
    private let noticeSelectFilterLabel = UILabel()
    private let toastSelcetFilter = CustomToastView()
    private let alertView = CustomAlertViewController(frame: .zero, alertText: "사진을 저장하시겠습니까?")
    
    // MARK: - Properties
    
    private var image: UIImage
    private var filterImage: UIImage
    private var startingFrame: CGRect
    private var isMoved: Bool
    private var imageViewConstraint: Constraint?
    private var data: [String] = ["Cool", "Dramatic", "Chill", "Vintage"]
    
    init(viewModel: EditImageViewModel, image: UIImage, startingFrame: CGRect) {
        self.viewModel = viewModel
        self.image = image
        self.startingFrame = startingFrame
        self.isMoved = false
        self.filterImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialImagePosition()
        configureCollectionViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImageToTargetSize()
    }
    
    override func bindViewModel() {
        customNavigationBar.getBackButtonTappedInNavigationBar().rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.didTapBackButtonInEditViewController()
            })
            .disposed(by: disposeBag)
        
        customNavigationBar.getOptionButtonTappedInNavigationBar().rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.didTapOptionButtonInEditViewControllerNavigationBar()
            })
            .disposed(by: disposeBag)
        
        editModeBottomBarView.getCloseButtonButton().rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.didTapCloseButtonInEditViewController()
            })
            .disposed(by: disposeBag)
        
        editModeBottomBarView.getCheckButton().rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.didTapCheckButtonInEditViewController()
            })
            .disposed(by: disposeBag)
        
        alertView.getYesButton().rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.didTapSaveInAlertViewController()
            })
            .disposed(by: disposeBag)
        
        alertView.getNoButton().rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.didTapCancelInAlertViewController()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.dismissToEditViewController
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: false)
                self?.viewModel.outputs.dismissToEditViewController.accept(false)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.showAlertView
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.showAlertView()
                self?.viewModel.outputs.showAlertView.accept(false)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.savePhoto
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.alertView.dismissAlertViewController()
                guard let imageToSave = self?.imageView.image else {
                    return
                }
                self?.saveImageToGallery(image: imageToSave)
                self?.viewModel.outputs.savePhoto.accept(false)
            })
            .disposed(by: disposeBag)

        
        viewModel.outputs.dismissToAlertViewController
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.alertView.dismissAlertViewController()
                self?.viewModel.outputs.dismissToAlertViewController.accept(false)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.selectedMenuIndex
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                self?.handleMenuSelection()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.selectedMenuTitle
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] title in
                self?.editModeBottomBarView.getOptionNoticeLabel().text = title
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.closeSelectOption
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.handleMenuSelection()
                self?.viewModel.outputs.closeSelectOption.accept(false)
                self?.imageView.image = self?.image
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.checkSelectOption
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.handleMenuSelection()
                self?.viewModel.outputs.checkSelectOption.accept(false)
                self?.imageView.image = self?.filterImage
            })
            .disposed(by: disposeBag)
    }
    
    override func setStyles() {
        view.backgroundColor = UIColor(hex: "#1C1C1C")
        customNavigationBar.do {
            $0.getTitleLabel().font = .fontGuide(.titleLabel)
            $0.getTitleLabel().textColor = UIColor(hex: "#FFFFFF")
            $0.isHidden = false
        }
        
        imageView.do {
            $0.image = image
            $0.contentMode = .scaleAspectFit
        }
        
        bottomEditOptionItemBar.do {
            $0.backgroundColor = UIColor(hex: "#1C1C1C")
            $0.isHidden = false
        }
        
        bottomEditOptionCollectionView.do {
            $0.backgroundColor = UIColor(hex: "#1C1C1C")
            $0.isHidden = true
        }
        
        editModeBottomBarView.do {
            $0.isHidden = true
        }
        
        noticeSelectFilterLabel.do {
            $0.font = .fontGuide(.noticeSelectFilter)
            $0.textColor = UIColor(hex: "#FFFFFF")
            $0.isHidden = true
        }
    }
    
    override func setLayout() {
        view.addSubviews(customNavigationBar, imageView, bottomEditOptionItemBar,
                         editModeBottomBarView, bottomEditOptionCollectionView)
        
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 108 / 844)
        }
        
        bottomEditOptionItemBar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(SizeLiterals.Screen.screenWidth * 5 / 390)
            $0.bottom.trailing.equalToSuperview()
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 120 / 844)
        }
        
        editModeBottomBarView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 78 / 844)
        }
        
        bottomEditOptionCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(editModeBottomBarView.snp.top)
            $0.height.equalTo(SizeLiterals.Screen.screenHeight * 78 / 844)
        }
    }
    
    override func setDelegates() {
        bottomEditOptionItemBar.dataSource = self
        bottomEditOptionItemBar.delegate = self
        bottomEditOptionCollectionView.dataSource = self
        bottomEditOptionCollectionView.delegate = self
    }
    
    // MARK: - Methods
    
    private func configureCollectionViews() {
        bottomEditOptionItemBar.tag = 0
        bottomEditOptionCollectionView.tag = 1
    }
    
    private func handleMenuSelection() {
        let imageViewWidth = imageView.frame.width
        UIView.animate(withDuration: 0.3, animations: {
            if self.isMoved {
                self.imageViewConstraint?.update(offset: 0)
            } else {
                
                if imageViewWidth > SizeLiterals.Screen.screenWidth * 284 / 390 {
                    self.imageViewConstraint?.update(offset: -100)
                } else {
                    self.imageViewConstraint?.update(offset: -95)
                }
            }
            self.customNavigationBar.isHidden = !self.isMoved
            self.bottomEditOptionItemBar.isHidden = !self.isMoved
            self.bottomEditOptionCollectionView.isHidden = self.isMoved
            self.editModeBottomBarView.isHidden = self.isMoved
            self.view.layoutIfNeeded()
        })
        isMoved.toggle()
    }
    
    private func setupInitialImagePosition() {
        imageView.frame = startingFrame
        view.addSubview(imageView)
    }
    
    private func animateImageToTargetSize() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.configureDynamicImageLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    private func configureDynamicImageLayout() {
        let imageAspectRatio = image.size.width / image.size.height
        let screenAspectRatio = SizeLiterals.Screen.screenWidth / SizeLiterals.Screen.screenHeight
        
        imageView.snp.remakeConstraints { make in
            if imageAspectRatio > screenAspectRatio {
                make.width.equalTo(SizeLiterals.Screen.screenWidth * 370 / 390)
                make.height.equalTo(SizeLiterals.Screen.screenWidth / imageAspectRatio)
                make.centerX.equalToSuperview()
                self.imageViewConstraint = make.centerY.equalToSuperview().constraint
            } else {
                make.height.equalTo(SizeLiterals.Screen.screenHeight * 616 / 844)
                make.width.equalTo(SizeLiterals.Screen.screenWidth * 284 / 390)
                make.centerX.equalToSuperview()
                self.imageViewConstraint = make.centerY.equalToSuperview().constraint
            }
        }
    }
    
    private func showAlertView() {
        present(alertView, animated: false, completion: nil)
    }

    private func saveImageToGallery(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func saveImageCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
            self.toastSelcetFilter.showToast(in: self.view, message: "사진 저장 실패")
        } else {
            print("Image saved successfully!")
            self.toastSelcetFilter.showToast(in: self.view, message: "사진이 저장되었습니다.")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bottomEditOptionCollectionView {
            return data.count
        } else {
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bottomEditOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let title = data[indexPath.item]
             cell.configureCell(title: title, image: image)
             return cell
        } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditCollectionViewCell", for: indexPath) as? EditCollectionViewCell else {
                    return UICollectionViewCell()
                }
                let titles = ["상점", "스퀘어", "필터", "필름", "효과", "텍스처", "성형", "텍스트", "스티커"]
                cell.configureCell(title: titles[indexPath.item], index: indexPath.item)
                return cell
            }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bottomEditOptionCollectionView {
            let item = data[indexPath.item]
            self.view.bringSubviewToFront(toastSelcetFilter)
            toastSelcetFilter.showToast(in: self.view, message: item)
            imageView.image = image
            
            let originalImage = imageView.image!
            if let filterParameters = loadFilterParameters(from: "\(item)") {
                let imageFilter = ImageFilter()
                let filteredImage = imageFilter.applyFilters(to: originalImage, with: filterParameters)
                imageView.image = filteredImage
                filterImage = filteredImage
            } else {
                print("\(item).json을 찾을 수 없습니다")
            }
        } else {
            viewModel.inputs.didTapMenuItemInEditViewController(at: indexPath.item)
        }
    }
}
