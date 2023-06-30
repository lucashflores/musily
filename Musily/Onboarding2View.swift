//
//  Onboarding2View.swift
//  Musily
//
//  Created by Isabela Bastos Jastrombek on 29/06/23.
//

import SwiftUI

struct Onboarding2View: View {
    @State var zoomPhoto = false
    @Binding var showOnboarding: Bool
    var body: some View {
        ZStack {
            Image("ob2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .scaleEffect(zoomPhoto ? 1.25 : 1.0)
                .animation(.easeIn(duration:  10))
                .onAppear {
                    self.zoomPhoto.toggle()
                }
            
            VStack {
                HStack {
                    Text("Discover new")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    Spacer()
                }
                HStack {
                    Text("songs everyday")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                Spacer()
                
                VStack(spacing: 32) {
                    Text("""
    Once per day DISC will recommend a song from an amazing artist, giving to you a chance to known more talents, songs and genres for you to broaden your horizons about music.
    """)
                    .foregroundColor(.white)
                    .font(.body)
                    
                    Button {
                        showOnboarding.toggle()
                        
                    } label: {
                        HStack (spacing: 10) {
                            
                            //TEXTO DO BOTAO
                            Text("Let's start")
                                .font(Font.system(size: 18, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 32)
                        .background(Color("purple").opacity(0.7))
                        .cornerRadius(32)
                }
                      
                    
                }
                
                
            }
            .padding(.horizontal, 32)
            .padding(.top, 140)
            .padding(.bottom, 88)
        }
        
    }
}

struct Onboarding2View_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding2View(showOnboarding: .constant(true))
    }
}
