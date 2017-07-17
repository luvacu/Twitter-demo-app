//
//  TimelineViewController.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class TimelineViewController: UITableViewController, Binder {
    
    let disposeBag = DisposeBag()
    
    var viewModel: TimelineViewModel! {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            viewModel.windowTitleDriver
                .drive(onNext: { [unowned self] title in
                    self.title = title
                })
                .disposed(by: disposeBag)
            
            viewModel.windowIconDriver
                .drive(onNext: { [unowned self] imageResource in
                    self.tabBarItem.image = UIImage(resource: imageResource)
                })
                .disposed(by: disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        addBinds(to: viewModel)
    }
    
    private func addBinds(to viewModel: TimelineViewModel) {
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        viewModel.tweetsDriver
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: R.reuseIdentifier.tweetCell.identifier, cellType: TweetCell.self)) { (row, viewModel, cell) in
                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(TweetCellViewModel.self)
            .subscribe(onNext: { cellViewModel in
                viewModel.didSelectCellViewModel(cellViewModel)
            })
            .disposed(by: disposeBag)
    }
}
