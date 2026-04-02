import Foundation

/// An in-memory cache for raw response `Data` keyed by `URL`.
/// Automatically evicts entries when the app receives a memory-pressure warning.
public actor ResponseCache {
    private let cache = NSCache<NSURL, NSData>()
    private var memoryWarningObserver: NSObjectProtocol?

    public init(countLimit: Int = 200, totalCostLimit: Int = 50 * 1024 * 1024) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }

    /// Starts observing memory-pressure notifications and evicts cached entries on warning.
    /// Call once after initialisation from a `@MainActor` context.
    public func startObservingMemoryWarnings() {
        let cacheRef = cache
        memoryWarningObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { _ in
            cacheRef.removeAllObjects()
        }
    }

    deinit {
        if let observer = memoryWarningObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    /// Stores `data` for the given `url`.
    public func store(_ data: Data, for url: URL) {
        cache.setObject(data as NSData, forKey: url as NSURL, cost: data.count)
    }

    /// Returns cached data for `url`, or `nil` if no entry exists.
    public func data(for url: URL) -> Data? {
        cache.object(forKey: url as NSURL) as Data?
    }

    /// Removes the cached entry for `url`.
    public func remove(for url: URL) {
        cache.removeObject(forKey: url as NSURL)
    }

    /// Removes all cached entries.
    public func removeAll() {
        cache.removeAllObjects()
    }
}
