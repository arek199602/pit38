# PIT-38 — capital-gains tax calculator

Tax calculator for Polish investors who use **foreign brokers** (Trading 212,
Interactive Brokers, Revolut) that do **not** issue a Polish PIT-8C form. It
reconstructs the PIT-38 capital-gains settlement from broker exports: FIFO cost
basis, NBP mid rates from the business day before each transaction (T-1),
foreign dividends with withholding-tax credit, and loss carry-forward.

> **Status: early development.** The application skeleton, tooling and CI are in
> place. The tax engine and the calculator UI are being built step by step.

## Tech stack

- **Ruby** 4.0.5, **Rails** 8.1.3
- **Inertia.js** + **Vue 3** + **Vite** (frontend)
- **SQLite** via Active Record; Solid Queue / Cache / Cable
- **RuboCop** (omakase), **Brakeman**, **bundler-audit**
- **Capybara + Playwright** for system tests (no Selenium)

## Requirements

- Ruby `4.0.5` (see `.ruby-version`)
- Node `22.17.1` (see `.node-version`)

## Getting started

```bash
bundle install
npm install
bin/dev            # http://localhost:3000
```

## Testing

```bash
bin/rails test                 # unit & integration tests
npx playwright install chromium
bin/rails test:system          # system tests (Capybara + Playwright, headless chromium)
```

## Code quality

RuboCop, Brakeman and bundler-audit run both in CI and in a local pre-push hook.
Enable the hook once per clone:

```bash
git config core.hooksPath .githooks
```

The hook blocks a push if linting, security scans or tests fail
(`git push --no-verify` bypasses it). System tests run in CI only.

## Continuous integration

GitHub Actions (`.github/workflows/ci.yml`) runs on every push to `main` and on
pull requests: `scan_ruby`, `lint`, `test`, `system-test`.

## Roadmap

- [ ] `Transaction` model and broker CSV import (Trading 212, IBKR, Revolut)
- [ ] FIFO cost basis (art. 24 ust. 10) with NBP T-1 mid rates (art. 11a)
- [ ] Foreign dividends with withholding-tax credit (PIT-38 section G)
- [ ] PIT-38 / PIT-ZG field output and e-Deklaracje XML
