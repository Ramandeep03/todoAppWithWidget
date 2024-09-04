//
//  todoListLiveActivity.swift
//  todoList
//
//  Created by Ramandeep Singh on 03/09/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct todoListAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct todoListLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: todoListAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension todoListAttributes {
    fileprivate static var preview: todoListAttributes {
        todoListAttributes(name: "World")
    }
}

extension todoListAttributes.ContentState {
    fileprivate static var smiley: todoListAttributes.ContentState {
        todoListAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: todoListAttributes.ContentState {
         todoListAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: todoListAttributes.preview) {
   todoListLiveActivity()
} contentStates: {
    todoListAttributes.ContentState.smiley
    todoListAttributes.ContentState.starEyes
}
