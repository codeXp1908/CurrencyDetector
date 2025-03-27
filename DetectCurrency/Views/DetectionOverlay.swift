import SwiftUI

struct DetectionOverlay: View {
    @ObservedObject var detector: CurrencyDetector
    
    private func denominationColor(_ currency: String) -> Color {
        switch currency {
        case "₹10": return .blue
        case "₹20": return .green
        case "₹50": return .purple
        case "₹100": return .orange
        case "₹200": return .yellow
        case "₹500": return .pink
        default: return .gray
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            if detector.isHighConfidenceDetection {
                HighConfidenceView(currency: detector.detectedCurrency,
                                confidence: detector.confidence)
                    .transition(.scale.combined(with: .opacity))
            } else if !detector.detectedCurrency.isEmpty {
                DetectionResultView(currency: detector.detectedCurrency,
                                  confidence: detector.confidence)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.bottom, 50)
        .animation(.spring(), value: detector.detectedCurrency)
    }
}

struct HighConfidenceView: View {
    let currency: String
    let confidence: Double
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.green)
            
            Text("Detected!")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(currency)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Confidence: \(String(format: "%.1f%%", confidence))")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.green, lineWidth: 3)
        )
        .padding(.horizontal, 40)
        .shadow(color: .green.opacity(0.4), radius: 20)
    }
}

struct DetectionResultView: View {
    let currency: String
    let confidence: Double
    
    var body: some View {
        VStack(spacing: 12) {
            Text(currency)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 5, x: 0, y: 2)
            
            ConfidenceMeter(confidence: confidence)
            
            Text(String(format: "%.1f%%", confidence))
                .font(.system(size: 20, weight: .medium, design: .monospaced))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 3, x: 0, y: 1)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing),
                    lineWidth: 2)
        )
        .padding(.horizontal, 40)
            )
    }
}

struct ConfidenceMeter: View {
    let confidence: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: geometry.size.width, height: 10)
                    .foregroundColor(Color.white.opacity(0.2))
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: min(CGFloat(confidence/100) * geometry.size.width, geometry.size.width),
                           height: 10)
                    .foregroundColor(confidenceColor)
            }
        }
        .frame(height: 10)
    }
    
    private var confidenceColor: Color {
        switch confidence {
        case 0..<50: return .red
        case 50..<75: return .yellow
        case 75...100: return .green
        default: return .blue
        }
    }
}
