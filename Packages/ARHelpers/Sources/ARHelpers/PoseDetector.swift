#if canImport(Vision)
import Vision
import CoreImage

/// Wraps a `VNDetectHumanBodyPoseRequest` for easy async use.
public final class PoseDetector: Sendable {

    public init() {}

    /// Performs body pose detection on the given `CGImage` and returns all observations.
    /// - Throws: `ARError.poseDetectionFailed` if the Vision request cannot be performed.
    public func detectPose(in image: CGImage) async throws -> [VNHumanBodyPoseObservation] {
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNDetectHumanBodyPoseRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                let observations = request.results as? [VNHumanBodyPoseObservation] ?? []
                continuation.resume(returning: observations)
            }

            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: ARError.poseDetectionFailed)
            }
        }
    }
}
#endif
