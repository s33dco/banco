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

Banco prompts for the filename, reads the data, then presents an interactive menu:

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

## CSV format

Banco expects a CSV file with **no header row** and columns in this order:

| Column | Content |
|--------|---------|
| 1 | Date |
| 2 | Description |
| 3 | Type |
| 4 | Money in |
| 5 | Money out |

Any columns beyond the fifth are ignored.

If your export includes a header row, pass `skip_header: true` when constructing `Banco::Reader` programmatically, or edit the file to remove the header before running the CLI.

## How it works

`Reporter` groups similar transactions by the first `GROUPING_PREFIX_LENGTH` characters (default 9) of the description, totalling incoming and outgoing amounts separately. The bottom-line report shows the net surplus or deficit for the period.

## Development

```sh
git clone https://github.com/s33dco/banco
cd banco
bundle install
bundle exec rake spec
```

## Licence

MIT — see [LICENSE](LICENSE).

Hope your numbers are positive!
