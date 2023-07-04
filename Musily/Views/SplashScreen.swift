import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Image("loading")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Rectangle()
                .ignoresSafeArea()
                .opacity(0.35)
            
            Text("We are arranging the Disc for you.")
                .font(.system(size: 20))
                .foregroundColor(.white)
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
