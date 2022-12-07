//
//  MainViewController_Arch.swift
//  Converter
//
//  Created by Misha Causur on 25.11.2022.
//

import RxCocoa
import RxSwift
import UIKit

final class MainViewScreenBuilder: ScreenBuilder {
    
    typealias VC = MainViewController
    
    var dependencies: MainViewModel.Dependencies {
        .init(
            networkService: .init()
        )
    }
}

final class MainViewController: UIViewController {
    
    private lazy var ui = createUI()
    private let disposeBag = DisposeBag()
    private let didButtonTapped = PublishRelay<CurrencyButton>()
    private let didEnteredValue = PublishRelay<(CurrencyButton, String)>()
   
    override func viewDidLayoutSubviews() {
        layout()
    }
}

extension MainViewController: ViewType {
    
    typealias ViewModel = MainViewModel
    
    var bindings: ViewModel.Bindings {
        
        let didTapUpperField = ui.upperTextField
            .didTapButton
            .map { _ in CurrencyButton.upper }
        
        let didTapLowerField = ui.lowerTextField
            .didTapButton
            .map { _ in CurrencyButton.lower }
        
        let didEnterUpperValue = ui.upperTextField
            .didEnterTextFieldValue
            .map { (CurrencyButton.upper, $0) }
        
        let didEnterLowerValue = ui.lowerTextField
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
            didTapConvertButton: ui.button.rx
                .tap
                .asSignal()
        )
    }
    
    func bind(to viewModel: MainViewModel) {
        
        viewModel.upperCurrency
            .drive(Binder(ui.upperTextField) {
                $0.configureLabel(currency: $1)
            })
            .disposed(by: disposeBag)
        
        viewModel.lowerCurrency
            .drive(Binder(ui.lowerTextField) {
                $0.configureLabel(currency: $1)
            })
            .disposed(by: disposeBag)
        
        viewModel.upperFieldValue
            .drive(ui.upperTextField.rx.value)
            .disposed(by: disposeBag)
        
        viewModel.lowerFieldValue
            .drive(ui.lowerTextField.rx.value)
            .disposed(by: disposeBag)
        
        viewModel.isConvertButtonHidden
            .map(!)
            .drive(ui.button.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .drive(Binder(self) {
                $0.showActivity($1)
            })
            .disposed(by: disposeBag)
        
        viewModel.disposables
            .disposed(by: disposeBag)
    }
}

private extension MainViewController {
    struct UI {
        let titleLabel: UILabel
        let upperTextField: MainViewTextField
        let lowerTextField: MainViewTextField
        let button: Button
        let activityController: ActivityViewController
    }
    
    func createUI() -> UI {
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
            .configure {
                $0.text = .mainViewTitle
                $0.font = .systemFont(ofSize: .largeFontSize, weight: .bold)
            }
        let upperTextField = MainViewTextField()
        let lowerTextField = MainViewTextField()
        let button = UIFactory.createButton(with: .convert)
        let activityController = ActivityViewController()
        
        view.addViews(
            titleLabel,
            upperTextField,
            lowerTextField,
            button
        )
        
        return .init(
            titleLabel: titleLabel,
            upperTextField: upperTextField,
            lowerTextField: lowerTextField,
            button: button,
            activityController: activityController
        )
    }
    
    func layout() {
        
        ui.titleLabel.pin
            .topCenter(view.pin.safeArea.top)
            .sizeToFit()
        
        ui.upperTextField.pin
            .below(of: ui.titleLabel).marginTop(.titleInset)
            .hCenter()
        
            .wrapContent()
        
        ui.lowerTextField.pin
            .below(of: ui.upperTextField).marginTop(.defaultInset)
            .hCenter()
        
            .wrapContent()
        
        ui.button.pin
            .below(of: ui.lowerTextField)
            .marginTop(.titleInset)
            .hCenter()
            .width(.defaultWidth)
            .height(.defaultHeight)
    }
    
    func showActivity(_ show: Bool) {
        show ? add(ui.activityController) : ui.activityController.remove()
    }
}
