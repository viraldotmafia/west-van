//
//  SplashView.swift
//  WestVPN
//
//  Created by Is'hoq Abduvoxidov on 09/09/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            HomeView() // navigate to HomeView after delay
        } else {
            VStack {
                Image(systemName: "lock.shield.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                Text("WestVPN")
                    .font(.largeTitle)
                    .bold()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

