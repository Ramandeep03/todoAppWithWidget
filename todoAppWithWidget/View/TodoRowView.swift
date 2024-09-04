//
//  TodoRowView.swift
//  todoAppWithWidget
//
//  Created by Ramandeep Singh on 02/09/24.
//

import SwiftUI
import WidgetKit

struct TodoRowView: View {
    
    @Bindable var todo : Todo
    
    @FocusState private var isActive : Bool
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scene
    
    var body: some View {
        HStack(spacing: 8){
            if !isActive && !todo.task.isEmpty {
                Button {
                    todo.isCompleted.toggle()
                    todo.lastUpdated = .now
                    WidgetCenter.shared.reloadAllTimelines()
                }label:{
                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundColor(todo.isCompleted ?  .gray : .primary )
                        .contentTransition(.symbolEffect(.replace))
                }
            }
            
            TextField("Enter task", text: $todo.task)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray : .primary)
                .focused($isActive)
            if !isActive && !todo.task.isEmpty {
                
                Menu {
                    ForEach(Priority.allCases, id: \.rawValue){ priority in
                        Button {
                            todo.priority = priority
                            todo.lastUpdated = .now
                            WidgetCenter.shared.reloadAllTimelines()
                        } label:{
                            HStack {
                                Text(priority.rawValue)
                                
                                if todo.priority == priority {Image(systemName: "checkmark")}
                            }
                        }
                        
                    }
                } label:{
                    Image(systemName: "circle.fill")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.priority.color.gradient)
                }
            }
        }
        
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .animation(.snappy, value: isActive)
        .onAppear{
            isActive = todo.task.isEmpty
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false){
            Button("",systemImage: "trash"){
                context.delete(todo)
                WidgetCenter.shared.reloadAllTimelines()
            }
            .tint(.red)
        }
        .onSubmit {
            if todo.task.isEmpty{
                context.delete(todo)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .onChange(of: scene){ oldValue, newValue in
            if newValue != .active && todo.task.isEmpty {
                context.delete(todo)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .task {
            todo.isCompleted = todo.isCompleted
        }
    }
}

#Preview {
    ContentView()
}
