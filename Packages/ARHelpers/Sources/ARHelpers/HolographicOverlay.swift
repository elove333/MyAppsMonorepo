import SwiftUI

#if canImport(ARKit) && canImport(RealityKit)
import ARKit
import RealityKit

// MARK: - UIViewRepresentable wrapper

/// Bridges `ARView` into SwiftUI.
public struct ARViewContainer: UIViewRepresentable {
    public init() {}

    public func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config)
        return arView
    }

    public func updateUIView(_ uiView: ARView, context: Context) {}
}

// MARK: - HolographicOverlay

/// A SwiftUI view that composites an AR camera feed with arbitrary SwiftUI overlay content.
public struct HolographicOverlay<Overlay: View>: View {
    private let overlay: Overlay

    public init(@ViewBuilder overlay: () -> Overlay) {
        self.overlay = overlay()
    }

    public var body: some View {
        ZStack {
            ARViewContainer()
                .ignoresSafeArea()

            overlay
        }
    }
}

#else

/// Fallback stub for platforms without ARKit/RealityKit.
public struct HolographicOverlay<Overlay: View>: View {
    private let overlay: Overlay

    public init(@ViewBuilder overlay: () -> Overlay) {
        self.overlay = overlay()
    }

    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("AR not supported on this platform")
                .foregroundStyle(.white)
            overlay
        }
    }
}

#endif
