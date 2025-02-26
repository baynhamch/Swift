import AVFoundation
import Vision
import SwiftUI

/// ViewModel that handles hand tracking and updates UI elements accordingly.
class HandTrackingViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Properties
    
    /// Manages the device's camera session.
    public var captureSession = AVCaptureSession()
    
    /// Vision request for detecting hand poses.
    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    
    /// Indicates the swipe direction (left or right).
    @Published var scrollDirection: String? // "left" or "right"
    
    /// Tracks whether a hand is currently detected.
    @Published var handDetected: Bool = false
    
    /// Controls the color of the hand icon based on gesture type.
    @Published var handIconColor: Color = .gray // Default color (no hand detected)
    
    /// Stores the X position of the detected hand for UI tracking.
    @Published var handPositionX: CGFloat = 201.0 // Default centered position
    
    /// Stores the last detected X position of the hand (used for movement detection).
    private var lastHandX: CGFloat?
    
    /// Prevents multiple rapid swipe detections by enforcing a cooldown.
    private var canDetectSwipe = true

    // MARK: - Initialization
    
    override init() {
        super.init()
        setupCamera()
    }

    // MARK: - Camera Setup

    /// Initializes the camera session and sets up video capture.
    private func setupCamera() {
        // Attempt to get the front camera
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("No front camera found")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            print("Error accessing camera: \(error)")
            return
        }

        // Set up video output and assign delegate
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(output)

        // Start the camera session
        captureSession.startRunning()
    }

    // MARK: - Video Frame Processing
    
    /// Processes each captured frame and extracts hand pose data.
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Convert the video frame into a pixel buffer
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])

        do {
            // Perform the Vision hand pose detection request
            try requestHandler.perform([handPoseRequest])
            
            if let results = handPoseRequest.results?.first {
                let fingerPoints = try getFingerPoints(results)

                DispatchQueue.main.async {
                    self.handDetected = !fingerPoints.isEmpty // Update if hand is detected
                    self.updateHandState(fingerPoints) // Determine if hand is open or closed
                }
            } else {
                DispatchQueue.main.async {
                    self.handDetected = false // No hand detected
                    self.handIconColor = .gray // Reset hand icon to default color
                }
            }
        } catch {
            print("Hand tracking error: \(error)")
        }
    }

    // MARK: - Hand Gesture Processing

    /// Extracts finger tip positions from the hand pose observation.
    private func getFingerPoints(_ results: VNHumanHandPoseObservation) throws -> [VNRecognizedPoint] {
        var fingerPoints: [VNRecognizedPoint] = []

        // Attempt to recognize each fingertip and add it to the list
        if let thumbTip = try? results.recognizedPoint(.thumbTip) {
            fingerPoints.append(thumbTip)
        }
        if let indexTip = try? results.recognizedPoint(.indexTip) {
            fingerPoints.append(indexTip)
        }
        if let middleTip = try? results.recognizedPoint(.middleTip) {
            fingerPoints.append(middleTip)
        }
        if let ringTip = try? results.recognizedPoint(.ringTip) {
            fingerPoints.append(ringTip)
        }
        if let littleTip = try? results.recognizedPoint(.littleTip) {
            fingerPoints.append(littleTip)
        }

        return fingerPoints
    }

    /// Determines whether the detected hand is open (palm) or closed (fist) and updates UI color.
    private func updateHandState(_ fingerPoints: [VNRecognizedPoint]) {
        let fingerCount = fingerPoints.count

        if fingerCount == 0 || fingerCount == 1 {
            // 🟡 Closed fist detected (few or no fingers extended)
            handIconColor = .yellow
            print("🟡 Fist Detected!")
        } else if fingerCount >= 4 {
            // 🟢 Open palm detected (most fingers extended)
            handIconColor = .green
            print("🟢 Open Hand Detected!")
        } else {
            // ⚪ Indeterminate state (reset to default)
            handIconColor = .gray
        }
    }
}
