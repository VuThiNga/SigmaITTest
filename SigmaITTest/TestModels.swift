//
//  TestModels.swift
//  SigmaITTest
//
//  Created by Ngavt on 3/30/21.
//

import Foundation
import ObjectMapper

final class TestBO: Mappable {
    var name: Int?
    var id: Int?
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
    init?(map: Map) {}
}
