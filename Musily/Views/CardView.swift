import SwiftUI

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    var cardInfo: MediaInformationCard
    var color1 : String
    var color2 : String
    var icon : String
    
    var body: some View {
        VStack (alignment: .leading){
            HStack{
                Text (cardInfo.title)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color(color1))
                    .background(.white)
                    .cornerRadius(16)
                Spacer()
                Image(systemName: icon)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(.bottom)
            Text(cardInfo.content)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .font(.footnote)
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
    var color1 : String
    var color2 : String
    var icon : String
    
    var body: some View {
        Button {
            showingSheet.toggle()
        } label: {
            VStack (alignment: .leading){
                Text(cardInfo.content)
                    .foregroundColor(.white)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .font(.footnote)
                HStack{
                    Text (cardInfo.title)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color(color2))
                        .background(.white)
                        .cornerRadius(16)
                    Spacer()
                    Image(systemName: icon)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                }
                .padding()
                .frame(width: 240, height: 240, alignment: .leading)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(color1), Color(color2)]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(16)
        }
        .sheet(isPresented: $showingSheet) {
            SheetView(cardInfo: cardInfo, color1: color1, color2: color2, icon: icon)
                .presentationDetents([.medium, .large])
                .padding(32)
                .presentationCornerRadius(32)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(color1), Color(color2)]), startPoint: .top, endPoint: .bottom))
        }
        
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardInfo: MediaInformationCard(title: "The Genre", content: "O gênero de música Pop é caracterizado por suas melodias cativantes, letras simplistas e estruturas musicais acessíveis. Originado na década de 1950, o Pop se tornou um dos gêneros mais populares do mundo, abrangendo uma ampla variedade de estilos musicais e influências. Suas canções geralmente enfatizam temas universais como amor, felicidade e juventude, visando um apelo comercial massivo."), color1: "green", color2: "purple", icon: "music.mic.circle.fill")
    }
}
