//
//  TestService.swift
//  SigmaITTest
//
//  Created by Ngavt on 3/30/21.
//

import Foundation
import Moya

enum TestService {
    case test(params: [String: Any])
}

extension TestService: TargetType {
    var baseURL: URL {
        return URL(string: URLs.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .test:
            return "/test"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .test:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .test(params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let header = ["Content-type": "application/json"]
        return header
    }
    
    
}
