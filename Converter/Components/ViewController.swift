//
//  ViewController.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//

import UIKit.UIViewController

class ViewController<View: Viеw, viewModel: ViewModel>: UIViewController,
                                  ViewInput {
    
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = createView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createView() -> View {
        return View()
    }
}
