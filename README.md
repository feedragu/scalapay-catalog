# Scalapay Catalog

Flutter implementation of the "Product catalog" screen from the Figma file,
backed by the Scalapay catalog API: search, sort, price filter and infinite
scroll.

## Requirements

- Flutter 3.44.4 (Dart 3.12)
- iOS 13+, Android 7 (API 24)+

## Setup

```bash
flutter pub get
flutter run
```

`.env.dev` is committed because it holds nothing secret, only the API host and
the partner parameters from the brief. `APP_ENV` picks the env file (default
`dev`).

Generated files are committed too. After changing a DTO, the API interface or
the ARB file, regenerate them:

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Tests

```bash
flutter test
```

Unit, bloc, widget and golden tests; none of them touch the network. The
integration test uses a fake repository and runs on a device or simulator:

```bash
flutter test integration_test -d <device-id>
```

I generated the goldens on macOS. Linux rasterizes fonts slightly differently,
so on Linux either regenerate them or compare with a tolerance. To update them:
`flutter test --update-goldens test/goldens`.

Format, lint and metrics gates:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos
dart run dart_code_linter:metrics analyze lib --set-exit-on-violation-level=warning
```

Mutation testing (`mutation_test`, config in `mutation_test.xml`) covers the
deterministic layers: domain rules, request building, error mapping,
repository, bloc, presenters and config. Needs an lcov file so uncovered lines are
skipped:

```bash
flutter test --coverage
dart run mutation_test -c coverage/lcov.info mutation_test.xml
```

Last run: 127 mutants, 126 detected (rating A). The survivor is the
`APP_ENV` mismatch guard in `RuntimeConfig`, unreachable without a second env
asset.

## What the tests cover

119 tests.

- Data: request params (page size vs 300 window), DTO parsing against a real
  response fixture, repository through Retrofit with a fake Dio adapter (ok,
  timeout, offline, 400, truncated JSON, wrong shape, end of the window).
- Domain: price range rules, installment split, name sort key (case and
  Latin accents folded, stable ties), use case (name sorts applied locally,
  paging closed, failures passed through).
- Bloc (`bloc_test`): immediate feedback + debounce, submit, empty result,
  failure + retry, sort and filter reload, stale responses ignored, paging,
  failed page, duplicate page, new search while a page is loading.
- Widgets: all states, debounce through the real text field, both sheets and
  their validation, infinite scroll, inline retry, image placeholder, widths
  from 320 to 800 px, text scale 2.0, collapsing title and pinned chips,
  scroll position on new query vs new page, semantics (field name, chip
  badges, headings, live regions).
- Goldens: main screen and the two sheets at 375×812 with Poppins, compared
  against the Figma exports. A few geometry tests for the measured sizes.

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
repository returns `Result<ProductPage>`, so the bloc only sees
`Success`/`Failure` and a sealed `CatalogError`, never Dio or DTOs.

`provider` handles DI (see `initProviders`). Tests override the repository and
the image cache manager with their own providers.

Design system widgets know nothing about the catalog: `AppProductCard` takes
strings, `AppProductGrid` takes an item builder, sheets take labels and
callbacks.

## State management

Bloc. Several inputs feed the same list (typing, the search button, sort,
filter, paging, retry), and explicit events plus one immutable state made the
edge cases testable without widgets.

`CatalogState`: `status` (initial / loading / success / failure), current
`ProductQuery`, products, and paging flags (`hasMore`, `isLoadingMore`,
`loadMoreFailed`). `error` is only set when status is `failure`.

Behaviour:

- Typing shows skeletons immediately, the request fires after 400 ms of
  inactivity (`debounce` + `switchMap`). Submit, sort and filter fire right
  away.
- Each request gets an incrementing id and the bloc discards responses with
  an old id, so a slow "nike" cannot overwrite "adidas". The app never cancels
  a request, it only ignores the reply.
- Sort/filter set before the first search are applied to it.
- Paging appends without changing status and stops at the API window (300
  results, see API notes). If a page fails the loaded items stay and an
  inline retry appears; scrolling further doesn't retry automatically.

## API notes

Dio + Retrofit, one endpoint: `GET /v1/products/search`. Timeouts are 10 s to
connect and 30 s to receive.

`CatalogErrorMapper` maps `DioException` / JSON errors into `TimeoutError`,
`NetworkUnavailableError`, `ServerError(statusCode)`, `InvalidResponseError`,
`UnknownError`. Each one has its own message in the UI.

Things noticed while testing against the real API:

- `found` equals the page size, not the total, so there is no total count.
  Pages hold 30 items and the list ends on a short page or at the API window:
  a query serves at most 300 results, and past that the gateway returns page
  1 again (page 11 == page 1 on every query I tried). The repository therefore
  stops at 300 and the bloc drops ids it already has. The Scalapay app behaves
  the same way: after ten pages it stops loading.
- The brief allows `sort_by` only with `_text_match` or `selling_price`, and
  the gateway enforces exactly that: any other key (`title`, `list_price`,
  `id`) or a bad direction gets a 200 with the relevance order,
  and in `title:asc,selling_price:asc` only `selling_price` is applied. The
  design's "Nome A-Z / Z-A" are therefore outside the API contract. See
  "Name sorting" below for what the app does about it.
- `per_page` is capped at 300 (asking for 500 returns 300); the same 300 is
  the whole window a query can ever reach.
- Of the two documented hosts only `catalog-api.dev-cat.scalapay.com` is
  usable: `catalog-api.dev.scalapay.com` answers 401 "Authorization header
  not found" and the brief provides no credentials.
- `minPrice` / `maxPrice` are inclusive and server-side, and work with a
  single bound too (`maxPrice=10.0` → everything ≤ 10).
- `selling_price` arrives as `int` or `double`. `has_image = 0` means the URL
  is not usable.
- The response carries no installment data. The "3 installments of" line is
  `selling_price / 3` (`InstallmentPlan.payInThree`), which is why the card
  shows 28,33 for 85,00 € while the Figma mockup shows 23,33.
- A malformed document fails the whole page with `InvalidResponseError`
  rather than being skipped.

## Name sorting

The design has "Nome A-Z / Z-A"; the API contract only sorts by `_text_match`
and `selling_price`, and the gateway ignores any other key (see API notes).
Sorting on the client only the pages already loaded is not an option: the list
would reshuffle on every scroll and never show the real order.

What the app does: for the two name sorts it requests the relevance order for
the whole window a query can reach (`per_page=300`, one request, 1 to 2 s), and
`SearchProductsUseCase` sorts that window ignoring case and Latin accents
(Dart has no locale collation, so `ProductSort` folds them itself) and closes
paging.
The list is complete and stable, and the request stays inside the contract.

This holds because 300 is the same ceiling every sort reaches through paging
(page 11 wraps to page 1), so the alphabetical list covers exactly the products
the other sorts can show, in one request instead of ten. The cost is that first
request, heavier than a 30-item page. Relevance and price stay paged.

The workaround lives in one place, the use case; a backend sort would replace
it there without touching the bloc or the UI.

Alternatives: hiding the two options matches the API but not the design;
leaving them inert looks broken. The production Scalapay app sidesteps the
question with three sorts (featured, price asc/desc).

## Implementation notes

- Two columns at every width, like the design; cards simply get wider on a
  tablet. The grid is a `SliverList` of rows rather than a `SliverGrid`
  because the text block has variable height (two-line titles, large text
  scale).
- Images via `cached_network_image` with a max decode width; placeholder on
  missing/failed image.
- Scrolling follows the Scalapay app: the large title contracts into a
  centred compact bar with a divider, the search bar scrolls away with the
  content and the chips stay pinned under the bar. A count badge on
  "Filtri"/"Ordina" shows an applied filter/sort, as in the Scalapay app (the
  Figma has no active state for the chips). Tapping the selected sort again
  clears it, since there's no "relevance" option in the sheet.
- Price inputs accept digits with `,` or `.` and at most two decimals. The
  validator blocks inverted ranges before any request goes out.
- Italian only, locale-locked to match the design, with the strings in an ARB
  file. The price line ("85,00€ or / 3 installments of €28,33") is English in
  the Figma and is kept as designed; it is the `fullPrice` / `installments`
  pair in the ARB, so localising it is a one-line change.
- Palette names follow the Figma color styles (`lilac900`, `grayscale700`).
- Accessibility checked with the Android accessibility tree on a Pixel 9:
  chips announce the applied filter/sort, cards are read as one item, sort
  options are radio buttons, state messages and result count are live regions.
  The 12 px grey price line (~3.4:1) and the 32 px chips come from the design.


## Release

Android uses R8 with resource shrinking, signs from a git-ignored
`key.properties` (falling back to the debug key) and refuses cleartext
traffic. Both platforms build with obfuscation:

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
flutter build ios --release --obfuscate --split-debug-info=build/symbols
```

iOS needs a team in Xcode, or `--no-codesign`. Launcher icon is the Flutter
default.
