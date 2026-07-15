# Skills

This repository contains a collection of skill folders. Each skill folder holds a SKILL.md file that describes how to use that skill when the user requests a task that involves a specific file format or domain.

## How to use a skill

1. Identify the relevant skill: look at the task description and pick the skill folder that matches that domain.
2. Read the skill's SKILL.md: each skill folder has a SKILL.md that contains step-by-step instructions, required tool calls, and any formatting rules. You must read that file before executing any file-related commands.
3. Follow the instructions: the skill file may specify which tools to call, how many times, and in what order. It may also prescribe how to verify the output or how to incorporate user feedback.
4. Return a completion: once the skill's steps are finished, provide the user with a concise answer and, if appropriate, a reference to the skill that was used.

Examples:

- User: Can you create a dashboard for sales data? -> Use frontend-design
- User: Create a PDF contract -> Use pdf
- User: Build a Slack bot integration -> Use app-builder

If the assistant is unsure which skill to use, it may ask the user for clarification, but it should always read the relevant SKILL.md before performing the task.

## List of skills in this repository

- app-builder: Builds complete web applications with frontend, backend, and database layers. Use when users request a full-stack application, web app, SaaS prototype, or CRUD app with persistent data storage. Triggers: build a web app, create an application, full-stack, backend and frontend, web application with database
- deep-research: Conducts deep, thorough research on topics including medicine, technology, art, and history. Use when users ask to research, investigate, perform analysis, or provide a deep dive on a specific topic with multiple credible sources. Triggers: research, investigate, deep dive, perform an analysis, thorough investigation, look into deeply
- docx: Creates, edits, and analyzes professional documents with support for tracked changes, comments, formatting preservation, and text extraction. Use when users need to work with .docx files for creating, modifying, or analyzing document content. Triggers: word document, docx file, create a document, edit the contract, document formatting, tracked changes, add comments to document
- frontend-design: Creates distinctive, production-grade frontend interfaces with high design quality. Use when users ask to build web components, pages, posters, or applications including websites, landing pages, dashboards, React components, or HTML/CSS layouts. Triggers: create a website, build a landing page, design a dashboard, React component, HTML CSS layout, web UI design, frontend interface
- mcp-builder: Guides creation of high-quality MCP servers enabling LLMs to interact with external services. Use when building MCP servers to integrate external APIs or services in Python FastMCP or Node TypeScript MCP SDK. Triggers: create an MCP server, Model Context Protocol, integrate API, connect external service, build MCP tools
- pdf: Provides comprehensive PDF manipulation for extracting text and tables, creating new PDFs, merging/splitting documents, and handling forms. Use when users need to fill, generate, process, or analyze PDF documents. Triggers: PDF form, extract text from PDF, merge PDFs, split PDF, create a PDF document, PDF at scale
- pptx: Creates, edits, and analyzes presentations with support for layouts, comments, and speaker notes. Use when users need to work with .pptx files for creating, modifying, organizing slides, or adding presenter materials. Triggers: powerpoint presentation, create a deck, slide presentation, pptx file, speaker notes, slide layout
- skill-creator: Creates new skills, modifies existing skills, and measures skill performance with evals and benchmarks. Use when users want to build a skill from scratch, optimize an existing skill, run evaluations, or improve triggering accuracy. Triggers: create a new skill, build a skill, evaluate a skill, improve skill performance, optimize skill description, benchmark skill
- xlsx: Creates, edits, and analyzes spreadsheets with support for formulas, formatting, data analysis, and visualization. Use when users need to work with .xlsx, .xlsm, .csv, or .tsv files for creating spreadsheets, reading data, or recalculating formulas. Triggers: excel spreadsheet, create a spreadsheet, analyze data table, csv file, recalculate formulas, data visualization in spreadsheet

This list is only for reference; the assistant should always consult the SKILL.md files for detailed guidance.
