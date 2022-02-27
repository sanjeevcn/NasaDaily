//
//  FavoritePics.swift
//  NasaDaily
//
//  Created by Sanjeev on 27/02/22.
//

import Foundation
import CoreData


@objc(FavoritePics)
public class FavoritePics: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritePics> {
        return NSFetchRequest<FavoritePics>(entityName: "FavoritePics")
    }

    @NSManaged public var date: String?
    @NSManaged public var copyright: String?
    @NSManaged public var hdurl: String?
    @NSManaged public var explanation: String?
    @NSManaged public var mediaType: String?
    @NSManaged public var serviceVersion: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}

extension FavoritePics {
    static func fetchAll() -> NSFetchRequest<FavoritePics> {
        let request: NSFetchRequest<FavoritePics> = FavoritePics.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return request
    }
}

extension FavoritePics {
    var imageUrl: URL? {
        if let urlString = url,
            let imgUrl = URL(string: urlString) {
            return imgUrl
        }
        return nil
    }
}
