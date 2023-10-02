//
//  SplashScreen.swift
//  CineFlix
//
//  Created by Macbook on 28.08.2023.
//

import SwiftUI
import Lottie

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            IntroModuleView()
        } else {
            ZStack {
                DynamicBackgroundView()
                VStack {
                    Image("logoCine")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 40)
                        .clipped()
                    LottieSplashScreenView(name: "LaunchAnimation")
                        .frame(width: 400, height: 400, alignment: .center)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.isActive = true
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}
