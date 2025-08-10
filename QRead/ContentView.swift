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
                            .stroke(viewModel.detectedQRCode != nil ? .green : .clear, lineWidth: 4)
                    )

                if !historyManager.history.isEmpty {
                    HistoryView()
                        .frame(maxWidth: 400)
                }
            } else {
                Text("Camera access is required. Please enable it in System Settings.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear(perform: viewModel.requestCameraAccess)
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

#Preview(traits: .sizeThatFitsLayout) {
    ContentView()
        .frame(minHeight: 400)
}
