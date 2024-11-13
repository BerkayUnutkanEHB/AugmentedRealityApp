import SwiftUI
import UIKit
import Combine
import AVFoundation
import Vision

//ViewModel class to hold the data for detected object

class CameraViewModel : ObservableObject {
    @Published var detectedObject : String = "" //name detected object
    @Published var confidence: Float = 0.0 //The confidence score of the detection
    @Published var boundingBox: CGRect = .zero //The bounding box around the detected object
    
}

//Main view of the application
struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel() //create an instance of ViewModel
    var body: some View {
        ZStack{
            //Load the camera view
            CameraView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text(viewModel.detectedObject) //detected objects name
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.7)) //bg
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                
                Text("Confidence: % \(String(format: "%.2f", viewModel.confidence))")
                    .padding()
                    .background(Color.black.opacity(0.7)) //bg
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                }
            
            Rectangle()
                .stroke(Color.red, lineWidth: 3)
                .frame(width: viewModel.boundingBox.width, height: viewModel.boundingBox.height)//size rectangle
                .position(x: viewModel.boundingBox.midX, y:viewModel.boundingBox.midY)
        }
    }
}

#Preview {
    ContentView()
}


