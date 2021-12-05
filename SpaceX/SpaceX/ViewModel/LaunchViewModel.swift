//
//  LaunchViewModel.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 04/12/21.
//

import Foundation

struct LaunchViewModel {
    
    let launches: Launches
    
    init(launches: Launches) {
        self.launches = launches
    }
}

struct RocketViewModel {
    
    let rocket: Rocket
    
    init(rocket: Rocket) {
        self.rocket = rocket
    }
}
