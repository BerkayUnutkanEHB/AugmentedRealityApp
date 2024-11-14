import SwiftUI
import UIKit
import Combine
import AVFoundation
import Vision

// ViewModel class to hold the data for detected object
class CameraViewModel: ObservableObject {
    @Published var detectedObject: String = "" // Name of detected object
    @Published var confidence: Float = 0.0 // Confidence score
    @Published var boundingBox: CGRect = .zero // Bounding box around detected object
    @Published var isObjectTapped: Bool = false // Track if the object is tapped
}

// Main view of the application
struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel() // ViewModel instance

    var body: some View {
        ZStack {
            // Load the camera view
            CameraRepresentableView(viewModel: viewModel) // Update this to the new name
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(viewModel.detectedObject) // Detected object name
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                
                Text("Confidence: % \(String(format: "%.2f", viewModel.confidence))")
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
            }
            
            // Bounding box with tap gesture
            Rectangle()
                .stroke(Color.red, lineWidth: 3)
                .frame(width: viewModel.boundingBox.width, height: viewModel.boundingBox.height)
                .position(x: viewModel.boundingBox.midX, y: viewModel.boundingBox.midY)
                .onTapGesture {
                    viewModel.isObjectTapped.toggle() // Toggle tap state
                    handleObjectTap()
                }
        }
        .alert(isPresented: $viewModel.isObjectTapped) {
            Alert(title: Text("Object Tapped"), message: Text("You tapped on \(viewModel.detectedObject)"), dismissButton: .default(Text("OK")))
        }
    }
    
    // Handle tap interaction
    private func handleObjectTap() {
        print("Object tapped: \(viewModel.detectedObject)")
    }
}

// Rename UIViewControllerRepresentable struct
struct CameraRepresentableView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIViewController(context: Context) -> UIViewController {
        let cameraViewController = CameraViewController(viewModel: viewModel)
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

// Camera handling with AVCapture and Vision object detection
class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var viewModel: CameraViewModel

    init(viewModel: CameraViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set up camera when view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup camera session
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        
        // Configure back camera
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            return
        }
        
        captureSession.addInput(videoInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        captureSession.addOutput(videoOutput)
        
        // Setup preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    // Detect objects
    func detectObject(sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Load the CoreML model
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else { return }
        
        // Create request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            if let firstResult = results.first, firstResult.confidence > 0.3 {
                DispatchQueue.main.async {
                    self.viewModel.detectedObject = firstResult.identifier
                    self.viewModel.confidence = firstResult.confidence
                    print("Detected object: \(firstResult.identifier) with confidence: \(firstResult.confidence)")
                    // Example bounding box
                    self.viewModel.boundingBox = CGRect(x: 120, y: 100, width: 200, height: 200)
                }
            } else {
                DispatchQueue.main.async {
                    self.viewModel.detectedObject = "No object detected with sufficient confidence"
                    self.viewModel.confidence = 0.0
                    self.viewModel.boundingBox = .zero
                }
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        detectObject(sampleBuffer: sampleBuffer)
    }
}
