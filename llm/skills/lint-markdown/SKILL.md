---
name: lint-markdown
description: Lint markdown files using pymarkdownlnt. Triggered automatically when a Markdown file is edited or saved. Provides linting output, severity levels, and quick‑fix suggestions.
---

## Overview

This skill watches for changes to any `*.md` file and runs `pymarkdownlnt` against it. It works in two phases:

1. **Lint** – run `pymarkdownlnt` and parse its JSON report.
2. **Report** – display a human‑friendly summary and offer optional auto‑fixes.

If `pymarkdownlnt` is not installed, the skill will guide you through installation steps.

## When to Use

- After editing a markdown document (README, docs, notes).
- Before committing markdown to a repository.

## How It Works

```sh
# Run in the background (the skill handles this internally)
pymarkdownlnt scan --format json <directory>
```

The JSON output is parsed to list each violation: line, column, severity (info, warning, error), rule id, and message. The skill then prints a concise table.

### Sample Report

| Line | Col | Severity | Rule | Message |
|------|-----|----------|------|---------|
| 42   | 5   | error    | MD041 | Headings should be surrounded by a single blank line |
| 87   | 1   | warning  | MD036 | Emphasis should be used instead of asterisks |

If no violations are found, the skill reports:
```
No lint issues found in <directory>.
```

## Auto‑Fix Suggestions

`pymarkdownlnt` provides auto-fix capabilities for some violations.

```sh
pymarkdownlnt fix <directory>
```

After running the fix command, scan again and apply additional fixes for the violations that remain.

For simple rules the skill can automatically apply a quick fix. For example, if a rule reports `MD029: List item prefix must be followed by a space`, the skill will replace `-item` with `- item`.

When a complex rule is detected, the skill will simply provide the message and line number, leaving the manual fix to the user.

## Installation

If `pymarkdownlnt` is missing the skill will output instructions:

1. **Using pip**
   ```bash
   pip install pymarkdownlnt
   ```
2. **Using conda**
   ```bash
   conda install -c conda-forge pymarkdownlnt
   ```
3. **From source**
   ```bash
   git clone https://github.com/tyler-sullivan/pymarkdownlnt
   cd pymarkdownlnt
   python -m pip install .
   ```

The skill will automatically retry the lint after installation.

## Custom Configuration

Create a `.pymarkdownlnt.toml` in the repository root to customize rules. Example:

```toml
[default]
style = "GitHub"
max_line_length = 120
ignore = ["MD003"]
```

Place the file in the same directory as your markdown or at the project root. The skill will detect it automatically.

## Troubleshooting

- **`pymarkdownlnt: command not found`** – ensure the interpreter’s `bin` directory is in your `PATH`.
- **Permission denied** – run the install with `--user` or use a virtual environment.
- **Large files** – the skill may time out; increase the timeout with the `--timeout` flag if supported.

## Summary

1. Edit markdown.
2. Skill runs `pymarkdownlnt`.
3. It outputs a clear report and optional auto‑fixes.
4. If the tool is missing, it guides you to install it.

Happy linting!
