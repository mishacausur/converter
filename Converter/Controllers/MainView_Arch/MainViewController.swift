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
    private var showProgress: Bool = false {
        didSet {
            showActivity(showProgress)
        }
    }
    
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
            .drive(rx.showProgress)
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
            .top(to: ui.titleLabel.edge.bottom).marginTop(.titleInset)
            .hCenter()
            .sizeToFit()
        
        ui.lowerTextField.pin
            .top(to: ui.upperTextField.edge.bottom).marginTop(.defaultInset)
            .hCenter()
            .sizeToFit()
        
        ui.button.pin
            .topCenter(to: ui.lowerTextField.anchor.bottomCenter)
            .marginTop(.titleInset)
            .width(.defaultWidth)
            .height(.defaultHeight)
    }
    
    private func showActivity(_ show: Bool) {
        show
        ? add(ui.activityController)
        : ui.activityController.remove()
    }
}
