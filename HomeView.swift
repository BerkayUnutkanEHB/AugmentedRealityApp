import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            // App logo of titel
            Text("App Logo")
                .font(.largeTitle)
                .padding()
            
            Spacer() // Ruimte boven de knoppen
            
            // Navigatieknop naar CameraView
            NavigationLink(destination: CameraView()) {
                Text("Open Camera")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            // Navigatieknop naar toekomstige pagina
            NavigationLink(destination: ImageView()) {
                Text("Ga naar toekomstige pagina")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            Spacer() // Ruimte onder de knoppen
        }
        .padding()
        .navigationTitle("Home")
        .background(Color(.systemBackground)) // Achtergrondkleur
    }
}

#Preview {
    HomeView()
}
