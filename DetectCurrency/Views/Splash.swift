import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var showButton = false
    @State private var navigateToNextScreen = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // App logo or icon with animation
                    Image(systemName: "waveform.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.blue)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.5), value: isAnimating)
                    
                    // App title with animation
                    Text("Detector App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5).delay(0.2), value: isAnimating)
                    
                    // App subtitle with animation
                    Text("Advanced detection technology")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5).delay(0.4), value: isAnimating)
                    
                    if showButton {
                        Button(action: {
                            // Action to navigate to next screen
                            navigateToNextScreen = true
                        }) {
                            Text("Start Detecting")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.horizontal, 40)
                                .shadow(radius: 5)
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .padding(.top, 50)
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $navigateToNextScreen) {
                ContentView() // Your next screen view
            }
            .onAppear {
                // Start animations when view appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAnimating = true
                    
                    // Show button after other animations complete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showButton = true
                        }
                    }
                }
            }
        }
    }
}

// Preview
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
