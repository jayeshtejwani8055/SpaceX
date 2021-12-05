//
//  LaunchesListViewModel.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 04/12/21.
//

import Foundation

final class SpaceXViewModel {
    
    private let webService: WebServiceProtocol
    
    init(webService: WebServiceProtocol = WebService()) {
        self.webService = webService
    }
    
    func fetchSuccessLaunches(for year: LaunchYear) -> Observable<[LaunchViewModel]> {
        webService.fetchUpcomingLaunches().map {$0.filter { $0.launchToShow(for: year) }.map {
            LaunchViewModel(launches: $0)
        }}
    }
    
    func getRocketDetail(with id: String) -> Observable<RocketViewModel> {
        webService.getRocketInfo(id: id).map {RocketViewModel(rocket: $0)}
    }
}
