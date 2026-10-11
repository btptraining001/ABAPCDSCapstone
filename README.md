# CDS code (planned for v2)

One folder per scenario group, named like the tags in the demo data:

| Folder | Tag | Content |
|---|---|---|
| `string` | STR | String functions and expressions |
| `arithmetic` | ARI, MAT | Arithmetic, numeric and mathematical functions |
| `conditions` | CND | CASE, BETWEEN, LIKE, IS INITIAL |
| `datetime` | DAT | Date, time and timestamp functions |
| `conversion` | AGG | Unit and currency conversion |
| `aggregates` | AGG | Aggregate expressions, GROUP BY, HAVING |
| `casting` | CST | Casts, one per cast matrix code |
| `relations` | JON, AGG | Self join, association, UNION, UNION ALL |

Each view entity gets a comment block that names the scenario ID from `docs/UML_and_Scenarios.pptx`.
