//
//  RocketDetailCell.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 05/12/21.
//

import UIKit

enum EnumRocketDetailView {
    case imageCell
    case wikiCell
    case descCell
    
    var cellId: String {
        switch self {
        case .imageCell:
            return "imageCell"
        case .wikiCell:
            return "wikiCell"
        case .descCell:
            return "descCell"
        }
    }
}

class ImageCollCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
}

class RocketDetailCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblWikipedia: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageLoader = ImageLoader()
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func prepareRocketDetailUI(for index:Int, rocket: Rocket) {
        if index == 0 {
            if let attachments = rocket.attachment, !attachments.isEmpty {
                pageControl.numberOfPages = attachments.count
                rocket.getAttachments().bind(to:
                    self.collectionView.rx.items(cellIdentifier: "cell",
                                                cellType: ImageCollCell.self)) {index, model, cell in
                    self.imageLoader.obtainImageWithPath(imagePath: model.iconSmall!) { image in
                        cell.imgView.image = image
                    }
                }.disposed(by: self.disposeBag)
            }
            collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        } else if index == 1 {
            lblWikipedia.text = rocket.wiki
        } else {
            lblDescription.text = rocket.desc
        }
    }
    
    func collectionViewItems(source: Observable<[Attachments]>) -> Observable<[String]> {
        return source.map {$0.map {$0.iconSmall ?? ""}}
    }
}

extension RocketDetailCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return CGSize(width: screenSize.width, height: 200.0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = scrollView.currentPage
    }
}
