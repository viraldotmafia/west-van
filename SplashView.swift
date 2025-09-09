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
        ZStack {
            DSColor.background.ignoresSafeArea()
            if isActive {
                HomeView()
            } else {
                VStack(spacing: DSSpacing.sm) {
                    ZStack {
                        Circle()
                            .fill(DSColor.surface)
                            .frame(width: 120, height: 120)
                            .overlay(
                                Circle().stroke(DSColor.border, lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 10)
                        Image(systemName: "lock.shield.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .foregroundColor(DSColor.textPrimary)
                    }
                    Text("WestVPN")
                        .font(DSTypography.title)
                        .foregroundColor(DSColor.textPrimary)
                }
                .padding(DSSpacing.lg)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                        withAnimation(.easeInOut) {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

