//
//  LottieSplashScreenView.swift
//  CineFlix
//
//  Created by Macbook on 09.09.2023.
//

import SwiftUI
import Lottie

struct LottieSplashScreenView: UIViewRepresentable {
    let name: String
    var loopMode: LottieLoopMode = .loop
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        let viewAnimation = LottieAnimationView(name: name)
        
        animationView.animation = viewAnimation.animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
