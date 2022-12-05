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
        configure()
    }
    
    private func configure() {
        
        let effect = UIBlurEffect(style: .dark)
        
        let blur = UIVisualEffectView(effect: effect)
            .configure {
                $0.frame = view.frame
            }
        
        let backView = UIView()
            .configure {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.layer.cornerRadius = .regularCornerRadius
                $0.layer.masksToBounds = true
                $0.backgroundColor = .white.withAlphaComponent(.defaultAlpha)
            }
        
        let label = UILabel()
            .configure {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.text = .loading
                $0.textColor = .white
                $0.font = .systemFont(ofSize: .mediumFontSize, weight: .light)
            }
        
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
            .configure {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.tintColor = .white
                $0.color = .white
            }
        
        spinner.startAnimating()
        view.addSubview(backView)
        backView.addViews(label, spinner)
        view.insertSubview(blur, at: 0)
        
        NSLayoutConstraint.activate {
            backView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            backView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            backView.widthAnchor.constraint(equalToConstant: .defaultWidth)
            backView.heightAnchor.constraint(equalToConstant: .defaultWidth)
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            label.topAnchor.constraint(equalTo: backView.centerYAnchor, constant: -.titleInset)
            spinner.centerXAnchor.constraint(equalTo: backView.centerXAnchor)
            spinner.bottomAnchor.constraint(equalTo: backView.centerYAnchor, constant: .titleInset)
        }
    }
}
