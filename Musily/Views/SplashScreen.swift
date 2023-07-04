//
//  SplashScreen.swift
//  Musily
//
//  Created by Tiago Mendes Bottamedi on 04/07/23.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack{
            Image("DISC")
                .resizable()
                .frame(width: 200, height: 200)
            Text("Estamos buscando suas músicas, aguarde")
                .foregroundColor(.white)
        }
        .frame(width: 250, height: 250)
        .background(.black)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
