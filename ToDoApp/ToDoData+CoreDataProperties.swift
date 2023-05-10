//
//  ToDoData+CoreDataProperties.swift
//  ToDoApp
//
//  Created by 노민우 on 2023/05/11.
//
//

import Foundation
import CoreData


extension ToDoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoData> {
        return NSFetchRequest<ToDoData>(entityName: "ToDoData")
    }
    // extension 에서는 저장속성을 선언할 수 없음. 그러므로 이건 저장속성이아님[내부적으로 뭔가가있음 구지 알 필요는 없다.]
    @NSManaged public var memoText: String?
    @NSManaged public var date: Date?
    @NSManaged public var color: Int64

}

extension ToDoData : Identifiable {

}
