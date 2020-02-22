//
//  DataManager.swift
//  MyMemo
//
//  Created by 박성영 on 12/02/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation
import CoreData
import UIKit.UIImage

class DataManager {
    
    static let shared = DataManager()
    private init(){
        
    }
    
    var mainContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //메모를 읽어옴
    var memoList = [MyMemo]()
    
    func fetchMemo(){
        let request : NSFetchRequest<MyMemo> = MyMemo.fetchRequest()
        //정렬 규칙 만들어 줄것
        let sortMemo = NSSortDescriptor(key: "createDate", ascending: false)
        request.sortDescriptors = [sortMemo]
        do {
            memoList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    //새로운 메모 저장
    func saveNewMemo (_ title : String? , _ mainText : String? , _ addImage : [UIImage]) {
        let newMemo = MyMemo(context: mainContext)
        
        newMemo.title = title
        newMemo.mainText = mainText
        newMemo.createDate = Date()
       
        if addImage.count != 0 {
        newMemo.myImage = convertImageToData(addImage)
        }
        
        memoList.insert(newMemo, at: 0)
        saveContext()
        
    }
    
    func convertImageToData( _ image : [UIImage]) -> [Data]{
        var memoImage = [Data]()
        for i in image{
           // let imageData =  i.pngData()
            let imageData = i.jpegData(compressionQuality: 0.8)
            memoImage.append(imageData!)
        }
        return memoImage
    }
    
    func removeMemo( _ MyMemo : MyMemo? ) {
        if let MyMemo = MyMemo {
            mainContext.delete(MyMemo)
            saveContext()
        }
    }
    
    // MARK: - Core Data stack

      lazy var persistentContainer: NSPersistentContainer = {
      
          let container = NSPersistentContainer(name: "MyMemo")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
              if let error = error as NSError? {
                
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
      }()

      // MARK: - Core Data Saving support

      func saveContext () {
          let context = persistentContainer.viewContext
          if context.hasChanges {
              do {
                  try context.save()
              } catch {
                  let nserror = error as NSError
                  fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
              }
          }
      }
    
}
