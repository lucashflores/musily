//
//  OnboardingTabView.swift
//  Musily
//
//  Created by Lucas Flores on 30/06/23.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    var body: some View {
        TabView {
            IntroView()
            Onboarding1View()
            Onboarding2View(showOnboarding: $showOnboarding)
        }
        .tabViewStyle(PageTabViewStyle())
        .ignoresSafeArea()
    }
}
