//
//  Constants.swift
//  SigmaITTest
//
//  Created by Ngavt on 3/30/21.
//

import Foundation
import Moya

struct URLs {
    static let baseUrl = "http://sigma-solutions.eu"
}

class Operator {
    static let shared = Operator()
    var requests: [Cancellable] = []
}
