# Banco

Summarise bank statement CSV files from the command line.

## Installation

```sh
gem install banco
```

Requires Ruby >= 3.2.

## Usage

Navigate to the directory containing your CSV file and run:

```sh
banco
```

Banco scans for CSV files, lets you pick one (or pass `--file`), then
presents an interactive menu:

| Key | Action |
|-----|--------|
| `a` | All transactions |
| `o` | Outgoing transactions |
| `i` | Incoming transactions |
| `m` | Money-out summary (grouped) |
| `n` | Money-in summary (grouped) |
| `b` | Bottom line (net position) |
| `s` | Save summary to file |
| `t` | Save transactions to file |
| `l` | Load a new file |
| `q` | Quit |

Use `--format json` or `--format csv` for pipe-friendly output (no menu, exits after printing).

## CLI flags

| Flag | Default | Description |
|------|---------|-------------|
| `-f`, `--file FILE` | — | CSV file to analyse |
| `-F`, `--format FORMAT` | `text` | Output format: `text` / `json` / `csv` |
| `-b`, `--bank NAME` | `legacy` | Bank CSV format (see Bank formats below) |
| `-p`, `--prefix-length N` | `9` | Description prefix length for grouping |
| `-H`, `--header` | off | Skip first row as header |
| `--from DATE` | — | Filter from date (format matches bank format) |
| `--to DATE` | — | Filter to date (format matches bank format) |
| `-v`, `--version` | — | Print version and exit |
| `-h`, `--help` | — | Show help and exit |

### Examples

```sh
# Summarise all transactions in statements.csv
banco --file statements.csv

# September only, JSON output
banco --file statements.csv --from 01/09/17 --to 30/09/17 --format json

# Skip header row, group by first 6 characters
banco --file export.csv --header --prefix-length 6
```

## Bank formats

| Name | Date format | Columns | Notes |
|------|-------------|---------|-------|
| `legacy` | `%d/%m/%y` | date, description, type, credit, debit | Default — Barclays-style, separate money-in / money-out columns |
| `split_columns` | `%d/%m/%Y` | date, description, type, credit, debit | Like `legacy` with a 4-digit year |
| `signed_amount` | `%Y-%m-%d` | date, description, amount | Single signed amount column, no type column |

### Signed amount columns

When a format maps `credit_column` and `debit_column` to the **same** column
(as `signed_amount` does), that column is read as a single **signed** amount:
positive values are treated as money in (credit) and negative values as money
out (debit). Formats with separate credit and debit columns (like `legacy` and
`split_columns`) read each column directly.

### Custom formats

Define your own format in `~/.banco/formats.rb`:

```ruby
Banco::BankFormat.define(:my_bank) do
  date_column        0
  description_column 2
  type_column        1
  credit_column      3
  debit_column       4
  date_format        '%Y-%m-%d'
end
```

Then use it with `banco --bank my_bank`.

## CSV format (legacy)

Banco's default (`--bank legacy`) expects **no header row** and columns in this order:

| # | Content |
|---|---------|
| 1 | Date (`dd/mm/yy`) |
| 2 | Description |
| 3 | Type |
| 4 | Money in |
| 5 | Money out |

Pass `--header` if your export includes a header row. Any columns beyond the fifth are ignored.

## Where metaprogramming was used — and where it was not

**Used:**

- **`inherited` hook** (`Formatter::Base`) — each formatter subclass self-registers in a central registry. `--format` validation and `--help` output both read from the same registry, so they can never drift apart.
- **`instance_eval`** (`BankFormat.define`) — builds a column-mapping configuration object from a concise DSL block. The block runs in the context of a fresh `BankFormat` instance, so DSL methods (`date_column`, `credit_column`, etc.) are just setters. No `method_missing`, no `define_method`, no runtime method generation.

**Deliberately not used:**

- **`method_missing`** for `report.groceries`-style accessors — fragile, hard to test, no editor support.
- **`define_method`** to generate per-category display methods — same reasons; a Hash already models the grouped data cleanly.

## Development

```sh
git clone https://github.com/s33dco/banco
cd banco
bundle install
bundle exec rake   # runs specs + RuboCop
```

CI runs the full suite against Ruby 3.2, 3.3, and 3.4 on every push.

## Licence

MIT — see [LICENSE](LICENSE).

Hope your numbers are positive!
