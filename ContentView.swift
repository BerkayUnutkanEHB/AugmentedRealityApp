//test commit als het werkt
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
                    .background(Color.black.opacity(0.7)) //background
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

struct CameraView: UIViewControllerRepresentable{
    @ObservedObject var viewModel : CameraViewModel
    
    func makeUIViewController(context: Context) -> UIViewController{
        let cameraViewController = CameraViewController(viewModel: viewModel)
        return cameraViewController
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class CameraViewController : UIViewController {
    var captureSession : AVCaptureSession!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var viewModel : CameraViewModel
    
    init(viewModel: CameraViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    //Set up camera when view is loaded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup camera session
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        //configure back camera
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else{
            return
        }
        
        captureSession.addInput(videoInput)
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        captureSession.addOutput(videoOutput)
        //setup
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    //detect objects
    func detectObject(sampleBuffer : CMSampleBuffer){
        //get image
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        //load the coreml model
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else { return }
        //create request
        let request = VNCoreMLRequest(model: model) { (request,error) in
            //process
            guard let results = request.results as? [VNClassificationObservation] else { return }
            //
            if let firstResult = results.first, firstResult.confidence > 0.3{
                DispatchQueue.main.async {
                    self.viewModel.detectedObject = firstResult.identifier //update name
                    self.viewModel.confidence = firstResult.confidence //update score
                    print("Detected object: \(firstResult.identifier) with confidence: \(firstResult.confidence)")
                    //example box
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
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [ : ])
        try? handler.perform([request])
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        detectObject(sampleBuffer: sampleBuffer)
    }
}
