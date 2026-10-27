# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2.0.0] — 2026-10-27

### Added

- `Transaction` is now a `Data.define` value object — frozen, comparable by value, keyword-constructed
- `Parser` — single-responsibility CSV reader; raises `ArgumentError` on bad money values or missing files
- `Grouper` — pure aggregation: `Array<Transaction>` → `Report`; accepts `from:`/`to:` date filters
- `Report` — `Data.define` value object holding all computed totals; no display logic
- `Formatter::Base` with `inherited` self-registration hook — adding a formatter auto-updates `--format` validation and `--help` output
- `Formatter::Text` — all display logic in one place; interactive menu returns Strings (no direct IO)
- `Formatter::JSON` and `Formatter::CSV` — pipe-friendly output; program exits after printing
- `CLI` — full `OptionParser` interface: `--file`, `--format`, `--bank`, `--prefix-length`, `--header`, `--from`, `--to`, `--version`, `--help`
- `FilePicker` — numbered CSV list when no `--file` given; testable via stdin/stdout injection
- `BankFormat` DSL — `BankFormat.define(:name) { ... }` via `instance_eval`; three built-ins (`:legacy`, `:split_columns`, `:signed_amount`); user formats load from `~/.banco/formats.rb`
- `--from`/`--to` date filtering; dates parsed using the selected bank format's `date_fmt`
- `Transaction#parsed_date` — `Date` object computed at parse time from `fmt.date_fmt`
- GitHub Actions CI matrix across Ruby 3.2, 3.3, 3.4
- RuboCop + rubocop-rspec + rubocop-performance enforced on every push
- `spec/fixtures/` synthetic CSV data; no real bank statements in the repo

### Changed

- Money stored as integer pence throughout (`credit_pence`/`debit_pence`); `bigdecimal` runtime dependency removed
- `bin/banco` uses `CLI.parse` + `FilePicker.pick` instead of interactive stdin prompting at startup
- Non-text output formats (`--format json`, `--format csv`) write to stdout and exit — pipe-friendly
- `required_ruby_version` tightened to `>= 3.2`
- Spec files excluded from the built gem (`s.files` no longer includes `spec/`)

### Removed

- `Reader` — replaced by `Parser`
- `Reporter` — replaced by `Grouper` + `Report`
- `Viewable` mixin — replaced by `Formatter::Text`
- `GetFile` — replaced by `FilePicker`
- `bigdecimal` runtime dependency

## [1.0.3] — 2019-11-01

Initial public release.
