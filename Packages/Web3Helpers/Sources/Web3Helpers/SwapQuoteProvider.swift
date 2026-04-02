import Foundation

/// A quote returned by a DEX aggregator for a token swap.
public struct SwapQuote: Sendable, Equatable {
    public let amountOut: String
    public let priceImpact: Double
    public let route: [String]

    public init(amountOut: String, priceImpact: Double, route: [String]) {
        self.amountOut = amountOut
        self.priceImpact = priceImpact
        self.route = route
    }
}

/// Fetches swap quotes from a DEX aggregator API (e.g. 1inch, 0x, Uniswap).
public actor SwapQuoteProvider {

    private let aggregatorURL: URL
    private let session: URLSession

    public init(
        aggregatorURL: URL = URL(string: "https://api.example-dex-aggregator.io/v1")!,
        session: URLSession = .shared
    ) {
        self.aggregatorURL = aggregatorURL
        self.session = session
    }

    /// Fetches the best available swap quote.
    /// - Parameters:
    ///   - tokenIn: Contract address of the input token.
    ///   - tokenOut: Contract address of the output token.
    ///   - amountIn: Amount of `tokenIn` in its smallest unit (e.g. wei).
    /// - Returns: A `SwapQuote` with the expected output and route.
    /// - Throws: `Web3Error.quoteUnavailable` if the aggregator cannot find a route.
    public func fetchQuote(tokenIn: String, tokenOut: String, amountIn: String) async throws -> SwapQuote {
        var components = URLComponents(url: aggregatorURL.appendingPathComponent("quote"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "tokenIn", value: tokenIn),
            URLQueryItem(name: "tokenOut", value: tokenOut),
            URLQueryItem(name: "amountIn", value: amountIn),
        ]
        guard let url = components.url else {
            throw Web3Error.quoteUnavailable
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw Web3Error.quoteUnavailable
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard
            let amountOut = json?["amountOut"] as? String,
            let priceImpact = json?["priceImpact"] as? Double,
            let route = json?["route"] as? [String]
        else {
            throw Web3Error.quoteUnavailable
        }

        return SwapQuote(amountOut: amountOut, priceImpact: priceImpact, route: route)
    }
}
