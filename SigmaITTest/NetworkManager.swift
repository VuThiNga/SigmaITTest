//
//  NetworkManager.swift
//  SigmaITTest
//
//  Created by Ngavt on 3/30/21.
//

import Foundation
import Moya
import ObjectMapper

struct NetworkManager {
    
    static let provider = MoyaProvider<MultiTarget>()
    
    
    static func request<T: Mappable>(class: T.Type,
                                      target: MultiTarget,
                                      isCancel: Bool = false,
                                      success successCallback: @escaping ([T]) -> Void = {_ in },
                                      error errorCallback: @escaping  (_ description: String) -> Void = {_ in },
                                      failure failureCallback: @escaping (MoyaError) -> Void = {_ in }
    ) {
        let request = provider.request(target) { result in
            var msg = ""

            switch result {
            case let .success(response):
                do {
                    var lstResult = [T]()
                    if let array = try JSONSerialization.jsonObject(with: response.data, options: []) as? [[String:Any]] {
                        for index in 0..<array.count {
                            if let object = T(JSON: array[index]) {
                                lstResult.append(object)
                            }
                        }
                        successCallback(lstResult)
                    }else if let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any], let object = T(JSON: json) {
                        lstResult.append(object)
                        successCallback(lstResult)
                    }else {
                        msg = "Lỗi không chuyển đổi được kiểu dữ liệu"
                        errorCallback(msg)
                    }
                    
                } catch let error {
                    msg = error.localizedDescription
                    errorCallback(msg)
                }
            case let .failure(error):
                failureCallback(error)
            }
        }
        if isCancel {
            Operator.shared.requests.append(request)
        }
    }
}
