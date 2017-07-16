//
//  ProfileViewController.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Kingfisher

final class ProfileViewController: UIViewController, Binder {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBinds(to: viewModel)
    }
    
    private func addBinds(to viewModel: ProfileViewModel) {
        viewModel.avatarImageURLDriver
            .map { URL(string: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .drive(onNext: { [unowned self] url in
                let radius = self.avatarImageView.frame.size.height
                let processor = RoundCornerImageProcessor(cornerRadius: radius)
                self.avatarImageView.kf.setImage(with: url, options: [.processor(processor)])
            })
            .disposed(by: disposeBag)
        
        bind(viewModel.nameTextDriver, to: nameLabel.rx.text)
        bind(viewModel.userNameTextDriver, to: userNameLabel.rx.text)
    }
}
