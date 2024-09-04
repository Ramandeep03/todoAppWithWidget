//
//  Todo.swift
//  todoAppWithWidget
//
//  Created by Ramandeep Singh on 02/09/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Todo{
    private(set) var taskID: String = UUID().uuidString
    var task : String
    var isCompleted: Bool = false
    var priority: Priority
    var lastUpdated: Date = Date.now
    
    init(task: String, priority: Priority) {
        self.task = task
        self.priority = priority
    }
}


enum Priority: String, Codable, CaseIterable{
    case normal = "Normal"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .normal:
            return .green
        case .medium :
            return .yellow
        case .high:
            return .red
        }
    }
}
