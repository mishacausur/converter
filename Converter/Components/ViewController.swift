//
//  ViewController.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.UIViewController

class ViewController<View: Viеw, ViewModеl: ViewModel>: UIViewController,
                                  ViewInput {

    let viewModel: ViewModеl
    private(set) lazy var mainView = createView()
    init(viewModel: ViewModеl) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createView() -> View {
        return View()
    }
}
