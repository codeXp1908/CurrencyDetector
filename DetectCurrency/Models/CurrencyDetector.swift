import CoreML
import SwiftUI
import Vision
import UIKit

class CurrencyDetector: ObservableObject {
    @Published var detectedCurrency: String = ""
    @Published var confidence: Double = 0.0
    @Published var isHighConfidenceDetection: Bool = false
    @Published var shouldPauseDetection: Bool = false
    
    private var model: VNCoreMLModel?
    private let speechSynthesizer = SpeechSynthesizer()
    private var lastSpokenCurrency: String = ""
    @AppStorage("speechEnabled") var speechEnabled = true
    @AppStorage("detectionThreshold") var detectionThreshold = 90.0 // Default to 90% for high confidence
    
    init() {
        setupModel()
    }
    
    private func setupModel() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let modelURL = Bundle.main.url(forResource: "IndianCurrencyClassifier", withExtension: "mlmodelc") else {
                fatalError("Failed to locate model file.")
            }
            
            do {
                let configuration = MLModelConfiguration()
                configuration.computeUnits = .all
                let mlModel = try MLModel(contentsOf: modelURL, configuration: configuration)
                self.model = try VNCoreMLModel(for: mlModel)
            } catch {
                fatalError("Failed to load Core ML model: \(error)")
            }
        }
    }
    
    func detect(image: UIImage) {
        guard !shouldPauseDetection, let model = model, let ciImage = CIImage(image: image) else { return }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            self?.processDetectionResults(for: request, error: error)
        }
        
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Detection error: \(error.localizedDescription)")
            }
        }
    }
    
    private func processDetectionResults(for request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation],
              let topResult = results.first else {
            return
        }
        
        let currency = formatCurrencyName(topResult.identifier)
        let confidence = Double(topResult.confidence) * 100
        
        DispatchQueue.main.async {
            self.detectedCurrency = currency
            self.confidence = confidence
            
            // Check for high confidence detection
            if confidence >= self.detectionThreshold {
                self.isHighConfidenceDetection = true
                self.shouldPauseDetection = true
                
                if self.speechEnabled && self.lastSpokenCurrency != currency {
                    self.speechSynthesizer.speak("Detected \(currency) rupee with \(Int(confidence)) percent confidence")
                    self.lastSpokenCurrency = currency
                }
                
                // Resume detection after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.shouldPauseDetection = false
                    self.isHighConfidenceDetection = false
                }
            }
        }
    }
    
    func resumeDetection() {
        shouldPauseDetection = false
        isHighConfidenceDetection = false
    }
    
    private func formatCurrencyName(_ identifier: String) -> String {
        return identifier
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "rupee", with: "₹")
            .capitalized
    }
}
