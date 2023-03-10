//
//  CoreDataManager.swift
//  ValifyDemo
//
//  Created by Mina Atef on 13/10/2022.
//  Copyright © 2022 Valify. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataManager {
    static var persistentContainer: NSPersistentContainer = {
        let modelURL = Bundle.main.url(forResource: "WeatherData", withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
        let container = NSPersistentContainer(name: "WeatherData", managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (_, error) in
            
            if let err = error {
                fatalError("❌ Loading of store failed:\(err)")
            }
        }
        return container
    }()
}
