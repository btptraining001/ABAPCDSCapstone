# Demo data

The class `zcl_vkrap01_dt_demo_data` loads 74 rows. Every group has two or more rows with different values, so one function can be shown with several results.

![Data load flow](diagrams/data_load_flow.png)

## Row groups

| Tag | rec_id | Rows | Purpose | Main columns |
|---|---|---|---|---|
| STR | 101-118 | 18 | String functions: trim, pad, case, concat, cut, find, replace, regex | `t_char30`, `t_sstr`, `t_char10`, `t_numc4`, `t_numc6`, `t_str` |
| ARI | 201-208 | 8 | Arithmetic, numeric functions, percentages | `t_int1`..`t_int8`, `t_dec`, `t_dec2`, `t_df34`, `t_fltp`, `t_curr`, `t_quan` |
| MAT | 301-303 | 3 | Float and decimal precision | `t_df16`, `t_df34`, `t_dec`, `t_fltp` |
| CND | 401-405 | 5 | CASE, BETWEEN, LIKE, IS INITIAL | `t_char1`, `t_int4`, `t_dec`, `t_char30`, `t_dats` |
| DAT | 501-509, 510 | 10 | Date, time, timestamp, posting period | `t_dats`, `t_datn`, `t_tims`, `t_timn`, `t_tstmp`, `t_tzone`, `t_utc`, `t_accp` |
| AGG | 601-609 | 9 | Aggregates, conversion, union | `t_char5`, `t_char1`, `t_char3`, `t_curr`, `t_cuky`, `t_quan`, `t_unit` |
| CST | 701-714 | 14 | Casting | `t_char*`, `t_numc*`, `t_int4`, `t_dec`, `t_accp`, `t_lang`, `t_unit`, `t_cuky` |
| JON | 801-806 | 6 | Self join and association | `t_char3`, `t_int4` |
| ALL | 901 | 1 | One row with every column filled | all |

Filter one group in a CDS view with `WHERE case_desc LIKE 'STR%'`.

## Design rules

- **Groups for aggregates.** `t_char5` holds EUR (4 rows), USD (3 rows) and JPY (2 rows). `t_cuky` always equals the group, so `sum( t_curr )` can be grouped by `t_char5` and `t_cuky`.
- **Overlap for union.** `t_char1` (status A or B) overlaps with the group, so a union of status A and group EUR shows duplicates.
- **Self join.** `t_int4` of rows 801-806 holds the `rec_id` of a parent row. Row 805 points to 999, which does not exist. Other groups keep `t_int4` below 101 or above 1000, so they never match a `rec_id` by accident.
- **No zero divisor.** No row has a zero divisor, because the behaviour for division by zero is not verified.
- **Impossible values.** Impossible dates in text columns (`t_char8`, `t_numc8`) are in the casting rows. Impossible values in real date, time and period columns are in row 510, which is loaded separately.
- **Risky rows.** Rows 510 and 901 are loaded one by one inside TRY. If one is rejected the console shows the reason and the load continues.

## Run it

![Sequence](diagrams/data_load_sequence.png)

1. Activate the table and the class.
2. Run the class with F9 (Run as ABAP Application, Console).
3. Open the table with F8 and expect 74 rows.

Every run deletes all rows of the table in the current client and loads them again.

## Not verified

- The class has not been compiled. Likely trouble spots: `utclong_add`, `cl_abap_context_info=>get_system_date( )`, the conversion of `t_raw`, and impossible values in date columns.
- The implicit commit at the end of a class run is assumed. There is no COMMIT WORK in the class.
