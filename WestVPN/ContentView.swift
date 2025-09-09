//
//  ContentView.swift
//  WestVPN
//
//  Created by Is'hoq Abduvoxidov on 09/09/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
       
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack {
                
                Image("WestVPN 1.0")
                    .resizable()
                    .cornerRadius(12)
                    .aspectRatio(contentMode:.fill)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                Text("WestVPN 1.0")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
            
            }
            
            
        }
        
       
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
