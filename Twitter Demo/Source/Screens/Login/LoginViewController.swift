//
//  LoginViewController.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 15/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class LoginViewController: UIViewController, Binder {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = TwitterService.LogInButton()
        loginButton.logInCompletion = viewModel.loginHandler
        
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        addBinds(to: viewModel)
    }
    
    private func addBinds(to viewModel: LoginViewModel) {
        bind(viewModel.titleDriver, to: titleLabel.rx.text)
        bind(viewModel.subTitleDriver, to: subtitleLabel.rx.text)
    }
}
