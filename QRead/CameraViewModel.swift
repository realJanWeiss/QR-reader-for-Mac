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
    @Published var isCameraRunning = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let historyManager: QRCodeHistoryManager
    
    init(historyManager: QRCodeHistoryManager) {
        self.historyManager = historyManager
        super.init()
        setupCaptureSession()
    }
    
    func requestCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            hasCameraAccess = true
            startCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.hasCameraAccess = granted
                    if granted {
                        self?.startCamera()
                    }
                }
            }
        case .denied, .restricted:
            hasCameraAccess = false
            showError(message: "Camera access denied. Please enable it in System Settings.")
        @unknown default:
            hasCameraAccess = false
            showError(message: "Unknown camera access status.")
        }
    }
    
    private func setupCaptureSession() {
        captureSession.beginConfiguration()
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoInput) else {
            showError(message: "Unable to initialize camera.")
            return
        }
        
        captureSession.addInput(videoInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            showError(message: "Unable to configure video output.")
            return
        }
        
        captureSession.commitConfiguration()
    }
    
    func startCamera() {
        guard hasCameraAccess else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
            DispatchQueue.main.async {
                self?.isCameraRunning = true
            }
        }
    }
    
    func stopCamera() {
        captureSession.stopRunning()
        isCameraRunning = false
        detectedQRCode = nil
    }
    
    func toggleCamera() {
        isCameraRunning ? stopCamera() : startCamera()
    }
    
    private func showError(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = message
            self?.showError = true
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
                self?.detectedQRCode = payload
                self?.historyManager.addHistoryItem(QRCodeUtils.historyItemFromQRCode(payload))
            }
        }
        
        request.symbologies = [.qr]
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
}
