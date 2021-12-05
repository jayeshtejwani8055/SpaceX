//
//  RocketTableCell.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 04/12/21.
//

import UIKit

class RocketTableCell: UITableViewCell {

    @IBOutlet weak var lblLaunchNo: UILabel!
    @IBOutlet weak var lblLaunchDate: UILabel!
    @IBOutlet weak var lblLaunchDesc: UILabel!
    @IBOutlet weak var imgLaunchView: UIImageView!
    @IBOutlet weak var imgConst: NSLayoutConstraint!
    
    var imageLoader = ImageLoader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepareLaunchData(launch: Launches) {
        lblLaunchNo.text = launch.launchNo
        lblLaunchDate.text = launch.launchDate
        lblLaunchDesc.text = launch.details
        if let iconPath = launch.iconPath, !iconPath.isEmpty {
            imgConst.constant = 60.0
            imageLoader.obtainImageWithPath(imagePath: iconPath) { image in
                self.imgLaunchView.image = image
            }
        } else {
            imgConst.constant = 0
        }
        layoutIfNeeded()
    }
}
