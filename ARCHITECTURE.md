# Architecture

The project is small: one table, one class that fills it, and CDS view entities (version 2) that read it.

## Overview

![Architecture](diagrams/architecture.png)

## Repository structure

![Repository structure](diagrams/repo_structure.png)

## Scenario groups

Seventy-four scenarios on one table. The full list is in [SCENARIOS.md](SCENARIOS.md).

<img src="diagrams/scenario_map.png" alt="Scenario map" width="420">

## Roadmap

![Roadmap](diagrams/roadmap.png)

| Version | Content | State |
|---|---|---|
| v1.0 | Table, data class, documentation, diagrams, scenario list | this version |
| v2.0 | CDS view entities for each scenario group | planned |

## Naming

- Prefix `zvkrap01_`.
- Interface views `_i_` or `_ri_`, projection views `_c_` or `_rc_`.
- Table names stay within 16 characters.

## Diagram sources

The Mermaid sources of all diagrams are in `docs/diagrams/source`. Edit a `.mmd` file and render it again with the Mermaid CLI, or paste it into a Mermaid code block in a Markdown file.
