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
    let modelName: String = Names.ToDoData
    
    //MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getToDoListFromCoreData() -> [ToDoData] {
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
    
    // MARK: - 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteToDo(data: ToDoData, completion: @escaping () -> Void) {
        // 날짜 옵션 바인딩
        guard let data = data.date else {
            completion()
            return
        }
        
        // 임시저장소 있는지 확인
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 단서 / 찾기 위한 조건 설정
            /*
             predicate(술어: 주어를 설명하는 부분) 인스턴스는 NSFetchRequest 인스턴스가 가져올 객체의 선택을 제한합니다.
             술어가 비어 있는 경우(예: 요소 배열에 술어가 없는 AND 술어인 경우) 요청의 술어는 nil로 설정됩니다.
             
             "%@" 형식지정자는 문자열 포매팅에서 문자열 포맷지정자로 사용된다.(문자열 값이 더 큰 문자열에 삽입되어야 하는 위치를 지정하는데 사용됨다.)
             let today = "2023-05-14"
             let message = String(format: "오늘의 날짜는 %@입니다.", today)
             print(message)
             */
            request.predicate = NSPredicate(format: "date = %@", data as CVarArg)
            
            do {
                // 요청서를 통해서 데이터를 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fatchedToDoList = try context.fetch(request) as? [ToDoData] {
                    
                    // 임시 저장소에서 (요청서를 통해) 데이터 삭제하기 (delete메서드)
                    if let targetToDo = fatchedToDoList.first {
                        context.delete(targetToDo)
                        
                        appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                        // hasChanges: 컨텍스트에 커밋되지 않은 변경 사항이 있는지 여부를 나타내는 부울 값입니다.
//                        if context.hasChanges {
//                            do {
//                                try context.save()
//                                completion()
//                            } catch {
//                                print(error)
//                                completion()
//                            }
//                        }
                    }
                    
                }
            } catch {
                print("지우기 실패")
                completion()
            }
        }
    }
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateToDo(newToDoData: ToDoData, completion: @escaping () -> Void) {
        
        guard let date = newToDoData.date else {
            completion()
            return
        }
        
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // predicate(단서 / 찾기 위한 조건 설정) = NSPredicate <-- 단서를 찾기위한 조건을 설정하는 클레스
            // 즉, NSPredicate(format: "date = %@", date as CVarArg) 이런 조건의 인스턴스 생성
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                // 요청서를 통해서. 데이터 가져오기
                if let fetchedToDoList = try context.fetch(request) as? [ToDoData] {
                    // 배열의 첫번째
                    if var targetToDo = fetchedToDoList.first {
                        
                        //MARK: - ToDoData에 실제 데이터 재할당(바꾸기)⭐️
                        targetToDo = newToDoData
                        
                        // appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도된다.
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
                completion()
            } catch {
                print("지우기 실패")
                completion()
            }
        }
        
    }
}
