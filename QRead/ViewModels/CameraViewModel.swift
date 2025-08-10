//
//  CameraViewModel.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import AVFoundation
import Vision
import Combine

class CameraViewModel: NSObject, ObservableObject {
    @Published var captureSession = AVCaptureSession()
    @Published var detectedQRCode: String?
    @Published var hasCameraAccess = false
    @Published var showError = false
    @Published var errorMessage = ""

    private let historyManager: QRCodeHistoryManager

    init(historyManager: QRCodeHistoryManager) {
        self.historyManager = historyManager
        super.init()
        setupCaptureSession()
    }

    func requestCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            updateCameraAccess(granted: true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                self?.updateCameraAccess(granted: granted)
            }
        case .denied, .restricted:
            updateCameraAccess(granted: false)
            showError(message: "Camera access denied. Please enable it in System Settings.")
        @unknown default:
            updateCameraAccess(granted: false)
            showError(message: "Unknown camera access status.")
        }
    }

    private func updateCameraAccess(granted: Bool) {
        DispatchQueue.main.async {
            self.hasCameraAccess = granted
            if granted { self.startCamera() }
        }
    }

    private func setupCaptureSession() {
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoInput) else {
            showError(message: "Unable to initialize camera.")
            return
        }
        captureSession.addInput(videoInput)

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        guard captureSession.canAddOutput(videoOutput) else {
            showError(message: "Unable to configure video output.")
            return
        }
        captureSession.addOutput(videoOutput)
    }

    func startCamera() {
        guard hasCameraAccess, !captureSession.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    func stopCamera() {
        captureSession.stopRunning()
        DispatchQueue.main.async {
            self.detectedQRCode = nil
        }
    }

    private func showError(message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.showError = true
        }
    }
}

extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectBarcodesRequest { [weak self] request, error in
            if let error = error {
                self?.showError(message: "QR Code detection failed: \(error.localizedDescription)")
                return
            }
            
            guard let results = request.results as? [VNBarcodeObservation],
                  let firstQR = results.first,
                  let payload = firstQR.payloadStringValue else {
                DispatchQueue.main.async { [weak self] in
                    self?.detectedQRCode = nil
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self, self.detectedQRCode != payload else { return }
                self.detectedQRCode = payload
                self.historyManager.addHistoryItem(payload)
            }
        }
        
        request.symbologies = [.qr]
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
}
