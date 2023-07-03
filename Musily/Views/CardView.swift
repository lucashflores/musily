import SwiftUI

struct SheetView: View {
        @Environment(\.dismiss) var dismiss
        var cardInfo: MediaInformationCard

    var body: some View {
        VStack (alignment: .leading){
            Text (cardInfo.title)
                .foregroundColor(.white)
                .font(.title2)
                .bold()
                .padding(.bottom, 16)
            Text(cardInfo.content)
                .foregroundColor(.white)
                .font(.caption)
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .edgesIgnoringSafeArea(.all)
        .cornerRadius(16)
    }
}

struct CardView: View {
    var cardInfo: MediaInformationCard
    @State private var showingSheet = false
    
    var body: some View {
        Button {
            showingSheet.toggle()
        } label: {
            VStack (alignment: .leading){
                Text(cardInfo.content)
                    .foregroundColor(.white)
                    .font(.caption)
                Spacer()
                Text (cardInfo.title)
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                    
                }
                .padding()
                .frame(width: 240, height: 240, alignment: .leading)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.white.opacity(0.5), .white.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(16)
        }
        .sheet(isPresented: $showingSheet) {
            SheetView(cardInfo: cardInfo)
                .presentationDetents([.medium, .large])
                .padding(32)
                .cornerRadius(16)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.7), .purple.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
        }
        
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardInfo: MediaInformationCard(title: "The Genre", content: "O gênero de música Pop é caracterizado por suas melodias cativantes, letras simplistas e estruturas musicais acessíveis. Originado na década de 1950, o Pop se tornou um dos gêneros mais populares do mundo, abrangendo uma ampla variedade de estilos musicais e influências. Suas canções geralmente enfatizam temas universais como amor, felicidade e juventude, visando um apelo comercial massivo."))
    }
}
