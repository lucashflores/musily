import SwiftUI

struct IntroView: View {
    @State var zoomPhoto = false
    var body: some View {
        ZStack {

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

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
