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
}
