//
//  ContentView.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var historyManager: QRCodeHistoryManager
    @StateObject private var viewModel: CameraViewModel
    
    init() {
        let sharedHistoryManager = QRCodeHistoryManager()
        _historyManager = StateObject(wrappedValue: sharedHistoryManager)
        _viewModel = StateObject(wrappedValue: CameraViewModel(historyManager: sharedHistoryManager))
   }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if viewModel.hasCameraAccess {
                CameraPreviewView(session: viewModel.captureSession)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        Rectangle()
                            .stroke((viewModel.detectedQRCode != nil) ? Color.green : Color.clear, lineWidth: 4)
                    )
                
                // History Section
                if (!historyManager.history.isEmpty) {
                    VStack(alignment: .leading) {
                        Text("QR Code History")
                            .font(.headline)
                            .padding(.horizontal)
                            .shadow(
                                color: Color(NSColor.windowBackgroundColor).opacity(0.3), radius: 3, x: 0, y: 2
                            )
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(historyManager.history, id: \.id) { anyHistoryItem in
                                    HistoryItemView(item: anyHistoryItem.base)
                                }
                            }
                        }
                    }
                    .padding(.top)
                    .frame(maxWidth: 400)
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
        .environmentObject(historyManager)
    }
}

extension ContentView {
    var qrCodeDetected: Bool {
        viewModel.detectedQRCode != nil
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ContentView()
        .frame(minHeight: 400)
        .environmentObject(QRCodeHistoryManager())
}
