#if canImport(ARKit)
import ARKit
import Combine

/// Manages the lifecycle of an `ARSession` and broadcasts frame/event updates via Combine.
@MainActor
public final class ARSessionManager: NSObject, ARSessionDelegate {

    // MARK: - Public publishers

    /// Emits each `ARFrame` as it is processed.
    public let frameSubject = PassthroughSubject<ARFrame, Never>()
    /// Emits the new set of `ARAnchor` objects whenever anchors are added.
    public let anchorsAddedSubject = PassthroughSubject<[ARAnchor], Never>()
    /// Emits `ARError.sessionFailed` when the session fails.
    public let errorSubject = PassthroughSubject<ARError, Never>()

    // MARK: - Private state

    private let session: ARSession

    public override init() {
        self.session = ARSession()
        super.init()
        session.delegate = self
    }

    // MARK: - Lifecycle

    /// Configures and starts (or restarts) the AR session.
    public func run(with configuration: ARConfiguration = ARWorldTrackingConfiguration()) {
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    /// Pauses the AR session.
    public func pause() {
        session.pause()
    }

    // MARK: - ARSessionDelegate

    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        frameSubject.send(frame)
    }

    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        anchorsAddedSubject.send(anchors)
    }

    public func session(_ session: ARSession, didFailWithError error: Error) {
        errorSubject.send(.sessionFailed(reason: error.localizedDescription))
    }
}
#endif
