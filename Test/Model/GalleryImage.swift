//
//  GalleryImage.swift
//  Test
//
//  Created by Sophia Tang on 2022/5/11.
//

import Foundation
struct GalleryImage: Decodable {
    
    var id: String
    var title: String?
    var width: Double
    var height: Double
    var type: String
    var link: String
}

extension GalleryImage: Hashable {
    static func == (lhs: GalleryImage, rhs: GalleryImage) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
