# Banco — Modernisation Roadmap

Baseline audit against Ruby 3.4.8, October 2026. Items are grouped by category and roughly ordered by priority within each group. Behaviour changes must be covered by a test before the change is made.

---

## Ruby / Gem Compatibility

| # | Issue | File(s) | Notes |
|---|---|---|---|
| 1 | `required_ruby_version >= 1.9` — floor is over a decade past EOL | `banco.gemspec:15` | Raise to `~> 3.1` at minimum; lock to `>= 3.2` once `File.exist?` fix is in |
| 2 | `rspec ~> 2.8` incompatible with Ruby 3.2+ (`File.exists?` removed) | `banco.gemspec:16` | Fixed in Phase 0 — bumped to `~> 3.13` |
| 3 | `bigdecimal` removed from Ruby 3.4 default gems | `banco.gemspec` | Fixed in Phase 0 — added as runtime dependency |
| 4 | `csv` removed from Ruby 3.4 default gems | `banco.gemspec` | Fixed in Phase 0 — added as runtime dependency |
| 5 | `s.test_files` in gemspec is deprecated since RubyGems 3.x | `banco.gemspec:13` | Remove the line; RubyGems ignores it silently |

---

## Infrastructure Missing

| # | Issue | Notes |
|---|---|---|
| 6 | No Gemfile | Fixed in Phase 0 — added with `gemspec` source |
| 7 | No Rakefile | Fixed in Phase 0 — added with default `spec` task |
| 8 | No `.rspec` | Fixed in Phase 0 — added with `--color --format documentation` |
| 9 | No CI | Add a GitHub Actions workflow (`ruby.yml`) running `bundle exec rake spec` on push/PR, testing against Ruby 3.2, 3.3, and 3.4 |
| 10 | No `.gitignore` | At minimum: `*.gem`, `Gemfile.lock` (for a gem), `.DS_Store`, `*.txt` (output files) |

---

## Correctness / Bugs

| # | Issue | File(s) | Notes |
|---|---|---|---|
| 11 | Bare `throw` without a matching `catch` label — raises `UncaughtThrowError` on Ruby 2.0+ | `get_file.rb:30` | Replace with `raise ArgumentError, "..."` or a labelled `throw`/`catch` pair |
| 12 | `BigDecimal == Float` comparisons in specs — fragile, relies on implicit coercion | `reporter_spec.rb:40,43,48,51` | Use `eq(BigDecimal('183.34'))` or `be_within(BigDecimal('0.001')).of(...)` |
| 13 | Spec descriptions say "convert to integers" — actual behaviour is BigDecimal | `transaction_spec.rb:41,44` | Update description to match implementation |

---

## Code Quality

| # | Issue | File(s) | Notes |
|---|---|---|---|
| 14 | `puts 'formating data...'` — typo and stdout side-effect inside `initialize` | `reporter.rb:29` | Fix spelling; move output to caller or make it optional |
| 15 | Grouping key `description[0..8]` is hardcoded at 9 characters — not configurable | `reporter.rb:46,51` | Extract to a named constant or constructor parameter; add a spec that documents the current default |
| 16 | `$PROGRAM_NAME == __FILE__` debug blocks in lib files | `transaction.rb:26–32`, `reporter.rb:57–74`, `reader.rb:57–64`, `get_file.rb:36–43` | Remove; one calls `file.valid_file` which does not exist |
| 17 | `Viewable::farewell` uses `::` for method dispatch instead of `.` | `get_file.rb:9` | Use `Viewable.farewell` |
| 18 | `read_in_csv_data` rescue clauses are at method level but visually appear nested under `CSV.foreach` | `reader.rb:25–47` | Reformatting-only change; indent to method level to clarify scope |
| 19 | `transaction.rb` debug block calls `Transaction.new` with no args, then `send(:initialize, ...)` | `transaction.rb:28–31` | `initialize` is private; `new` without args would fail — remove block |

---

## Design / Features

| # | Issue | Notes |
|---|---|---|
| 20 | No optional header row handling | Some bank exports include a header; `Reader` could accept a `headers: true` option and skip row 0 |
| 21 | No spec for `Viewable` display methods (`to_pounds`, `print_summary`, `bottom_line`, etc.) | All output logic is untested |
| 22 | `GetFile` has no tests | The class is completely uncovered |
| 23 | Date stored as a raw string — not validated or parsed | Dates like `31/02/17` would pass silently |
| 24 | `Reporter#initialize` mutates `@all_transactions` via `delete_if` | Caller's array is modified in place; should operate on a dup |

---

## Repository Hygiene

| # | Issue | Notes |
|---|---|---|
| 25 | Built gem artifacts committed to the repo | Remove `banco-1.0.1.gem`, `banco-1.0.2.gem`, `banco-1.0.3.gem`; add `*.gem` to `.gitignore` |
| 26 | `README` has no extension | Rename to `README.md` and write proper Markdown documentation |
| 27 | `Gemfile.lock` committed for a gem (not an app) | Convention for gems is to gitignore `Gemfile.lock` so consumers resolve freely; add to `.gitignore` |
