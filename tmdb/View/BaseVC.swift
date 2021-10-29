//
//  BaseVC.swift
//  tmdb
//
//  Created by Sunil Targe on 2021/9/25.
//

import UIKit

class BaseVC: UITableViewController {
    let pullToRefreshControl = UIRefreshControl()

    // view model instance
    lazy var viewModel: ViewModel = {
        return ViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    // initial UI
    func initView() {
        // setup refresh controller
        pullToRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(pullToRefreshControl)
        pullToRefreshControl.beginRefreshing()
        
        // navigation bar style
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    // Naive binding
    func initViewModel() {
        // closure for network check, empty data and server side error
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        // closure to manage loading status
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    UIView.animate(withDuration: 0.3, animations: {
                        self?.view.alpha = 0.9
                    })
                }else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self?.view.alpha = 1.0
                    })
                    self?.pullToRefreshControl.endRefreshing()
                }
            }
        }
    }
    
    // pull to refresh
    @objc func refresh(_ sender: AnyObject) {}
}
