# Scalapay Catalog

Flutter implementation of the "Product catalog" screen from the Figma file,
using the Scalapay catalog API. Search, sort, price filter, infinite scroll.

## Requirements

- Flutter 3.44.4 (Dart 3.12)
- iOS 13+ / Android

## Setup

```bash
flutter pub get
flutter run
```

`.env.dev` is committed: it only contains the API host and the partner
parameters from the brief, no secrets. `APP_ENV` picks the env file (default
`dev`).

Generated files are committed. If you change a DTO, the API interface or the
ARB file:

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Tests

```bash
flutter test
```

Unit, bloc, widget and golden tests, everything offline. Integration test
(fake repository, runs on device/simulator):

```bash
flutter test integration_test -d <device-id>
```

Goldens were generated on macOS. On Linux the font rendering is slightly
different, so they need to be regenerated there or compared with a tolerance.
To update them: `flutter test --update-goldens test/goldens`.

Lint / format / metrics:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos
dart run dart_code_linter:metrics analyze lib --set-exit-on-violation-level=warning
```

## Project structure

```
lib/
  config/               env loading (dotenv)
  core/design_system/   Figma tokens (colors, typography, spacing) + base widgets
  core/di/              provider setup
  features/catalog/
    domain/             entities, Result, CatalogError, repository interface, use case
    data/               Retrofit API, DTOs, mappers, error mapper, repository impl
    presentation/       bloc, page, screen, bottom sheets, presenters
  l10n/                 strings (it)
```

Standard layered setup: widget -> bloc -> use case -> repository -> API. The
repository returns `Result<ProductPage>`, so the bloc only deals with
`Success`/`Failure` and a sealed `CatalogError`, never with Dio or DTOs.

DI is done with `provider` (see `initProviders`). Tests override the repository
and the image cache manager with their own providers.

Design system widgets don't know about the catalog: `AppProductCard` takes
strings, `AppProductGrid` takes an item builder, sheets take labels and
callbacks.

## State management

Bloc. There are several inputs feeding the same list (typing, search button,
sort, filter, paging, retry), so having explicit events and one immutable state
made it easier to test the edge cases without widgets.

`CatalogState`: `status` (initial / loading / success / failure), current
`ProductQuery`, products, and paging flags (`hasMore`, `isLoadingMore`,
`loadMoreFailed`). `error` is only set when status is `failure`.

Behaviour:

- Typing shows skeletons immediately, the request fires after 400 ms of
  inactivity (`debounce` + `switchMap`). Submit, sort and filter fire right
  away.
- Each request gets an incrementing id; responses with an old id are
  discarded, so a slow "nike" can't overwrite "adidas". Requests are not
  cancelled, just ignored.
- Sort/filter set before the first search are applied to it.
- Paging appends without changing status. If a page fails the loaded items
  stay and an inline retry appears; scrolling further doesn't retry
  automatically.

## API notes

Dio + Retrofit, one endpoint: `GET /v1/products/search`. Timeouts: 10 s
connect, 30 s receive (the first call after the host has been idle can take
~20 s).

`CatalogErrorMapper` maps `DioException` / JSON errors into `TimeoutError`,
`NetworkUnavailableError`, `ServerError(statusCode)`, `InvalidResponseError`,
`UnknownError`. Each one has its own message in the UI.

Things noticed while testing against the real API:

- `found` equals the page size, not the total, so there's no total count.
  Paging is 30 per page, the list ends when a page comes back shorter.
- `sort_by=title:asc|desc` is ignored by the backend (results come back in
  relevance order). The params are still sent, so "Nome A-Z / Z-A" will work
  when the backend supports it. No client-side sorting since it would only
  sort the loaded pages.
- `selling_price` can be `int` or `double`. `has_image = 0` means the URL is
  not usable.
- No installment data in the response. The "3 rate da" line is
  `selling_price / 3` (`InstallmentPlan.payInThree`). That's why the card shows
  28,33 for 85,00 € while the Figma mockup shows 23,33.
- A malformed document fails the whole page with `InvalidResponseError`
  instead of being skipped.

## Testing

108 tests, no network.

- Data: request params, DTO parsing against a real response fixture, repository
  through Retrofit with a fake Dio adapter (ok, timeout, offline, 400, truncated
  JSON, wrong shape).
- Bloc (`bloc_test`): debounce, submit, empty result, failure + retry, sort and
  filter reload, stale responses ignored, paging, failed page, new search while
  a page is loading.
- Widgets: all states, debounce through the real text field, both sheets and
  their validation, infinite scroll, inline retry, image placeholder, 320–800 px
  widths, text scale 2.0, semantics.
- Goldens: main screen and the two sheets at 375×812 with Poppins, compared
  against the Figma exports. A few geometry tests for the measured sizes.

## Implementation notes

- Two columns at every width like the design; cards just get wider on tablet.
  The grid is a `SliverList` of rows instead of `SliverGrid` because the text
  block has variable height (two-line titles, large text scale).
- Images via `cached_network_image` with a max decode width; placeholder on
  missing/failed image.
- Search bar and chips stay pinned while the title scrolls away. A dot on
  "Filtri"/"Ordina" shows that a filter/sort is active (not in the Figma, there
  is no active state for the chips). Tapping the selected sort again clears it,
  since there's no "relevance" option in the sheet.
- Price inputs: digits with `,` or `.` and max two decimals. Inverted ranges
  are blocked by the validator before any request.
- Italian only, locale-locked to match the design. Strings in an ARB file.
- Palette names follow the Figma color styles (`lilac900`, `grayscale700`).
- Accessibility checked with the Android accessibility tree on a Pixel 9:
  chips announce the applied filter/sort, cards are read as one item, sort
  options are radio buttons, state messages and result count are live regions.
  The 12 px grey price line (~3.4:1) and the 32 px chips come from the design.

## Out of scope

Kept to what's in the Figma. Product detail / merchant page are not there, so
not implemented; `Product` already carries `id`, `merchant` and image URL, and
the card would only need an `onTap`.

Not done: request cancellation, results cache, state restoration, crash
reporting/analytics (`UnknownError` keeps the original exception for that).

## Release

Android: R8 + resource shrinking, signing from a git-ignored `key.properties`
(falls back to debug), no cleartext traffic. Both platforms build with
obfuscation:

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
flutter build ios --release --obfuscate --split-debug-info=build/symbols
```

iOS needs a team in Xcode, or `--no-codesign`. Launcher icon is the Flutter
default.
