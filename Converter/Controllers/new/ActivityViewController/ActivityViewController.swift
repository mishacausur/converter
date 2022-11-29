//
//  ActivityViewController.swift
//  Converter
//
//  Created by Misha Causur on 30.10.2022.
//

import UIKit

final class ActivityViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate {
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        }
    }
}
