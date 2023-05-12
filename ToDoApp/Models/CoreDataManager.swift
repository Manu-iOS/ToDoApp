//
//  CoreDataManager.swift
//  ToDoApp
//
//  Created by 노민우 on 2023/05/11.
//

import UIKit
import CoreData

//MARK: - ToDo 관리하는 매니져 (코어데이터 관리)
final class CoreDataManager {
    
    // 싱글톤으로 만들기
    static let shared = CoreDataManager()
    private init() {}
    
    // 앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // 임시 저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    // 엔터티 이름 (코어데이터에 저장된 객체)
    let modelName: String = Names.CellName
    
    //MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getTodoListFromCoreData() -> [ToDoData] {
        var toDoList: [ToDoData] = []
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.modelName)
            // 정렬순서를 정해서 요청서에 넘겨주기
            let dateOrder = NSSortDescriptor(key: toDoListFromCoreData.dateOrderKey, ascending: false)
            request.sortDescriptors = [dateOrder]
           
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fach 메서드)
                if let fetchedToDoList = try context.fetch(request) as? [ToDoData] {
                    toDoList = fetchedToDoList
                }
            } catch {
                print(toDoListFromCoreData.falseRequest)
            }
        }
        return toDoList
    }
    
    // MARK: - [Create] 코어데이터 생성하기
    func saveToDoData(toDoText: String?, colorInt: Int64, completion: @escaping () -> Void) {
        // 임시조정소 있는지 확인
        if let context = context {
            // 임시 저장소에 있는 데이터를 그려줄 형태 파악하기
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                if let toDoData = NSManagedObject(entity: entity, insertInto: context) as? ToDoData {
                    
                    // MARK: - ToDoData에 실제 데이터 할당 ⭐️
                    toDoData.memoText = toDoText
                    toDoData.date = Date() // 날짜는 저장하는 순간의 날까로 생성
                    toDoData.color = colorInt
                    
                    // appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                    // context.hasChanges => 컨텍스트에 커밋되지 않은 변경 사항이 있는지 여부를 나타내는 부울 값.
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }
}
