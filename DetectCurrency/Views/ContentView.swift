//
//  ContentView.swift
//  DetectCurrency
//
//  Created by Prakhar Saxena on 26/03/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var detector = CurrencyDetector()
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            CameraView(detector: detector)
                .ignoresSafeArea()
            
            DetectionOverlay(detector: detector)
            
            VStack {
                HStack {
                    Spacer()
                    SettingsButton(action: { showSettings.toggle() })
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct SettingsButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "gearshape.fill")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .clipShape(Circle())
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
