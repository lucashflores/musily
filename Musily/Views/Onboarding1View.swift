import SwiftUI

struct Onboarding1View: View {
    @State var zoomPhoto = false
    var body: some View {
        ZStack {
            
            Image("ob1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .scaleEffect(zoomPhoto ? 1.25 : 1.0)
                .animation(.easeIn(duration:  10))
                .onAppear {
                    self.zoomPhoto.toggle()
                }
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(Color(uiColor: .clear))
                .overlay {
                    LinearGradient(
                        colors: [.black, .black .opacity(0.5), Color(uiColor: .clear), Color(uiColor: .clear)], startPoint: .bottom, endPoint: .top) .ignoresSafeArea()
                }
            
            
            VStack {
                Spacer()
                
                Text("DISC helps you make the journey of discovering new music and genres even more interesting.")
                    .foregroundColor(.white)
                    .font(.system(size: 19))
                    .padding(.bottom, 64)
                
                
            }
            .padding(.top, 120)
            .padding(.bottom, 64)
            .padding(.horizontal, 32)
        }
    }
}

struct Onboarding1View_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding1View()
    }
}
