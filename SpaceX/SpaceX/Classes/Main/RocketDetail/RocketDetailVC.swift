//
//  RocketDetailVC.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 05/12/21.
//

import UIKit

class RocketDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var viewModel: RocketViewModel?
    var tableCell: [EnumRocketDetailView] = [.imageCell, .wikiCell, .descCell]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDetailUI()
    }
}

extension RocketDetailVC {
    
    func prepareDetailUI() {
        tableView.tableFooterView = UIView()
        guard let viewModel = viewModel else {return}
        Observable.just(tableCell)
        .bind(to: tableView.rx.items) { tableView, index, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellId) as! RocketDetailCell
            cell.prepareRocketDetailUI(for: index, rocket: viewModel.rocket)
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe { indexPath in
            if indexPath.element?.row == 1 {
                UIApplication.shared.open(URL(string: viewModel.rocket.wiki)!, options: [:], completionHandler: nil)
            }
        }.disposed(by: disposeBag)

        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension RocketDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
}
