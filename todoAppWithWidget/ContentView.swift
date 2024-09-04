//
//  ContentView.swift
//  todoAppWithWidget
//
//  Created by Ramandeep Singh on 02/09/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            Home()
                .navigationTitle("Todo's")
        }
    }
}

#Preview {
    ContentView()
}
