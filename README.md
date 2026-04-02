# MyAppsMonorepo

A Swift/iOS monorepo containing three production apps and six shared Swift Package Manager libraries, managed with [Tuist](https://tuist.io) and automated via GitHub Actions + Fastlane.

---

## Repository Structure

```
MyAppsMonorepo/
├── Apps/
│   ├── StepFlow/          — Step-counting & health tracking app
│   ├── PotentiaLudi/      — AR gaming + Web3/WalletConnect app
│   └── MadMech/           — OBD2 vehicle diagnostics + AR overlay app
├── Packages/
│   ├── CoreUI/            — SwiftUI design system (tokens, themes, components)
│   ├── CoreNetworking/    — URLSession API client, retry/backoff, response cache
│   ├── CoreAnalytics/     — Protocol-based event tracking with adapter pattern
│   ├── ARHelpers/         — ARKit session management, Vision pose detection, holographic overlays
│   ├── BluetoothHelpers/  — CoreBluetooth OBD2 scanner, PID parser, connection state machine
│   └── Web3Helpers/       — WalletConnect v2, SIWE auth, on-chain reads, swap quotes
├── Tuist/                 — Tuist workspace, config, and dependency manifests
├── Scripts/
│   └── fastlane/          — Build, test, and release automation
└── .github/
    └── workflows/         — GitHub Actions CI and release pipelines
```

---

## Prerequisites

| Tool | Version |
|------|---------|
| Xcode | 15.x |
| Swift | 5.9+ |
| [mise](https://mise.jdx.dev) | latest |
| Tuist | via mise |
| Fastlane | via RubyGems |

Install mise and Tuist:

```bash
brew install mise
mise install tuist
```

---

## Getting Started

```bash
# 1. Clone the repo
git clone https://github.com/your-org/MyAppsMonorepo.git
cd MyAppsMonorepo

# 2. Install SPM dependencies via Tuist
tuist install

# 3. Generate the Xcode workspace
tuist generate

# 4. Open in Xcode
open MyAppsMonorepo.xcworkspace
```

---

## Packages

### CoreUI
SwiftUI design system providing `ColorTokens`, `TypographyTokens`, `SpacingTokens`, `AppTheme`, `PrimaryButton`, `CardView`, and `LoadingIndicator`.

### CoreNetworking
Type-safe URLSession networking with `APIClient` protocol, `URLSessionClient` actor, `RetryPolicy` with exponential back-off, `ResponseCache`, and structured `NetworkError`.

### CoreAnalytics
Adapter-pattern analytics with `AnalyticsManager` actor, `ConsoleAnalyticsAdapter`, and app lifecycle events.

### ARHelpers
Wraps ARKit with `ARSessionManager`, Vision-based `PoseDetector`, and `HolographicOverlay` SwiftUI view. All types guarded with `#if canImport(ARKit)`.

### BluetoothHelpers
CoreBluetooth OBD2 integration: `OBD2Scanner`, `PIDParser` (RPM, speed, coolant temp, throttle), and `ConnectionStateMachine` actor.

### Web3Helpers
`WalletConnectManager`, `SIWEAuthManager`, `SIWEMessage` (EIP-4361), `OnChainReader` (JSON-RPC), `SwapQuoteProvider`, and `Web3Error`.

---

## Apps

### StepFlow
Step-counting app with onboarding flow, animated dashboard, and weekly progress chart.
- **Dependencies:** CoreUI · CoreNetworking · CoreAnalytics

### PotentiaLudi
AR gaming app with WalletConnect v2 integration. Connect your wallet and interact with holographic game objects.
- **Dependencies:** CoreUI · CoreNetworking · CoreAnalytics · Web3Helpers · ARHelpers

### MadMech
OBD2 vehicle diagnostics app with live BLE data and AR overlay display.
- **Dependencies:** CoreUI · CoreNetworking · CoreAnalytics · BluetoothHelpers · ARHelpers

---

## Running Tests

Run all package tests locally:

```bash
# Individual package
swift test --package-path Packages/CoreUI

# All packages via Fastlane
cd Scripts/fastlane && fastlane test_all
```

---

## CI/CD

### Continuous Integration (`ios-ci.yml`)
Triggered on every pull request and push to `main`. Runs `swift test` for all six packages in a matrix on `macos-14`.

### Release (`ios-release.yml`)
Triggered on `v*.*.*` tags. Archives each app with `gym` and uploads to TestFlight via `pilot`.

**Required Secrets:**
- `APP_STORE_CONNECT_KEY_ID`
- `APP_STORE_CONNECT_ISSUER_ID`
- `APP_STORE_CONNECT_API_KEY`
- `MATCH_PASSWORD`
- `MATCH_GIT_BASIC_AUTHORIZATION`

---

## Contributing

1. Create a feature branch: `git checkout -b feat/my-feature`
2. Add or update code and tests in the relevant Package or App
3. Run `swift test` for affected packages
4. Open a pull request — CI runs automatically

---

## License

MIT — see [LICENSE](LICENSE).
  All 3 apps (StepFlow, PotentiaLudi, MadMech) •  All shared Swift Packages (Core/, Features/, Platform/) •  Tuist configuration •  Scripts, CI workflows, README, etc.
