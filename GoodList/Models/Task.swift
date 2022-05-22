//
//  Task.swift
//  GoodList
//
//  Created by 山本響 on 2022/05/22.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
    
}

struct Task {
    let title: String
    let priority: Priority
}
