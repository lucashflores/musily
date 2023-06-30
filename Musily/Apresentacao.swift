//
//  Apresentacao.swift
//  Musily
//
//  Created by Julia on 29/06/23.
//

import SwiftUI

struct Apresentacao: View {
    @State var zoomPhoto = false
    var body: some View {
        ZStack {
// AQUI VAI O VÍDEO DE FUNDO, QUE FICA REPETINDO INFINITAMENTE.
            Image("1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .scaleEffect(zoomPhoto ? 1.25 : 1.0)
                .animation(.easeIn(duration:  10))
                .onAppear {
                    self.zoomPhoto.toggle()
                }

            VStack {
                Spacer()

// AQUI VAI O VIDEO DA ANIMACAO DO LOGO (enquanto isso fica essa imagem)
                Image("discover")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                    .padding(.bottom, 32)




            } .padding(.leading, 8)
                .padding(.trailing, 16)
                .padding(.bottom, 64)
        }
    }
}

struct Apresentacao_Previews: PreviewProvider {
    static var previews: some View {
        Apresentacao()
    }
}
