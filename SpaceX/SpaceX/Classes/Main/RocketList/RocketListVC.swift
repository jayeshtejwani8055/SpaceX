//
//  RocketListVC.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 02/12/21.
//

import UIKit

class RocketListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    private var viewModel = SpaceXViewModel()
    
    var launchYear = BehaviorRelay<LaunchYear>(value: .currentYear)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        getLaunches()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let destVC = segue.destination as! RocketDetailVC
            if let rocketDetailViewModel = sender as? RocketViewModel {
                destVC.viewModel = rocketDetailViewModel
            }
        }
    }
}

extension RocketListVC {
    
    private func prepareUI() {
        tableView.tableFooterView = UIView()
    }
    
    private func getLaunches() {
        launchYear.asObservable().subscribe { yearToSwitch in
            self.fetchUpcomingLaunches(year: yearToSwitch)
        }.disposed(by: disposeBag)
    }
    
    private func fetchUpcomingLaunches(year: LaunchYear) {
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        self.viewModel.fetchSuccessLaunches(for: year).bind(to: self.tableView.rx.items(cellIdentifier: "rocketCell", cellType: RocketTableCell.self)) { index, viewModel, cell in
            cell.prepareLaunchData(launch: viewModel.launches)
        }.disposed(by: self.disposeBag)
        
        tableView.rx.modelSelected(LaunchViewModel.self).subscribe { model in
          self.getRocketInfo(id: model.launches.rocket)
        }.disposed(by: disposeBag)
    }
    
    private func getRocketInfo(id: String) {
        viewModel.getRocketDetail(with: id).subscribe { viewModel in
            self.navigateToDetail(rocketViewModel: viewModel)
        }.disposed(by: disposeBag)
    }
    
    fileprivate func navigateToDetail(rocketViewModel: RocketViewModel) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "detailSegue", sender: rocketViewModel)
        }
    }
}

extension RocketListVC {
    
    @IBAction func btnFilter(_ sender: UIBarButtonItem) {
        let actions: [UIAlertController.AlertAction] = [
            .action(title: "Year 2020"),
            .action(title: "Year 2021")
        ]
        UIAlertController
            .present(in: self, title: "Select Year", message: nil, style: .actionSheet, actions: actions)
            .subscribe(onNext: { buttonIndex in
                self.launchYear.accept(LaunchYear(rawValue: buttonIndex)!)
            }).disposed(by: disposeBag)
    }
}
