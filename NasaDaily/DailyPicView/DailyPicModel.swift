//
//  DailyPicModel.swift
//  NasaDaily
//
//  Created by Sanjeev on 26/02/22.
//

import Foundation

struct DailyPicModel: Codable {
    let copyright,hdurl: String?
    let date, explanation: String
    let mediaType, serviceVersion, title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}

extension DailyPicModel {
    init(_ local: FavoritePics) {
        self.copyright = local.copyright ?? ""
        self.hdurl = local.hdurl ?? ""
        self.date = local.date ?? ""
        self.explanation = local.explanation ?? ""
        self.mediaType = local.mediaType ?? ""
        self.serviceVersion = local.serviceVersion ?? ""
        self.title = local.title ?? ""
        self.url = local.url ?? ""
    }
}

extension DailyPicModel {
    
    var imageUrl: URL? {
        if let imgUrl = URL(string: url) {
            return imgUrl
        }
        return nil
    }
    
    var hdImageUrl: URL? {
        if let hdImage = hdurl,
            let imgUrl = URL(string: hdImage) {
            return imgUrl
        }
        return nil
    }
}
