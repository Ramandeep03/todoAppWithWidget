//
//  CompletedTodoList.swift
//  todoAppWithWidget
//
//  Created by Ramandeep Singh on 02/09/24.
//

import SwiftUI
import SwiftData

struct CompletedTodoList: View {
    @Query private var completedList: [Todo]
    @Binding  var showAll: Bool
    
    init(showAll: Binding<Bool>){
        let predicate = #Predicate<Todo> { $0.isCompleted }
        
        let sort = [SortDescriptor(\Todo.lastUpdated,order: .reverse)]
        
        var disciptor = FetchDescriptor(predicate: predicate, sortBy: sort )
        if !showAll.wrappedValue {
            disciptor.fetchLimit = 15
        }
        _completedList = Query(disciptor,animation: .snappy)
        _showAll = showAll
    }
    

    
    var body: some View {
        if !completedList.isEmpty {
            Section{
                ForEach(completedList, id: \.self.taskID){ todo in
                    TodoRowView(todo: todo)
                        .listRowSeparator(.hidden)
                }
            }
            header : {
                HStack {
                    Text("Completed")
                    Spacer(minLength: 0)
                    if showAll{
                        Button("Show Recents"){
                            showAll = false
                        }
                    }
                }
                .font(.caption)
                
            } footer: {
                if completedList.count == 15 && !showAll{
                    HStack{
                        Text("Showing Recent 15 Tasks")
                            .foregroundStyle(.gray)
                        Spacer(minLength: 0)
                        Button("Show All"){
                            showAll = true
                        }
                    }
                    .font(.caption)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
