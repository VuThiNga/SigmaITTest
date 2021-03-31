//
//  TestModels.swift
//  SigmaITTest
//
//  Created by Ngavt on 3/30/21.
//

import Foundation
import ObjectMapper

final class TestBO: Mappable {
    var albumId: Int?
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
    
    func mapping(map: Map) {
        id <- map["id"]
        albumId <- map["albumId"]
        title <- map["title"]
        url <- map["url"]
        thumbnailUrl <- map["thumbnailUrl"]
    }
    
    init?(map: Map) {}
}
