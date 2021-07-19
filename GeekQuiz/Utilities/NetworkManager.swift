//
//  NetworkManager.swift
//  GeekQuiz
//
//  Created by Egor on 11.07.2021.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
    func makeRequest(url: String, params: Parameters = [:]) -> Observable<Data> {
        
        return Observable.create { observer -> Disposable in
            
            AF.request(url, parameters: params).response { response in
                
                if let error = response.error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                
                guard let data = response.data else { return }
                                
                observer.onNext(data)
            }
            
            return Disposables.create()
        }
    }
}
