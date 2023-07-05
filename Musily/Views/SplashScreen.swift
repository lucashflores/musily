//
//  File.swift
//  Musily
//
//  Created by Gabriela Nunes on 02/07/23.
//

import SwiftUI
import Lottie

struct SplashScreen: UIViewRepresentable {
    
        let name: String
        let loopMode: LottieLoopMode
        
        func makeUIView(context: Context) -> Lottie.LottieAnimationView {
            let animationView = LottieAnimationView (name: name)
            animationView.loopMode = loopMode
            animationView.play ()
            
            return animationView
        }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {
    
    }
    
}
