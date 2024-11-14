import SwiftUI
import CoreML
import Vision

struct ImageView: View {
    @State private var selectedImage: UIImage? = nil // De geselecteerde afbeelding
    @State private var detectedObject: String = "" // Het gedetecteerde object
    @State private var confidence: Float = 0.0 // De vertrouwensscore
    @State private var showingImagePicker: Bool = false // Of de ImagePicker zichtbaar is
    
    var body: some View {
        VStack {
            // Titel van de pagina
            Text("Kies een afbeelding")
                .font(.title)
                .padding(.top, 20)
            
            // Toon de geselecteerde afbeelding
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding()
            }
            
            // Toon het gedetecteerde object en de vertrouwensscore
            if !detectedObject.isEmpty {
                Text("Gedetecteerd Object: \(detectedObject)")
                    .font(.headline)
                    .padding()
                
                Text("Vertrouwen: \(String(format: "%.2f", confidence))")
                    .padding()
            }
            
            // Button om de image picker te tonen
            Button(action: {
                showingImagePicker = true
            }) {
                Text("Kies een afbeelding uit de galerij")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, onImageSelected: { image in
                // Voer objectdetectie uit wanneer de afbeelding is geselecteerd
                detectObject(in: image)
            })
        }
    }
    
    // Functie voor objectdetectie
    private func detectObject(in image: UIImage) {
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model),
              let ciImage = CIImage(image: image) else {
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation], let firstResult = results.first else {
                return
            }
            
            DispatchQueue.main.async {
                self.detectedObject = firstResult.identifier
                self.confidence = firstResult.confidence
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
