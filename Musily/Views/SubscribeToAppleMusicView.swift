import SwiftUI

struct SubscribeToAppleMusicView: View {
    @Binding var isPresented : Bool
    var body: some View {
        Text("Subscribe to Apple Music.")
 musicSubscriptionOffer(isPresented: $isPresented)
    }
}

struct SubscribeToAppleMusicView_Previews: PreviewProvider {
    static var previews: some View {
        SubscribeToAppleMusicView(isPresented: .constant(true))
    }
}
