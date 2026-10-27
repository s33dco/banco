# Banco — Modernisation Roadmap

Baseline audit against Ruby 3.4.8, October 2026. Items are grouped by category and roughly ordered by priority within each group. Behaviour changes must be covered by a test before the change is made.

---

## Ruby / Gem Compatibility

| # | Issue | File(s) | Notes |
|---|---|---|---|
| 1 | `required_ruby_version >= 1.9` — floor is over a decade past EOL | `banco.gemspec:15` | Resolved — raised to `>= 3.2` |
| 2 | `rspec ~> 2.8` incompatible with Ruby 3.2+ (`File.exists?` removed) | `banco.gemspec:16` | Resolved — bumped to `~> 3.13` |
| 3 | `bigdecimal` removed from Ruby 3.4 default gems | `banco.gemspec` | Resolved — added as runtime dependency |
| 4 | `csv` removed from Ruby 3.4 default gems | `banco.gemspec` | Resolved — added as runtime dependency |
| 5 | `s.test_files` in gemspec is deprecated since RubyGems 3.x | `banco.gemspec:13` | Resolved — removed |

---

## Infrastructure Missing

| # | Issue | Notes |
|---|---|---|
| 6 | No Gemfile | Resolved |
| 7 | No Rakefile | Resolved |
| 8 | No `.rspec` | Resolved |
| 9 | No CI | Open — GitHub Actions workflow (`ruby.yml`) not yet added |
| 10 | No `.gitignore` | Resolved — added with `*.gem`, `Gemfile.lock`, `*.txt`, `.DS_Store` |

---

## Correctness / Bugs

| # | Issue | File(s) | Notes |
|---|---|---|---|
| 11 | Bare `throw` without a matching `catch` label — raises `UncaughtThrowError` on Ruby 2.0+ | `get_file.rb:30` | Resolved — replaced with `raise ArgumentError` |
| 12 | `BigDecimal == Float` comparisons in specs — fragile, relies on implicit coercion | `reporter_spec.rb:40,43,48,51` | Resolved — all money expectations use `BigDecimal()` constructors |
| 13 | Spec descriptions say "convert to integers" — actual behaviour is BigDecimal | `transaction_spec.rb:41,44` | Resolved — descriptions updated |

---

## Code Quality

| # | Issue | File(s) | Notes |
|---|---|---|---|
| 14 | `puts 'formating data...'` — typo and stdout side-effect inside `initialize` | `reporter.rb:29` | Typo resolved; stdout side-effect remains (future phase) |
| 15 | Grouping key `description[0..8]` is hardcoded at 9 characters — not configurable | `reporter.rb:46,51` | Resolved — extracted to `GROUPING_PREFIX_LENGTH` constant with spec |
| 16 | `$PROGRAM_NAME == __FILE__` debug blocks in lib files | `transaction.rb:26–32`, `reporter.rb:57–74`, `reader.rb:57–64`, `get_file.rb:36–43` | Resolved — removed |
| 17 | `Viewable::farewell` uses `::` for method dispatch instead of `.` | `get_file.rb:9` | Resolved |
| 18 | `read_in_csv_data` rescue clauses are at method level but visually appear nested under `CSV.foreach` | `reader.rb:25–47` | Resolved — re-indented |
| 19 | `transaction.rb` debug block calls `Transaction.new` with no args, then `send(:initialize, ...)` | `transaction.rb:28–31` | Resolved — removed with all debug blocks |

---

## Design / Features

| # | Issue | Notes |
|---|---|---|
| 20 | No optional header row handling | Resolved — `Reader.new(file, name, skip_header: true)` skips row 0 |
| 21 | No spec for `Viewable` display methods (`to_pounds`, `print_summary`, `bottom_line`, etc.) | Resolved — `spec/banco/viewable_spec.rb` added |
| 22 | `GetFile` has no tests | Resolved — `spec/banco/get_file_spec.rb` added covering `file_checker_cleaner` |
| 23 | Date stored as a raw string — not validated or parsed | Open — deferred; validation would require choosing a date library |
| 24 | `Reporter#initialize` mutates `@all_transactions` via `delete_if` | Resolved — `transactions.dup` assigned to `@all_transactions` |
| 25 | `reporter_spec.rb` `before` block re-runs all four aggregation methods that `initialize` already ran — all totals and hashes are doubled | Resolved — redundant method calls removed; expected values corrected |

---

## Repository Hygiene

| # | Issue | Notes |
|---|---|---|
| 26 | Built gem artifacts committed to the repo | Resolved — removed via `git rm`; `*.gem` added to `.gitignore` |
| 27 | `README` has no extension | Resolved — renamed to `README.md` with Markdown content |
| 28 | `Gemfile.lock` committed for a gem (not an app) | Resolved — added to `.gitignore`; consumers resolve dependencies freely |

---

*All items resolved except item 9 (CI / GitHub Actions — deferred). See git log for details.*
