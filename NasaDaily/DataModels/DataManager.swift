//
//  DataManager.swift
//  NasaDaily
//
//  Created by Sanjeev on 27/02/22.
//

import CoreData

typealias PersistenceContainer = DataManager

class DataManager: ObservableObject {
    
    static let shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.containerName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error: \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                debugPrint("Data Saved")
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension DataManager {
    @nonobjc class func fetchRequest<Entity: NSManagedObject>() -> NSFetchRequest<Entity> {
        let name = "\(Entity.self)"
        debugPrint("Running fetch request \(name)")
        let request = NSFetchRequest<Entity>(entityName: name)
        request.sortDescriptors = []
        return request
    }
    
    func deleteItem(_ date: String) {
        let fetchRequest: NSFetchRequest<FavoritePics> = FavoritePics.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)
        
        if let objects = try? context.fetch(fetchRequest) {
            for obj in objects {
                context.delete(obj)
            }
        }

        do {
            try context.save()
        } catch {
            // Do something... fatalerror
        }
    }
    
    func checkIfItemExist(_ date: String) -> Bool {
        let request: NSFetchRequest<FavoritePics> = FavoritePics.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "date == %@", date)

        do {
            let count = try context.count(for: request)
            return count > 0
        }catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            return false
        }
    }
    
    func savePicModel(_ model: DailyPicModel?) {
        guard let item = model else { return }
        
        let local = FavoritePics(context: context)
        local.date = item.date
        local.copyright = item.copyright ?? ""
        local.hdurl = item.hdurl
        local.explanation = item.explanation
        local.mediaType = item.mediaType
        local.serviceVersion = item.serviceVersion
        local.title = item.title
        local.url = item.url
        
        saveContext()
    }
}
