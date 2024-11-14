import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("ARlogo") // Zorg ervoor dat 'ARlogo' in je assets staat
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.top, 50) // Bovenaan de pagina voor een goed uitgelijnd logo
            
            Spacer() // Ruimte boven de knoppen
            
            // Welkomstbericht
            Text("Welkom in de BRKYAR App!")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // Navigatieknop naar CameraView met schaduweffect en icoon
            NavigationLink(destination: CameraView()) {
                HStack {
                    Image(systemName: "camera.fill") // Camera icoon
                    Text("Open Camera")
                        .font(.headline)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 10) // Schaduw voor diepte
                .padding(.horizontal)
            }
            
            // Navigatieknop naar toekomstige pagina met iconen en animatie
            NavigationLink(destination: ImageView()) {
                HStack {
                    Image(systemName: "photo.fill") // Foto icoon
                    Text("Ga naar objectdetectie")
                        .font(.headline)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 10) // Schaduw voor diepte
                .padding(.horizontal)
                .scaleEffect(1.1) // Knop iets groter bij hover
                .animation(.easeInOut(duration: 0.2), value: 1.1) // Animatie voor de knop
            }
            
            Spacer() // Ruimte onder de knoppen
        }
        .padding()
        .background(Color(.systemBackground)) // Achtergrondkleur
        .edgesIgnoringSafeArea(.all) // Om de gehele ruimte in gebruik te nemen
    }
}

#Preview {
    HomeView()
}
