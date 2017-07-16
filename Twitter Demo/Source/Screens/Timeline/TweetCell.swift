//
//  TweetCell.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Kingfisher

final class TweetCell: UITableViewCell, Binder {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    var viewModel: TweetCellViewModel! {
        didSet {
            disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else {
                return
            }
            
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
            
            bind(viewModel.userNameTextDriver, to: userLabel.rx.text)
            bind(viewModel.dateTextDriver, to: dateLabel.rx.text)
            bind(viewModel.tweetTextDriver, to: bodyLabel.rx.text)
            bind(viewModel.isFavouriteDriver, to: favouriteButton.rx.isSelected)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    @IBAction private func toggleFavourite(_ sender: Any) {
        viewModel.toggleFavourite()
    }
}
