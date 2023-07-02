import SwiftUI
import MusicKit

struct SubscribeToAppleMusicView: View {
    @Binding var isPresented : Bool
    @State var options = MusicSubscriptionOffer.Options(
        messageIdentifier: .playMusic
    )
    var body: some View {
        VStack{
            Text ("You need Apple Music to have access to this function")
        }
        .musicSubscriptionOffer(isPresented: $isPresented, options: options)
    }
}

struct SubscribeToAppleMusicView_Previews: PreviewProvider {
    static var previews: some View {
        SubscribeToAppleMusicView(isPresented: .constant(true))
    }
}
