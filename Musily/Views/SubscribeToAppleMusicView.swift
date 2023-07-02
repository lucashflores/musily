import SwiftUI

struct SubscribeToAppleMusicView: View {
    @Binding var isPresented : Bool
    var body: some View {
        VStack{
            Text ("You need Apple Music to have access to this function")
        }
        .musicSubscriptionOffer(isPresented: $isPresented)
    }
}

struct SubscribeToAppleMusicView_Previews: PreviewProvider {
    static var previews: some View {
        SubscribeToAppleMusicView(isPresented: .constant(true))
    }
}
