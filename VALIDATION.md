# Validation against SAP sources

Checked on 11 October 2026. Many pages under help.sap.com could not be opened with the tools used, so some items are marked **Check**.

## What was confirmed

| Area | Source | Result |
|---|---|---|
| String functions | [ABAP keyword documentation 7.52, string functions](https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-US/abensql_functions_string.htm); SAP ABAP cheat sheet sample | All 14 functions. `replace_regexpr` only in the sample |
| Numeric functions | SAP ABAP cheat sheet sample (CDS view entity) | `abs`, `ceil`, `floor`, `div`, `mod`, `division`, `round` with arguments |
| Date functions | [ABAP keyword documentation 7.52, CDS date functions](https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-US/abencds_f1_date_functions.htm) | `dats_is_valid`, `dats_days_between`, `dats_add_days`, `dats_add_months` |
| Timestamp functions | [ABAP SQL timestamp functions](https://help.sap.com/doc/abapdocu_latest_index_htm/latest/en-US/abensql_timestamp_func.htm); [SAP Community blog, release 7.51](https://blogs.sap.com/2016/11/04/abap-news-for-release-7.51-date-and-time-in-abap-cds-and-open-sql/) | `utcl_*` and `tstmp_*` for ABAP SQL; `tstmp_to_dats`, `tstmp_to_tims` in CDS |
| View entity features | [SAP Community blog](https://blogs.sap.com/2022/05/06/cds-view-entities-are-feature-complete-part-l-new-features/) | `replace_regexpr` from 7.81, typed literals, `curr_to_decfloat_amount`, `get_numeric_value` |
| Cast matrix | [ABAP keyword documentation 7.51, CDS cast](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abencds_f1_cast_expression.htm); [7.53, ABAP SQL cast](https://help.sap.com/doc/abapdocu_753_index_htm/7.53/en-US/abensql_cast.htm) | Matrix confirmed. The legend for x, y, z, d, p was not retrievable |
| Joins, aggregates, CASE, associations, unit conversion | SAP ABAP cheat sheet samples (CDS view entities) | Confirmed with syntax |

## Corrections made during validation

- `ltrim` and `rtrim` need a character argument and also remove trailing blanks.
- `&&` was removed; it was not found in the sources.
- `dats_add_days` and `dats_add_months` need an `on_error` literal.
- `fltp_to_dec` needs a target type.
- `unit_conversion` needs `source_unit`.
- `round` and `division` need a decimals argument.
- `datn_days_between` takes DATN values; use `dats_to_datn` to convert.

## Still to confirm in ADT

- Functions marked Check: `tims_is_valid`, `datn_add_days`, `tstmp_seconds_between` and `tstmp_add_seconds` in CDS, `utcl_seconds_between` in CDS, the `dats_tims_to_tstmp` signature, the `currency_conversion` syntax, `curr_to_decfloat_amount`, `get_numeric_value`, `UNION ALL`, restrictions of `string`.
- Cast matrix: the ABAP SQL matrix (7.53) shows DEC to INT as allowed; the CDS matrix (7.51) does not. Test every cast.
- Which column types each function accepts, and behaviour for negative values, division by zero and NULL.
- Whether the column types `int1`, `int2`, `int8`, `decfloat16/34`, `fltp`, `lang`, `quan`, `unit`, `raw` and `accp` activate in ABAP Cloud.
