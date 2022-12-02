//
//  MainViewController_Arch.swift
//  Converter
//
//  Created by Misha Causur on 25.11.2022.
//

import UIKit
import RxCocoa
import RxSwift

final class MainViewController_Arch: UIViewController, ViewType {
    
    // MARK: - ViewType
    typealias ViewModel = MainViewModel_Arch
    
    var bindings: ViewModel.Bindings {
        
        let didTapUpperField = upperTextField
            .didTapButton
            .map { _ in CurrencyButton.upper }
        
        let didTapLowerField = lowerTextField
            .didTapButton
            .map { _ in CurrencyButton.lower }
        
        let didEnterUpperValue = upperTextField
            .didEnterTextFieldValue
            .map { (CurrencyButton.upper, $0) }
        
        let didEnterLowerValue = lowerTextField
            .didEnterTextFieldValue
            .map { (CurrencyButton.lower, $0) }
        
        return .init(
            didTapButton: .merge(
                didTapUpperField,
                didTapLowerField
            ),
            didEnterFieldValue: .merge(
                didEnterUpperValue,
                didEnterLowerValue
            ),
            didTapConvertButton: button.rx
                .tap
                .asSignal()
        )
    }
    
    func bind(to viewModel: MainViewModel_Arch) {
        
        viewModel.upperCurrency
            .drive(Binder(upperTextField) {
                $0.configureLabel(currency: $1)
            })
            .disposed(by: disposeBag)
        
        viewModel.lowerCurrency
            .drive(Binder(lowerTextField) {
                $0.configureLabel(currency: $1)
            })
            .disposed(by: disposeBag)
        
        viewModel.upperFieldValue
            .drive(Binder(upperTextField) {
                $0.value = $1
            })
            .disposed(by: disposeBag)
        
        viewModel.lowerFieldValue
            .drive(Binder(lowerTextField) {
                $0.value = $1
            })
            .disposed(by: disposeBag)
        
        viewModel.isConvertButtonHidden
            .map(!)
            .drive(button.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .drive {
                print($0)
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .drive(Binder(self) {
                $0.showActivity($1)
            })
            .disposed(by: disposeBag)
        
        viewModel.disposables
            .disposed(by: disposeBag)
    }
    
    // MARK: - PRIVATE PROPS
    private let disposeBag = DisposeBag()
    private let didButtonTapped = PublishRelay<CurrencyButton>()
    private let didEnteredValue = PublishRelay<(CurrencyButton, String)>()
    
    // MARK: - UI
    private let titleLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = .mainViewTitle
        $0.font = .systemFont(ofSize: .largeFontSize, weight: .bold)
    }
    private let upperTextField = MainViewTextField()
    private let lowerTextField = MainViewTextField()
    private let button = UIFactory.createButton(with: .convert).configure { $0.isHidden = true }
    private let activityController = ActivityViewController()
    
    /// Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        layout()
    }
    
    private func addViews() {
        view.addViews(titleLabel, upperTextField, lowerTextField, button)
    }
    
    private func layout() {
        [upperTextField, lowerTextField].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate  {
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 122)
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            upperTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            upperTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .titleInset)
            lowerTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            lowerTextField.topAnchor.constraint(equalTo: upperTextField.bottomAnchor, constant: .defaultInset)
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            button.topAnchor.constraint(equalTo: lowerTextField.bottomAnchor, constant: .defaultInset)
            button.widthAnchor.constraint(equalToConstant: .defaultWidth)
            button.heightAnchor.constraint(equalToConstant: .defaultHeight)
        }
    }
    
    private func showActivity(_ show: Bool) {
        show ? add(activityController) : activityController.remove()
    }
}
