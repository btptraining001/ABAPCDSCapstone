# Data model

One table: `zvkrap01_dt_demo`, client-dependent, 41 columns. The definition is in `src/tables/zvkrap01_dt_demo.tabl.txt`.

![ER diagram](diagrams/table_er.png)

The UML class diagram is in [UML_and_Scenarios.pptx](UML_and_Scenarios.pptx) and as an image:

![UML class diagram](diagrams/uml_data_type_table.png)

## Column dictionary

### Keys

| Column | Type | Used for |
|---|---|---|
| `client` | clnt | Client, key. Filled by the system. |
| `rec_id` | int4 | Row number, key. The first digit shows the group (1 string, 2-3 arithmetic, 4 conditions, 5 date, 6 aggregates, 7 casting, 8 joins, 9 full row). |
| `case_desc` | char(60) | Starts with a tag (STR, ARI, MAT, CND, DAT, AGG, CST, JON, ALL) and says what the row shows. Use it in WHERE. |

### Integers and decimals

| Column | Type | Used for |
|---|---|---|
| `t_int1` | int1 | Smallest integer (0 to 255). |
| `t_int2` | int2 | Divisor for div and mod. |
| `t_int4` | int4 | Dividend, CASE ranges, and the pointer to a parent rec_id in the self join rows. |
| `t_int8` | int8 | Values larger than int4. |
| `t_dec` | dec(15,3) | Decimal arithmetic, rounding, aggregates. |
| `t_dec2` | dec(9,2) | Divisor and percentage base. |
| `t_df16` | decfloat16 | Decimal floating point, 16 digits. |
| `t_df34` | decfloat34 | Decimal floating point, 34 digits; ceil, floor, round. |
| `t_fltp` | fltp | Binary floating point; fltp_to_dec. |

### Characters

| Column | Type | Used for |
|---|---|---|
| `t_char1` | char(1) | Status A, B, C, X; cast to language. |
| `t_char3` | char(3) | Sub-group and unit code; cast to unit. |
| `t_char5` | char(5) | Group EUR, USD, JPY; cast to currency key. |
| `t_char6` | char(6) | Time as text; posting period as text. |
| `t_char8` | char(8) | Date as text. |
| `t_char10` | char(10) | Trim, pad, number as text. |
| `t_char30` | char(30) | Main text for string functions. |
| `t_sstr` | sstring(60) | Short string; regex replace. |
| `t_str` | string | Unlimited string. |

### Numeric text

| Column | Type | Used for |
|---|---|---|
| `t_numc4` | numc(4) | Pad and sum with cast. |
| `t_numc6` | numc(6) | Time as numeric text; posting period. |
| `t_numc8` | numc(8) | Date as numeric text. |
| `t_numc10` | numc(10) | Number as numeric text. |
| `t_numc14` | numc(14) | Timestamp as numeric text. |

### Date and time

| Column | Type | Used for |
|---|---|---|
| `t_dats` | dats | Date, old generation. |
| `t_datn` | datn | Date, new generation. |
| `t_tims` | tims | Time, old generation. |
| `t_timn` | timn | Time, new generation. |
| `t_utc` | utclong | UTC long timestamp. |
| `t_tstmp` | dec(15,0) | Short timestamp YYYYMMDDHHMMSS. |
| `t_tstmpl` | dec(21,7) | Long timestamp. |
| `t_tzone` | char(6) | Time zone for the short timestamp. |
| `t_accp` | accp | Posting period YYYYMM. |

### Special types

| Column | Type | Used for |
|---|---|---|
| `t_lang` | lang | Language key. |
| `t_cuky` | cuky | Currency key for t_curr. |
| `t_curr` | curr(9,2) | Amount; needs t_cuky. |
| `t_unit` | unit(3) | Unit of measure for t_quan. |
| `t_quan` | quan(9,3) | Quantity; needs t_unit. |
| `t_raw` | raw(8) | Byte string. |

## Columns that belong together

| Pair | Purpose |
|---|---|
| `t_char8` and `t_numc8` | Date as text and as numeric text, for the cast to a date |
| `t_char6` and `t_numc6` | Time as text and as numeric text, for the cast to a time |
| `t_char10` and `t_numc10` | Number as text and as numeric text, for the cast to a number |
| `t_cuky` and `t_curr` | Currency key and amount (annotation `@Semantics.amount.currencyCode`) |
| `t_unit` and `t_quan` | Unit and quantity (annotation `@Semantics.quantity.unitOfMeasure`) |
| `t_dats` and `t_datn` | Date, old and new generation |
| `t_tims` and `t_timn` | Time, old and new generation |

## Not verified

- `int1`, `int2`, `int8`, `decfloat16`, `decfloat34`, `fltp`, `lang`, `quan`, `unit`, `raw` and `accp` are not in SAP's ABAP Cloud cheat sheet. Confirm that the table activates in your system.
