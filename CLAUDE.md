# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

`RozetkaPaySDK` is a Swift Package (SwiftPM, no other dependencies) that ships a SwiftUI-based payment SDK for iOS 15+. It is published as the `RozetkaPaySDK` library product and consumed by host apps via SPM (`https://github.com/rozetkapay/ios-sdk`). Swift tools 5.10. Default localization `en`.

There is no Xcode project file — everything is driven by `Package.swift`. Resources (`Colors.xcassets`, `Images.xcassets`, `Localizable.xcstrings`) live under `Sources/Resources` and are bundled via `Bundle.module`.

## Common commands

```bash
# Build the library for the host toolchain
swift build

# Build for iOS Simulator (the only supported runtime platform — iOS 15+)
xcodebuild -scheme RozetkaPaySDK -destination 'generic/platform=iOS Simulator' build

# Run all tests (currently only a placeholder XCTest exists in Tests/RozetkaPaySDKTests)
swift test

# Run a single test
swift test --filter RozetkaPaySDKTests.testExample
```

There is no lint config in the repo. The package has zero external dependencies — do not add any without a strong reason.

## Big-picture architecture

The SDK exposes four things to host apps:

1. **`RozetkaPaySdk.initSdk(...)`** — required one-time bootstrap (in `App.init` or `AppDelegate`). Stores `UIApplication`, mode (`.production` / `.development`), logging flag, validation rules, and decimal separator as **static state** on `RozetkaPaySdk`. Anything that needs the app context (Apple Pay, navigation) reads `RozetkaPaySdk.appContext` and crashes with `fatalError` if `initSdk` was not called.

2. **`PayView`** (SwiftUI) — entry point for one-shot payments. Two public initializers:
   - `init(paymentParameters: PaymentParameters, onResultCallback:)` — single-order payment.
   - `init(batchPaymentParameters: BatchPaymentParameters, onResultCallback:)` — multi-order batch payment in one transaction.

3. **`TokenizationView`** (SwiftUI) — self-contained entry point for collecting/tokenizing a card without charging it (renders its own loader/error/success states).

4. **`TokenizationFormView<Content: View>`** (SwiftUI) — the **embeddable** card-tokenization form. Unlike `TokenizationView`, it is designed to be dropped *inside* a host's own screen/form, and is the variant most host apps actually use. Its `init(parameters: TokenizationFormParameters, onResultCallback: TokenizationFormResultCompletionHandler, stateUICallback: TokenizationFormUIStateCompletionHandler, @ViewBuilder cardFormFooterEmbeddedContent:)` exposes two callbacks: `onResultCallback` delivers a `TokenizationFormResult` (`.complete / .failed / .cancelled`), and `stateUICallback` emits `TokenizationFormUIState` (`.startLoading / .stopLoading / .success / .error(String)`) so the host can drive its **own** loader/buttons instead of the SDK rendering them. The `@ViewBuilder cardFormFooterEmbeddedContent` slot lets the host inject content under the card fields (defaults to `EmptyView`). Backed by `TokenizationFormViewModel` → `TokenizationService.tokenizeCard`.

All these flows share the same architectural spine:

```
View (SwiftUI)  ──▶  ViewModel (@MainActor, ObservableObject, extends BaseViewModel)
                          │
                          ├──▶ Service layer  (PayService / BatchPayService /
                          │     TokenizationService / ApplePaymentService)
                          │           │
                          │           └──▶ APIConfiguration enums (e.g. PayServiceEndpoint)
                          │                       │
                          │                       └──▶ NetworkManager (URLSession + async/await)
                          │
                          └──▶ Validators / Masks / UseCases (Helpers/)
```

Key cross-cutting concepts you'll keep tripping over:

- **Environment selection is implicit.** `EnvironmentProvider.environment` reads `RozetkaPaySdk.mode` and returns `RozetkaPayConfig.prodEnvironment` or `devEnvironment` (URLs hardcoded in `Configuration/RozetkaPayConfig.swift`). Don't pass URLs around manually — rely on the provider.

- **Networking is protocol-based.** Endpoints are `enum`s conforming to `APIConfiguration` (see `Network/NetworkManager.swift`). The default `execute<T, E>(...)` extension does the URLSession work, decodes `T` on 2xx, decodes `E` on failure, and throws a typed `APIError<E>` (validation / networkUnreachable / external / decodingFailure / unknown). New endpoints should follow this shape rather than calling URLSession directly.

- **Request signing.** Outgoing payment/tokenization bodies are signed with HMAC-SHA256 using `Network/RequestSigner.swift`. The signer canonicalizes JSON (sorted keys, recursive flattening to a single string) before HMAC. Header is `X-Sign`; `X-Widget-Id` and `Authorization: Basic <token>` are also part of the auth scheme. `ClientAuthParameters(token:, widgetKey:)` carries both keys.

- **Polling for terminal state.** `PayService.checkPayment` (and the batch equivalent) loop on the check endpoint until `PaymentStatus.isTerminated` or until `RozetkaPayConfig.DEFAULT_RETRY_TIMEOUT` (30s) elapses, sleeping `DEFAULT_RETRY_DELAY` (1s) between attempts. If timeout hits, the result is `.pending` with a `PaymentError` carrying `ErrorResponseCode.pending` — not `.failed`. Preserve this distinction.

- **Result types are terminal enums.** `PaymentResult` and `BatchPaymentResult` have four cases — `.complete / .pending / .failed / .cancelled`. `TokenizationResult` and `TokenizationFormResult` have three each — `.complete / .failed / .cancelled` (no `.pending`, since tokenization doesn't poll). `TokenizationFormView` additionally streams progress via the non-terminal `TokenizationFormUIState` (`.startLoading / .stopLoading / .success / .error`) through its `stateUICallback`. All public result callbacks (`PaymentResultCompletionHandler`, etc.) deliver one of the terminal enums. Don't invent new completion shapes.

- **`PaymentTypeConfiguration`** drives whether the UI renders card input + Apple Pay (`.regular(RegularPayment)`) or skips input entirely for a server-tokenized card (`.singleToken(SingleTokenPayment)`). Apple Pay availability is gated through `ApplePayConfig.checkApplePayAvailability()` and is always `false` for `.singleToken`.

- **Validation lives in `Helpers/Validators`**, masks in `Helpers/Masks`. `BaseViewModel.validateAll()` is the single place that runs every field validator and produces a `ValidationResultModel`. Field requirement (`.none / .optional / .required`) comes from the `ViewParametersProtocol` of the active flow — respect this when adding new fields.

- **Theming is dependency-injected.** `RozetkaPayThemeConfigurator` (mode + light/dark `DomainColorScheme` + `DomainSizes` + `DomainTypography`) flows through `ParametersProtocol` into every ViewModel and View. Resolve actual colors via `themeConfigurator.colorScheme(colorScheme)` against the SwiftUI `@Environment(\.colorScheme)` — don't read raw colors from assets directly in views.

- **Logging is opt-in, OSLog-based.** `Logger` extension in `Extensions/LoggerExtensions.swift` defines categorized loggers (`network`, `payServices`, `tokenizedCard`, `payByApplePay`, `viewCycle`, etc.). All log helpers short-circuit when `RozetkaPaySdk.isLoggingEnabled` is `false`. Use the existing categories rather than creating new ones ad-hoc.

- **Localization** uses `Localizable.xcstrings` (string catalog) accessed through `Localization` enum + `StringResources`. New user-visible strings go in the catalog; reference them via the `Localization` enum.

- **3DS handling.** `ThreeDSView` / `ThreeDSWebViewWrapper` / `ThreeDSViewModel` host a `WKWebView` that loads the issuer page; the SDK detects completion by matching `RozetkaPayEnvironment.paymentsConfirmation3DsCallbackUrl`. `PayView` presents 3DS via `fullScreenCover` driven by `viewModel.isThreeDSConfirmationPresented`.

## Conventions worth following

- **Public surface is intentionally narrow.** Only the entry points (`RozetkaPaySdk`, `PayView`, `TokenizationView`, `TokenizationFormView`), their parameter structs (`PaymentParameters`, `BatchPaymentParameters`, `TokenizationParameters`, `TokenizationFormParameters`, `ClientAuthParameters`, `ClientWidgetParameters`, `AmountParameters`, `BatchOrder`, `RozetkaPayThemeConfigurator`, `PaymentTypeConfiguration`, etc.), result enums, and a few protocols are `public`. Prefer `internal` for anything new unless a host app demonstrably needs it.

- **ViewModels are `@MainActor` `ObservableObject` subclasses of `BaseViewModel`.** When adding a new flow, extend `BaseViewModel` so you inherit the form fields, validation pipeline, and loader/error/alert plumbing rather than re-implementing them.

- **Service classes are `open class` with `static` methods** (`PayService`, `TokenizationService`, `BatchPayService`). They take a `key` (HMAC key from `ClientAuthParameters`) plus a request model and an `@escaping` completion handler. New service calls should match this shape.

- **Errors decode through typed `APIError<E>`** where `E` is `PaymentError` or `TokenizationError`. Each error type has a `convertFrom(_ apiError:)` static helper to translate transport-level failures into the domain error — use it instead of inventing new bridging code.
