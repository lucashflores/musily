import SwiftUI

struct CardView: View {
    var cardInfo: MediaInformationCard

    
    var body: some View {
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
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardInfo: MediaInformationCard(title: "The Genre", content: "O gênero de música Pop é caracterizado por suas melodias cativantes, letras simplistas e estruturas musicais acessíveis. Originado na década de 1950, o Pop se tornou um dos gêneros mais populares do mundo, abrangendo uma ampla variedade de estilos musicais e influências. Suas canções geralmente enfatizam temas universais como amor, felicidade e juventude, visando um apelo comercial massivo."))
    }
}
