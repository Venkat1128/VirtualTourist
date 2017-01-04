//
//  CoreDataStack.swift
//  VirtualTourist
//
//  Created by Venkat Kurapati on 04/01/2017.
//  Copyright © 2017 Kurapati. All rights reserved.
//

import Foundation
import CoreData
class CoreDataStack{
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VirtualTourist")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    func autoSave(delayInSeconds : Int)
    {
        if delayInSeconds > 0
        {
            saveContext()
            let when = DispatchTime.now() + .seconds(delayInSeconds)
            DispatchQueue.main.asyncAfter(deadline: when)
            {
                self.autoSave(delayInSeconds: delayInSeconds)
            }
        }
    }
    // MARK: Shared Instance
    
    class func sharedInstance() -> CoreDataStack {
        struct Singleton {
            static var sharedInstance = CoreDataStack()
        }
        return Singleton.sharedInstance
    }
}
