# Scenario list

Each scenario is one CDS view or one query on the table `zvkrap01_dt_demo`. IDs are the same as in `UML_and_Scenarios.pptx`.

**Source column.** `SAP` means the function and its syntax were found in SAP documentation or in SAP's own sample code. `Check` means they were not confirmed. Test those in ADT. See [VALIDATION.md](VALIDATION.md).

## String functions and expressions

| ID | Scenario | CDS feature shown | Columns used | Rows must show | Source |
|---|---|---|---|---|---|
| 01 | Trim blanks | `ltrim( t_char30, ' ' ), rtrim( t_char30, ' ' )` | t_char30, t_sstr | Leading, trailing, both, none | SAP |
| 02 | Trim a given character | `ltrim( t_char10, '0' ), rtrim( t_char10, 'X' )` | t_char10 | Leading zeros, trailing X | SAP |
| 03 | Pad to a length | `lpad( t_char10, 12, '#' ), rpad( ... )` | t_char10, t_numc4 | Shorter and longer than the length | SAP |
| 04 | Upper and lower case | `upper( t_char30 ), lower( t_char30 )` | t_char30 | Mixed case, one with umlauts | SAP |
| 05 | Combine text, numbers and codes | `concat( a, b ), concat_with_space( a, b, 1 )` | t_char30, t_numc6, t_sstr | Character, numc and sstring together | SAP |
| 06 | Cut out part of a text | `left, right, substring( t_char30, 4, 3 )` | t_char30 | Positions inside the text | SAP |
| 07 | Find and measure | `instr( t_char30, '@' ), length( t_char30 )` | t_char30 | Text with and without @ | SAP |
| 08 | Replace | `replace( t_char30, '-', '' )` | t_char30 | Spaces, hyphens, plus sign, brackets | SAP |
| 09 | Replace by pattern | `replace_regexpr( PCRE => '\d', VALUE => t_sstr, WITH => '#' )` | t_sstr | Letters, digits and symbols mixed | SAP |
| 10 | string versus sstring | `Restrictions of string in CDS` | t_str, t_sstr | One long text | Check |

## Arithmetic expressions

| ID | Scenario | CDS feature shown | Columns used | Rows must show | Source |
|---|---|---|---|---|---|
| 11 | Integer arithmetic | `+  -  *` | t_int1, t_int2, t_int4, t_int8 | Positive and negative values | SAP |
| 12 | Mixed types | `int and dec in one expression` | t_int4, t_dec, t_dec2 | Result type and precision | Check |
| 13 | Division with the / operator | `/` | t_dec, t_dec2 | Results with repeating decimals | SAP |
| 14 | Percentage of a value | `cast( a / b * 100 as abap.dec(10,2) )` | t_dec, t_dec2 | Percentages 0 to 100 | SAP |
| 15 | Amount times quantity | `Arithmetic after cast to dec` | t_curr, t_quan | Typical amounts and quantities | Check |
| 16 | Amount as decfloat | `curr_to_decfloat_amount, get_numeric_value` | t_curr, t_cuky | Amounts of different size | Check |

## Mathematical: float and decimal precision

| ID | Scenario | CDS feature shown | Columns used | Rows must show | Source |
|---|---|---|---|---|---|
| 17 | Float to decimal | `fltp_to_dec( t_fltp as abap.dec(15,3) )` | t_fltp | Large and small values | SAP |
| 18 | decfloat arithmetic | `decfloat16 against decfloat34` | t_df16, t_df34 | Values with many digits | Check |
| 19 | The same value in three types | `Compare dec, decfloat and fltp` | t_dec, t_df34, t_fltp | 0.1 and 1/3 | Check |

## Numeric functions

| ID | Scenario | CDS feature shown | Columns used | Rows must show | Source |
|---|---|---|---|---|---|
| 20 | Absolute value | `abs( t_int4 )` | t_int4, t_dec | Positive and negative | SAP |
| 21 | Round up and down | `ceil( t_df34 ), floor( t_df34 )` | t_df34, t_dec | Values at .5, negative values | SAP |
| 22 | Round to decimals | `round( t_df34, 2 )` | t_df34, t_dec | Halves, negative values | SAP |
| 23 | Integer division and remainder | `div( t_int4, t_int2 ), mod( ... )` | t_int4, t_int2 | Negative values, remainder zero | SAP |
| 24 | Division with decimals | `division( t_dec, t_dec2, 2 )` | t_dec, t_dec2 | Different numbers of decimals | SAP |

## Conditions

| ID | Scenario | CDS feature shown | Columns used | Rows must show | Source |
|---|---|---|---|---|---|
| 25 | Simple CASE | `case t_char1 when 'A' then ... else ... end` | t_char1 | Every branch and the ELSE | SAP |
| 26 | Searched CASE | `case when t_int4 <= 10 then ... end` | t_int4, t_dec | Every range and the ELSE | SAP |
| 27 | CASE without ELSE | `No ELSE returns the null value; ELSE NULL` | t_char1 | A value that matches no branch | SAP |
| 28 | Filter by pattern and range | `BETWEEN, LIKE, IS INITIAL, IS NULL` | t_int4, t_char30, t_dats | Common prefixes, initial values | SAP |

## Date and time

| ID | Scenario | CDS feature shown | Columns used | Rows must show | Source |
|---|---|---|---|---|---|
| 29 | Validity of a date | `dats_is_valid( t_dats )` | t_dats | 00010101 valid, 00000000 invalid, initial | SAP |
| 30 | Validity of a time | `tims_is_valid( t_tims )` | t_tims | Valid, impossible, initial | Check |
| 31 | Days between two dates | `dats_days_between( t_dats, $session.system_date )` | t_dats | Later, earlier, same day, invalid date | SAP |
| 32 | Add days and months | `dats_add_days( t_dats, 7, 'INITIAL' ), dats_add_months( ... )` | t_dats | 31 January, leap day, year end | SAP |
| 33 | Days between on DATN | `datn_days_between( dats_to_datn( ... ), ... )` | t_dats, t_datn | Same cases as above | SAP |
| 34 | Add days on DATN | `datn_add_days( t_datn, 7, ... )` | t_datn | Same cases as above | Check |
| 35 | Timestamp to date and time | `tstmp_to_dats( t_tstmp, t_tzone, 'NULL' ), tstmp_to_tims` | t_tstmp, t_tzone | Different time zones | SAP |
| 36 | Seconds between, add seconds | `tstmp_seconds_between, tstmp_add_seconds` | t_tstmp | Two moments apart | Check |
| 37 | UTC long: now and add seconds | `utcl_current( ), utcl_add_seconds( t_utc, 60 )` | t_utc | A value and the value a minute later | SAP |
| 38 | UTC long: seconds between | `utcl_seconds_between( t_utc, ... )` | t_utc | Two moments apart | Check |
| 39 | Combine date and time | `dats_tims_to_tstmp( t_dats, t_tims, ... )` | t_dats, t_tims, t_tzone | Same date, different zones | Check |
| 40 | Posting period from a date | `cast dats to char, left, cast to accp` | t_dats, t_accp | Month end, year end | Check |

## Conversion

| ID | Scenario | CDS feature shown | Columns used | Rows must show | Source |
|---|---|---|---|---|---|
| 41 | Quantity in another unit | `unit_conversion( quantity =>, source_unit =>, target_unit => )` | t_quan, t_unit | g, kg and one unit of another kind | Check |
| 42 | Amount in another currency | `currency_conversion( amount =>, source_currency =>, target_currency =>, exchange_rate_date => )` | t_curr, t_cuky, t_dats | EUR, USD, JPY; rates must exist | Check |

## Aggregates

| ID | Scenario | CDS feature shown | Columns used | Rows must show | Source |
|---|---|---|---|---|---|
| 43 | Totals per group | `sum( t_curr ) with GROUP BY` | t_char5, t_curr, t_cuky | Several rows per group, one currency | SAP |
| 44 | Statistics per group | `avg( t_dec as abap.dec(15,2) ), min, max, count( * )` | t_char5, t_dec, t_dats | Groups of different size | SAP |
| 45 | Distinct values and HAVING | `count( distinct t_char3 ), HAVING` | t_char5, t_char3 | Repeated sub-groups | SAP |
| 46 | Aggregate over numeric text | `sum( cast( t_numc4 as abap.int4 ) )` | t_char5, t_numc4 | Leading zeros, one large value | SAP |

## Literals, parameters, session

| ID | Scenario | CDS feature shown | Columns used | Rows must show | Source |
|---|---|---|---|---|---|
| 47 | Literals, parameters, session variables | `abap.int4'12345', $parameters.p, $session.system_date` | none | Any row | SAP |

## Casting: one of each matrix code

| ID | Scenario | CDS feature shown | Columns used | Rows must show | Source |
|---|---|---|---|---|---|
| 48 | Integer to a larger integer | `[x] cast int to int8` | t_int4 | Negative, zero, large value | SAP |
| 49 | Decimal to decimal and float | `[x] cast dec to dec, fltp` | t_dec | Many decimals, negative values | SAP |
| 50 | Numeric text to a number | `[x] cast numc to dec, fltp` | t_numc14 | 14-digit timestamp, all zeros | SAP |
| 51 | Text to shorter text and sstring | `[x] cast char to char, sstring` | t_char30 | Text longer than the target | SAP |
| 52 | Text to date | `[y] cast char to dats` | t_char8 | Valid, impossible, blank | SAP |
| 53 | Text to time | `[y] cast char to tims` | t_char6 | Valid, impossible, blank | SAP |
| 54 | Text to numeric text | `[y] cast char to numc` | t_char10 | Digits, digits with blanks, letters | SAP |
| 55 | Text to language, unit, currency | `[y] cast char to lang, unit, cuky` | t_char1, t_char3, t_char5 | E, KG, EUR | SAP |
| 56 | Numbers to text | `[y] cast int, dec to char` | t_int4, t_dec | Negative, zero, many decimals | SAP |
| 57 | Numeric text to integers | `[y] cast numc to int, int8` | t_numc10 | Leading zeros, one large value | SAP |
| 58 | Date and time to text | `[y] cast dats, tims to char` | t_dats, t_tims | Normal and initial values | SAP |
| 59 | Numeric text to date | `[z] cast numc to dats` | t_numc8 | Valid, 00000000, impossible | SAP |
| 60 | Numeric text to time | `[z] cast numc to tims` | t_numc6 | Valid, 000000, impossible | SAP |
| 61 | Numeric text to shorter numeric text | `[z] cast numc to numc` | t_numc10 | Value longer than the target | SAP |
| 62 | Posting period to text | `[z] cast accp to char, numc` | t_accp | 202610, initial | SAP |
| 63 | Language, unit, currency to text | `[d] cast lang, unit, cuky to char` | t_lang, t_unit, t_cuky | E, KG, EUR | SAP |
| 64 | Text to posting period | `[p] cast char to accp` | t_char6 | 202610, 000000, invalid month | SAP |
| 65 | Numeric text to posting period | `[p] cast numc to accp` | t_numc6 | 202610, 000000, invalid month | SAP |
| 66 | Same type to same type | `[p] cast raw to raw, lang to lang` | t_raw, t_lang | Any value | SAP |
| 67 | Combinations marked [-] | `cast char to dec, int to numc` | t_char10, t_int4 | Syntax error shown in ADT | SAP |

## Set operations and relations

| ID | Scenario | CDS feature shown | Columns used | Rows must show | Source |
|---|---|---|---|---|---|
| 68 | UNION ALL of two selections | `UNION ALL` | t_char5, t_char1 | Rows that match both selections | Check |
| 69 | UNION of two selections | `UNION` | t_char5, t_char1 | Same rows, duplicates removed | SAP |
| 70 | Inner self join | `INNER JOIN of the table with itself` | rec_id, t_char3 | Rows paired by the same code | SAP |
| 71 | Left outer self join with coalesce | `LEFT OUTER JOIN, coalesce( ..., 'N' )` | rec_id, t_int4 | Rows with and without a match | SAP |
| 72 | Right outer and cross join | `RIGHT OUTER JOIN, CROSS JOIN` | rec_id, t_char3 | Small sets of rows | SAP |
| 73 | Association to the table itself | `association [0..1] to ... as _ref` | rec_id, t_int4 | Rows that point to an existing row | SAP |
| 74 | Rows of one group only | `Input parameter, $parameters.p` | t_char5 | At least three groups | SAP |

## Summary

| | Count |
|---|---|
| Scenarios | 74 |
| Source SAP | 59 |
| Source Check | 15 |
