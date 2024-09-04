//
//  todoAppWithWidgetApp.swift
//  todoAppWithWidget
//
//  Created by Ramandeep Singh on 02/09/24.
//

import SwiftUI

@main
struct todoAppWithWidgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Todo.self)
    }
}
