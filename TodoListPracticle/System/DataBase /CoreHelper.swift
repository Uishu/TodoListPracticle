//
//  CoreHelper.swift
//  Period Tracker
//
//  Created by Jaydeep Makwana on 28/10/23.
//

import Foundation
import CoreData
import UIKit
import Toaster

class CoreHelper {
    
    static let Shared = CoreHelper()
    
    // for get database in your app.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoListPracticle")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: - Get All List Query
    func GetAllData() -> [TaskData] {
        let context = persistentContainer.viewContext
        var request = [TaskData]()
        do {
            request = try context.fetch(TaskData.fetchRequest())
        } catch {
            Toast(text: "Not Getting Any Tasks From Device").show()
        }
        return request
    }
    
    //MARK: - Get Uncompleted List Query
    func GetAllUnCompletedList() -> [TaskData] {
        let context = persistentContainer.viewContext
        var request = [TaskData]()
        do {
            request = try context.fetch(TaskData.fetchRequest())
            request = request.filter({$0.isCompleted == false})
        } catch {
            Toast(text: "Not Getting Any Tasks From Device").show()
        }
        return request
    }
    
    //MARK: - Get Completed List Query
    func GetAllCompletedList() -> [TaskData] {
        let context = persistentContainer.viewContext
        var request = [TaskData]()
        do {
            request = try context.fetch(TaskData.fetchRequest())
            request = request.filter({$0.isCompleted == true})
        } catch {
            Toast(text: "Not Getting Any Tasks From Device").show()
        }
        return request
    }
    
    // MARK: - Set List Query
    func SetDataQuery(id:Int,taskName:String?,taskDiscription:String?,iscompleted: Bool) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "TaskData", into: context) as! TaskData
        entity.id = Int16(id)
        entity.taskName = taskName
        entity.taskDiscription = taskDiscription
        entity.isCompleted = iscompleted
        do {
            try context.save()
        } catch {
            Toast(text: "Tasks is not set").show()
        }
    }
    
    // MARK: - Edit List Query
    func EditQuery(iscompleted:Bool,id:Int) {
        let context = persistentContainer.viewContext
        do {
            let data = try context.fetch(TaskData.fetchRequest()) as? [TaskData]
            for i in data ?? [] {
                if i.id == Int16(id) {
                    i.isCompleted = iscompleted
                }
            }
            try context.save()
        } catch {}
    }
    
    //MARK: - Delete List Query
    func DeleteQuery(id:Int) {
        let context = persistentContainer.viewContext
        do {
            let data = try context.fetch(TaskData.fetchRequest()) as? [TaskData]
            for i in data ?? [] {
                if i.id == Int16(id) {
                    context.delete(i)
                    print("🗑️ Task Deleted 🗑️")
                }
            }
            try context.save()
        } catch {
            Toast(text: "Task is not Deleted").show()
        }
    }
}
