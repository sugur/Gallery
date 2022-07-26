//
//  GallerySearchResult.swift
//  Test
//
//  Created by Sophia Tang on 2022/5/11.
//

import Foundation
// https://api.imgur.com/models/basic
struct GallerySearchResult {
        
    var galleries: [Gallery]
    var success: Bool
    var status: Int
}

extension GallerySearchResult: Decodable {

    enum CodingKeys: String, CodingKey {
        case galleries = "data"
        case success
        case status
    }
}
