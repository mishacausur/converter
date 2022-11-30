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
        .init(
            buttonDidTapped: didButtonTapped
                .asSignal(),
            fieldValueEntered: didEnteredValue
                .asSignal(),
            convertButtonDidTapped: button.rx
                .tap
                .asSignal()
        )
    }
    
    func bind(to viewModel: MainViewModel_Arch) {
        
        viewModel.firstCurrency
            .drive(onNext: { [weak upperLabel = self.upperTextField] in
                upperLabel?.configureLabel(currency: $0.sign)
            })
            .disposed(by: disposeBag)
        
        viewModel.secondCurrency
            .drive(onNext: { [weak lowerLable = self.lowerTextField] in
                lowerLable?.configureLabel(currency: $0.sign)
            })
            .disposed(by: disposeBag)
        
        viewModel.valueEntered
            .drive { [weak button = self.button] in
                button?.isHidden = !$0
            }
            .disposed(by: disposeBag)
        
        viewModel.convertedValue.drive { [weak self] in
            /// обработать ошибку (прилетит в $0.0.success = false)
            self?.setupValue($0.0.result, label: $0.1)
        }
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
    
    /// Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        layout()
        bindActions()
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
    
    private func bindActions() {
       
        upperTextField.buttonDidTapped = { [weak button = self.didButtonTapped] in
            button?.accept(.upper)
        }
        lowerTextField.buttonDidTapped = { [weak button = self.didButtonTapped] in
            button?.accept(.lower)
        }
        upperTextField.valueDidEntered = { [weak field = self.didEnteredValue] in
            field?.accept((.upper, $0))
        }
        lowerTextField.valueDidEntered = { [weak field = self.didEnteredValue] in
            field?.accept((.lower, $0))
        }
    }
    
    private func setupValue(_ value: Double, label: CurrencyButton) {
        DispatchQueue.main.async { [weak upper = self.upperTextField,
                                    weak lower = self.lowerTextField] in
            switch label {
            case .upper:
                upper?.value = value
            case .lower:
                lower?.value = value
            }
        }
    }
}
