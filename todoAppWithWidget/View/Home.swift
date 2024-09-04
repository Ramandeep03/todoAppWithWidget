//
//  Home.swift
//  todoAppWithWidget
//
//  Created by Ramandeep Singh on 02/09/24.
//

import SwiftUI
import SwiftData


struct Home: View {
    @Query(filter: #Predicate<Todo>{ !$0.isCompleted }, sort: [SortDescriptor(\Todo.lastUpdated, order: .reverse)], animation: .snappy)
    var activeList : [Todo]
    
    @Environment(\.modelContext) private var context
    @State private var showAll : Bool = false
    var body: some View {
        List{
            if activeList.isEmpty {
                Text("No Active Todo's")
                    .listRowSeparator(.hidden)
                    
            }else {
                Section("Active (\(activeList.count))"){
                    ForEach(activeList, id: \.self.taskID){
                        TodoRowView(todo: $0)
                    }
                }
            }
            CompletedTodoList(showAll: $showAll)
        }
        .listStyle(.plain)
        
        .toolbar{
            ToolbarItem(placement:.bottomBar){
                Button{
                    let todo = Todo(task: "", priority: .normal)
                    context.insert(todo)
                }label:{
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 42))
                        .fontWeight(.light)
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
}
