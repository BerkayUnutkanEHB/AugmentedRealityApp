import SwiftUI
import SceneKit
import ARKit

struct ThreeDView: View {
    @State private var selectedModel: String? = nil
    
    var body: some View {
        VStack {
            Text("3D Model View")
                .font(.title)
                .padding()
            
            HStack {
                Button(action: {
                    selectedModel = "Bananas_for_scale_in_Augmented_Reality.scn"
                }) {
                    Text("Banaan")
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    selectedModel = "Peeled_mandarins.scn"
                }) {
                    Text("Mandarijn")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    selectedModel = "Apple_cake.scn"
                }) {
                    Text("Apple")
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
            }
            .padding()
            
            ARViewContainer(selectedModel: $selectedModel)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var selectedModel: String? // Gebonden variabele voor het geselecteerde model
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        arView.session.run(config)
        
        arView.delegate = context.coordinator
        
        // Laad het model direct bij het openen van de pagina
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Even wachten voordat model geladen wordt
            context.coordinator.addModelToScene(arView: arView, modelName: selectedModel)
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        if let modelName = selectedModel {
            context.coordinator.addModelToScene(arView: uiView, modelName: modelName)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        private var modelNode: SCNNode?
        
        func addModelToScene(arView: ARSCNView, modelName: String?) {
            // Verwijder eventueel bestaand model voordat een nieuw model wordt geladen
            modelNode?.removeFromParentNode()
            
            guard let modelName = modelName else { return }
            
            let position = SCNVector3(0, -0.2, -0.5) // Model wordt 20 cm onder de camera geplaatst en 50 cm voor de camera
            
            // Laad het geselecteerde model
            guard let scene = SCNScene(named: modelName) else {
                print("Kon het model \(modelName) niet laden.")
                return
            }
            
            if let node = scene.rootNode.childNodes.first {
                node.position = position
                
                // Pas schaal aan (kleiner maken)
                node.scale = SCNVector3(0.005, 0.005, 0.005) // Verkleinen model
                
                // Voeg het model toe aan de AR-scène
                arView.scene.rootNode.addChildNode(node)
                self.modelNode = node
            }
        }
    }
}
