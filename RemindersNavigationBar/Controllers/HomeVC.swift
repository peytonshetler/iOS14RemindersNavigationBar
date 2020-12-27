//
//  ViewController.swift
//  RemindersNavigationBar
//
//  Created by Peyton Shetler on 12/26/20.
//

import UIKit

class HomeVC: UIViewController {
    
    let actionButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureActionButton()
    }
    
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
    }
    

    private func configureActionButton() {
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        actionButton.setTitle("Tap Me", for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        actionButton.setTitleColor(.systemBlue, for: .normal)
        actionButton.sizeToFit()
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    @objc func actionButtonTapped() {
        let destinationVC = UINavigationController(rootViewController: ModalVC())
        
        present(destinationVC, animated: true, completion: nil)
    }
}

