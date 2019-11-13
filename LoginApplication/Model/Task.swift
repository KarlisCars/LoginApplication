//
//  Task.swift
//  LoginApplication
//
//  Created by Karlis Cars on 12/11/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import Foundation
import Firebase

class Tasks {
    let title: String
    let userId: String
    let ref: DatabaseReference?
    var completed: Bool = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        
        ref = snapshot.ref
    }
    func convertToDict() -> Any{
        return ["title": title, "userId": userId, "completed": completed]
    }
    
}
