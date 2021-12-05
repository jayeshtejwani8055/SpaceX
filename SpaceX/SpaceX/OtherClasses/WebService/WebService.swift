//
//  WebService.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 04/12/21.
//

import Foundation

enum RequestError: Error {
    case unknownError
    case connectionError
    case invalidRequest
    case authorizationError
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
}

protocol WebServiceProtocol {
    
    func fetchUpcomingLaunches()    -> Observable<[Launches]>
    func getRocketInfo(id: String)  -> Observable<Rocket>
}

class WebService: WebServiceProtocol {
    
    private let baseUrl = "https://api.spacexdata.com/v4/"
    
    func getRocketInfo(id: String) -> Observable<Rocket> {
        return Observable.create { observer -> Disposable in
            let urlStr = self.baseUrl+rockets+"/\(id)"
            let urlRequest = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print(error)
                    observer.onError(RequestError.connectionError)
                    return
                }
                guard let rocketData = data, let responseCode = response as? HTTPURLResponse else {
                    observer.onError(RequestError.invalidRequest)
                    return
                }
                do {
                    switch responseCode.statusCode {
                    case 200:
                        if let jsonDict = try JSONSerialization.jsonObject(with: rocketData, options: []) as? NSDictionary {
                            observer.onNext(Rocket(dict: jsonDict))
                        }
                    case 400...499:
                        observer.onError(RequestError.authorizationError)
                    case 500...599:
                        observer.onError(RequestError.serverError)
                    default:
                        observer.onError(RequestError.unknownError)
                        break
                    }
                } catch let err {
                    observer.onError(err)
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func fetchUpcomingLaunches() -> Observable<[Launches]> {
        return Observable.create { observer -> Disposable in
            let urlRequest = URLRequest(url: URL(string: self.baseUrl+launches)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print(error)
                    observer.onError(RequestError.connectionError)
                    return
                }
                guard let launchData = data, let responseCode = response as? HTTPURLResponse else {
                    observer.onError(RequestError.invalidRequest)
                    return
                }
                do {
                    switch responseCode.statusCode {
                    case 200:
                        var arrayLaunches: [Launches] = []
                        if let jsonData = try JSONSerialization.jsonObject(with: launchData, options: []) as? [NSDictionary] {
                            jsonData.forEach { dict in
                                let objLaunch = Launches(dict: dict)
                                arrayLaunches.append(objLaunch)
                            }
                            observer.onNext(arrayLaunches)
                        }
                    case 400...499:
                        observer.onError(RequestError.authorizationError)
                    case 500...599:
                        observer.onError(RequestError.serverError)
                    default:
                        observer.onError(RequestError.unknownError)
                        break
                    }
                } catch let err {
                    observer.onError(err)
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
