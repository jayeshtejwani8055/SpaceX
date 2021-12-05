//
//  ScrollView.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 05/12/21.
//

import UIKit

extension UIScrollView {
    
    var currentPage: Int {
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)
    }
}
