//
//  ContentView.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel(historyManager: QRCodeHistoryManager())
    @StateObject private var historyManager = QRCodeHistoryManager()
    
    var body: some View {
        VStack {
            if viewModel.hasCameraAccess {
                CameraPreviewView(session: viewModel.captureSession)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        Rectangle()
                            .stroke((viewModel.detectedQRCode != nil) ? Color.green : Color.clear, lineWidth: 4)
                    )
                
                if let qrCode = viewModel.detectedQRCode {
                    Text("Detected QR Code: \(qrCode)")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                } else {
                    Text("No QR Code Detected")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
                
                // History Section
                VStack(alignment: .leading) {
                    Text("QR Code History")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(historyManager.history, id: \.id) { historyItem in
                                HistoryItemView(item: historyItem)
                            }
                        }
                    }
                    .frame(maxHeight: 150)
                    .padding(.horizontal)
                }
            } else {
                Text("Camera access is required. Please enable it in System Settings.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            viewModel.requestCameraAccess()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

extension ContentView {
    var qrCodeDetected: Bool {
        viewModel.detectedQRCode != nil
    }
}
