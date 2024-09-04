//
//  todoList.swift
//  todoList
//
//  Created by Ramandeep Singh on 03/09/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: .now)
        entries.append(entry)
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct todoListEntryView : View {
    var entry: Provider.Entry
    @Query(todoDescriptor, animation: .snappy) private var activeList: [Todo] = []
    var body: some View {
        VStack (alignment: .leading){
            ForEach(activeList, id: \.taskID) {todo in
                HStack(spacing: 10){
                    Button(intent: ToogleButton(id: todo.taskID)){
                        Image(systemName: "circle")
                            .font(.callout)
                            .tint(todo.priority.color.gradient)
                            .buttonBorderShape(.circle)
                        
                    }
                    Text(todo.task)
                        .font(.callout)
                        .lineLimit(1)
                    
                    
                    Spacer(minLength: 0)
                }
                .transition(.push(from: .bottom))
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .overlay{
            if activeList.isEmpty{
                Text("No Tasks")
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
        
    }
    static var todoDescriptor : FetchDescriptor<Todo>{
        let predicate = #Predicate<Todo> { !$0.isCompleted }
        let sort = [SortDescriptor(\Todo.lastUpdated, order: .reverse)]
        var descriptor = FetchDescriptor(predicate: predicate, sortBy:  sort)
        descriptor.fetchLimit = 3
        
        return descriptor
    }
}

struct todoList: Widget {
    let kind: String = "todoList"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            todoListEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: Todo.self)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Tasks")
        .description("This is a todo list")
    }
}


#Preview(as: .systemSmall) {
    todoList()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}


struct ToogleButton: AppIntent{
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggle's Todo State"
    )
    
    @Parameter(title: "Todo ID")
    var id: String
    
    init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        let context = try ModelContext(.init(for: Todo.self))
        let descriptor = FetchDescriptor(predicate: #Predicate<Todo> {$0.taskID == id})
        if let todo = try context.fetch(descriptor).first{
            todo.isCompleted = true
            todo.lastUpdated = .now
            
            try context.save()
        }
        return .result()
    }
}
