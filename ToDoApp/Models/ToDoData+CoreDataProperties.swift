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
    
    // 오늘 날짜를 위해서 날짜 계산프로퍼티 생성
    var dateString: String? {
        let myFormatter = DateFormatter() // 데이터 포멧 객체 생성
        myFormatter.dateFormat = MyFormatter.dateForm
        guard let date = self.date else { return "" }
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
    }

}

extension ToDoData : Identifiable {

}
