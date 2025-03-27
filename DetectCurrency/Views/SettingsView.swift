//
//  SettingsView.swift
//  DetectCurrency
//
//  Created by Prakhar Saxena on 26/03/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("speechEnabled") private var speechEnabled = true
    @AppStorage("detectionThreshold") private var detectionThreshold = 70.0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Audio Settings")) {
                    Toggle("Enable Voice Announcements", isOn: $speechEnabled)
                }
                
                Section(header: Text("Detection Sensitivity")) {
                    Slider(value: $detectionThreshold, in: 50...90, step: 5) {
                        Text("Confidence Threshold")
                    }
                    .accentColor(confidenceColor(for: detectionThreshold))
                    
                    HStack {
                        Text("Current threshold:")
                        Spacer()
                        Text("\(Int(detectionThreshold))%")
                            .foregroundColor(confidenceColor(for: detectionThreshold))
                            .fontWeight(.bold)
                    }
                    .font(.caption)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func confidenceColor(for value: Double) -> Color {
        switch value {
        case 0..<60: return .red
        case 60..<75: return .orange
        case 75...90: return .green
        default: return .blue
        }
    }
}
