---
name: lint-markdown
description: Lint markdown files using pymarkdownlnt. Provides linting output, severity levels, and quick‑fix suggestions.
---

# Lint Markdown

A skill for finding lint in Markdown and fixing them, if possible.

Use this skill when the user requests any of these actions related to Markdown files:
- "lint this markdown" / "check markdown formatting"
- "find issues in [file]" / "scan for errors"
- "validate markdown" / "run linter"
- "fix markdown style" / "auto-correct markdown"
- "check README compliance" / "verify formatting rules"

Also use this skill when creating or editing Markdown files.

DO NOT use this skill for:
- Questions about what Markdown syntax is

## Overview

This skill scans `*.md` and `*.mdx` files and runs `pymarkdownlnt` against them. It works in two phases:

1. Autofix: run `pymarkdownlnt`'s fixer to automatically fix issues.
2. Lint: run `pymarkdownlnt` and parse its JSON report.
3. Fix: attempt to fix issues.
4. Iterate: Repeat steps 1, 2, and 3 until easy fixes are not available.
5. Report: display a human‑friendly summary of issues.

If `pymarkdownlnt` is not installed, the skill will guide you through installation steps.

## Workflow

### Step 1: Autofix

Run the `pymarkdownlnt` auto-fixer.

```sh
pymarkdownlnt fix --recurse <directory>
```

`<directory>` is the directory with the Markdown files to scan.

### Step 2: Lint

Run the `pymarkdownlnt` scanner to find issues to resolve. These are issues the auto-fixer from step 1 could not fix.

```sh
pymarkdownlnt scan --recurse <directory>
```

`<directory>` is the directory with the Markdown files to scan.

### Step 3: Fix

Analyze the scan findings and fix the specified issues.

### Step 4: Iterate

Repeat steps 1, 2, and 3 until:

- There are no issues; OR
- There are no easy fixes remaining

### Step 5: Report

If there are no issues remaining:

- Report "No issues found by `pymarkdownlnt`".

If there are issues:

- Report the issues the user must resolve.

## Installation

If `pymarkdownlnt` is missing, install the `pymarkdownlnt` package.

Use the skill after installing pymarkdownlnt.

