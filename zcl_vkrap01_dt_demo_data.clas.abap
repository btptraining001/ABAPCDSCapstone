"! <p class="shorttext synchronized">Demo data for the CDS capstone</p>
"! Fills table ZVKRAP01_DT_DEMO with 74 rows. The rows are designed so that every CDS scenario of the capstone
"! (string functions, arithmetic, numeric and mathematical functions, conditions, date and time, conversion,
"! aggregates, casting, union and self join) has two or three rows with different values.
"!
"! How to run: activate the class, then choose Run As / ABAP Application (Console) in ADT.
"!
"! Row groups (the first word of CASE_DESC is the tag, rec_id is the range):
"!   STR 101-118  string functions        ARI 201-208 / MAT 301-303  arithmetic, numeric, mathematical
"!   CND 401-405  conditions              DAT 501-510  date and time (510 is loaded separately)
"!   AGG 601-609  aggregates and union    CST 701-714  casting
"!   JON 801-806  self join, association  ALL 901      one row with every column filled
"!
"! Note: every run deletes ALL rows of the table in the current client and loads them again.
CLASS zcl_vkrap01_dt_demo_data DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    " Makes the class executable in ADT (F9). Only the main method is needed.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    " One table line has the structure of the demo table; the helper methods below return such lines.
    TYPES ty_rows TYPE STANDARD TABLE OF zvkrap01_dt_demo WITH DEFAULT KEY.

    " One method per scenario group. Each one returns the rows of its group.
    METHODS rows_string RETURNING VALUE(r) TYPE ty_rows.
    METHODS rows_arith RETURNING VALUE(r) TYPE ty_rows.
    METHODS rows_cond RETURNING VALUE(r) TYPE ty_rows.
    METHODS rows_date RETURNING VALUE(r) TYPE ty_rows.
    METHODS rows_agg RETURNING VALUE(r) TYPE ty_rows.
    METHODS rows_cast RETURNING VALUE(r) TYPE ty_rows.
    METHODS rows_join RETURNING VALUE(r) TYPE ty_rows.
    METHODS rows_risky RETURNING VALUE(r) TYPE ty_rows.
    " rows_risky returns rows that the database or a type conversion may reject (loaded one by one).
ENDCLASS.


CLASS zcl_vkrap01_dt_demo_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    " Fills zvkrap01_dt_demo with demo data for the CDS capstone.
    " Step 1: collect the rows of all groups in one internal table.
    " Step 2: delete the old rows, so the class can be run again and again.
    " Step 3: write the collected rows with MODIFY (insert new rows, update rows with the same rec_id).
    " Step 4: load the risky rows one by one and report the ones that are rejected.

    " All normal rows of all groups
    DATA lt_all TYPE ty_rows.

    " Group: string functions (STR)
    APPEND LINES OF rows_string( ) TO lt_all.
    " Group: arithmetic, numeric and mathematical functions (ARI, MAT)
    APPEND LINES OF rows_arith( ) TO lt_all.
    " Group: conditions (CND)
    APPEND LINES OF rows_cond( ) TO lt_all.
    " Group: date and time (DAT)
    APPEND LINES OF rows_date( ) TO lt_all.
    " Group: aggregates, conversion and union (AGG)
    APPEND LINES OF rows_agg( ) TO lt_all.
    " Group: casting (CST)
    APPEND LINES OF rows_cast( ) TO lt_all.
    " Group: self join and association (JON)
    APPEND LINES OF rows_join( ) TO lt_all.

    " Delete the old demo rows (only the current client is affected).
    DELETE FROM zvkrap01_dt_demo.

    " Write all normal rows in one step. MODIFY inserts a row, or updates it when the key already exists.
    MODIFY zvkrap01_dt_demo FROM TABLE @lt_all.
    out->write( |Rows loaded in one step: { lines( lt_all ) }| ).

    " Rows with impossible values or a raw field: one MODIFY per row.
    " The TRY block catches a rejected row, prints the reason and continues with the next row.
    LOOP AT rows_risky( ) INTO DATA(ls_risky).
      TRY.
          MODIFY zvkrap01_dt_demo FROM @ls_risky.
          out->write( |Row { ls_risky-rec_id } loaded| ).
        CATCH cx_root INTO DATA(lx).
          out->write( |Row { ls_risky-rec_id } rejected: { lx->get_text( ) }| ).
      ENDTRY.
    ENDLOOP.

    " Final check: read the number of rows from the database and print it.
    SELECT COUNT(*) FROM zvkrap01_dt_demo INTO @DATA(lv_count).
    out->write( |Rows now in the table: { lv_count }| ).
  ENDMETHOD.

  METHOD rows_string.
    " STRING FUNCTIONS (rec_id 101-118, tag STR)
    " Covers ltrim, rtrim, lpad, rpad, upper, lower, concat, concat_with_space, left, right, substring, instr, length, replace and replace_regexpr.
    " Each row has one purpose; the comment above the row tells which function it feeds and what the result should be.
    " Columns: t_char30 and t_sstr for the main text, t_char10 for trimming and padding, t_numc4/t_numc6 as numeric text, t_str for the long text.
    " Filter hint: case_desc LIKE 'STR%'
    r = VALUE #(
      " Leading blanks: ltrim( t_char30, ' ' ) removes the 3 blanks in front.
      " t_char10 starts with zeros for ltrim( t_char10, '0' ); t_numc4/t_numc6 feed lpad and concat.
      ( rec_id = 101 case_desc = 'STR trim: leading blanks'
        t_char30 = '   Leading blanks' t_sstr = '   Leading blanks' t_char10 = '0000012345' t_numc4 = '0007' t_numc6 = '000123' )
      " Trailing blanks: CHAR is blank-padded, so the blanks are not visible. rtrim( t_char30, ' ' ) shows that nothing changes.
      " t_char10 ends with X for rtrim( t_char10, 'X' ).
      ( rec_id = 102 case_desc = 'STR trim: trailing blanks (not kept in char)'
        t_char30 = 'Trailing blanks   ' t_sstr = 'Trailing blanks   ' t_char10 = 'ABC12XXXXX' t_numc4 = '0042'
        t_numc6 = '000456' )
      " Blanks on both sides: use ltrim and rtrim together. t_char10 has leading zeros AND trailing X for the same demo.
      ( rec_id = 103 case_desc = 'STR trim: blanks on both sides'
        t_char30 = '   Both sides   ' t_sstr = '   Both sides   ' t_char10 = '00099XXXXX' t_numc4 = '0100' t_numc6 = '000789' )
      " Nothing to trim: the result must equal the input. t_char10 = 'AB' is shorter than the pad length used by lpad/rpad.
      ( rec_id = 104 case_desc = 'STR trim: nothing to trim'
        t_char30 = 'NoBlanks' t_sstr = 'NoBlanks' t_char10 = 'AB' t_numc4 = '1234' t_numc6 = '999999' )
      " Mixed case for upper( ) and lower( ). t_char10 has exactly 10 characters, so a pad to 10 adds nothing.
      " t_char30 + t_numc6 + t_sstr are the three operands for concat( ) and concat_with_space( ).
      ( rec_id = 105 case_desc = 'STR case: mixed case'
        t_char30 = 'mixed Case Text' t_sstr = 'Item A' t_char10 = 'ABCDEFGHIJ' t_numc4 = '0001' t_numc6 = '000001' )
      " Already upper case: upper( ) changes nothing, lower( ) changes everything.
      ( rec_id = 106 case_desc = 'STR case: all upper'
        t_char30 = 'ALL UPPER CASE' t_sstr = 'Item B' t_char10 = 'A' t_numc4 = '0002' t_numc6 = '000002' )
      " Already lower case: the opposite of the row above.
      ( rec_id = 107 case_desc = 'STR case: all lower'
        t_char30 = 'all lower case' t_sstr = 'Item C' t_char10 = '7' t_numc4 = '0003' t_numc6 = '000003' )
      " Umlauts and sharp s: shows how upper( ) and lower( ) treat non-ASCII characters on your system.
      ( rec_id = 108 case_desc = 'STR case: umlauts'
        t_char30 = 'Müller Straße ÄÖÜ' t_sstr = 'Item D' t_numc4 = '0004' t_numc6 = '000004' )
      " 26 characters in a row for left( ), right( ) and substring( ) with positions that stay inside the text.
      ( rec_id = 109 case_desc = 'STR cut: alphabet'
        t_char30 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' t_sstr = 'Item E' t_numc4 = '0005' t_numc6 = '000005' )
      " Hyphenated words: substring( t_char30, 5, 4 ) = 'ABAP', left( t_char30, 3 ) = 'SAP', right( ..., 4 ) = '2026'.
      ( rec_id = 110 case_desc = 'STR cut: hyphenated words'
        t_char30 = 'SAP-ABAP-CLOUD-2026' t_sstr = 'Item F' t_numc4 = '0006' t_numc6 = '000006' )
      " E-mail with @: instr( t_char30, '@' ) > 0 and length( t_char30 ) = 20.
      ( rec_id = 111 case_desc = 'STR find: e-mail with @'
        t_char30 = 'john.doe@example.com' )
      " E-mail without @: instr( t_char30, '@' ) returns 0 (SAP: 0 means no match).
      ( rec_id = 112 case_desc = 'STR find: e-mail without @'
        t_char30 = 'no-at-sign.example.com' )
      " Shortest case: '@' is the middle character, length = 3.
      ( rec_id = 113 case_desc = 'STR find: shortest e-mail'
        t_char30 = 'a@b' )
      " Phone with brackets and plus sign: replace( t_char30, '(', '' ) and replace( ..., ')', '' ) remove the brackets.
      ( rec_id = 114 case_desc = 'STR replace: phone with brackets'
        t_char30 = '+49 (170) 123-4567' )
      " Phone with hyphen and blank: replace( t_char30, '-', '' ) and replace( t_char30, ' ', '' ) clean the number.
      ( rec_id = 115 case_desc = 'STR replace: phone with hyphen and blank'
        t_char30 = '040-123 456' )
      " Letters, digits and symbols mixed: replace_regexpr( PCRE => '\d', VALUE => t_sstr, WITH => '#' ) masks the digits.
      ( rec_id = 116 case_desc = 'STR regex: letters, digits, symbols'
        t_sstr = 'abc123XYZ!?' )
      " Order reference with two number groups: a regex replaces every digit group, a plain replace( ) would need one call per digit.
      ( rec_id = 117 case_desc = 'STR regex: order reference'
        t_sstr = 'Order A12-B345 / 2026' )
      " t_str holds about 330 characters, t_sstr only a short text. Use this row to compare string and sstring in CDS.
      ( rec_id = 118 case_desc = 'STR long text in string, short in sstring'
        t_str = repeat( val = `Long text. ` occ = 30 ) t_sstr = 'Short text in sstring' ) ).
  ENDMETHOD.

  METHOD rows_arith.
    " ARITHMETIC, NUMERIC AND MATHEMATICAL FUNCTIONS (rec_id 201-208 tag ARI, 301-303 tag MAT)
    " ARI rows serve + - * /, abs, ceil, floor, round, div, mod and division. They share the same columns: int1/2/4/8, dec, dec2, df34, fltp, curr and quan.
    " MAT rows compare dec, decfloat16, decfloat34 and fltp for the same value, to show float and decimal precision.
    " No row has a zero divisor, because the behaviour for division by zero is not verified.
    " Filter hint: case_desc LIKE 'ARI%' or 'MAT%'
    r = VALUE #(
      " Positive values. 17 div 5 = 3 and 17 mod 5 = 2. 10 / 3 gives a repeating decimal. 45 percent cases follow in 204.
      " t_curr/t_quan carry a currency key and a unit, so they can be used in arithmetic after a cast.
      ( rec_id = 201 case_desc = 'ARI positive values, division with remainder'
        t_int1 = '10' t_int2 = '5' t_int4 = '17' t_int8 = '4000000000' t_dec = '10.000' t_dec2 = '3.00' t_df34 = '2.5'
        t_fltp = '0.1' t_curr = '12.50' t_cuky = 'EUR' t_quan = '3.000' t_unit = 'ST' )
      " Negative values for abs( ), div( ), mod( ). t_int1 = 255 is the largest value an int1 can hold. t_fltp = 1/3 for fltp_to_dec.
      ( rec_id = 202 case_desc = 'ARI negative values'
        t_int1 = '255' t_int2 = '5' t_int4 = '-17' t_int8 = '-4000000000' t_dec = '-2.500' t_dec2 = '8.00' t_df34 = '-2.5'
        t_fltp = '0.3333333333333333' t_curr = '-5.25' t_cuky = 'EUR' t_quan = '-1.500' t_unit = 'ST' )
      " Exact division: 20 div 5 = 4 and 20 mod 5 = 0. 1 / 8 = 0.125 is an exact decimal. 1E10 is a large float.
      ( rec_id = 203 case_desc = 'ARI exact division, remainder zero'
        t_int1 = '0' t_int2 = '5' t_int4 = '20' t_int8 = '9000000000' t_dec = '1.000' t_dec2 = '8.00' t_df34 = '2.4'
        t_fltp = '1E10' t_curr = '100.00' t_cuky = 'USD' t_quan = '10.000' t_unit = 'ST' )
      " Negative divisor: 17 div -5 and 17 mod -5. 45 / 60 * 100 = 75 percent. 1E-10 is a tiny float (rounds to 0 as dec).
      ( rec_id = 204 case_desc = 'ARI negative divisor, 75 percent'
        t_int1 = '1' t_int2 = '-5' t_int4 = '17' t_int8 = '1' t_dec = '45.000' t_dec2 = '60.00' t_df34 = '-2.6' t_fltp = '1E-10'
        t_curr = '9999999.99' t_cuky = 'JPY' t_quan = '0.500' t_unit = 'KG' )
      " Zero values: 0 percent, abs( 0 ), zero amount and zero quantity. t_dec2 = 60 is never zero, so no division by zero happens.
      ( rec_id = 205 case_desc = 'ARI zero values, 0 percent'
        t_int1 = '0' t_int2 = '3' t_int4 = '0' t_int8 = '0' t_dec = '0.000' t_dec2 = '60.00' t_df34 = '2.675' t_fltp = '0'
        t_curr = '0.00' t_cuky = 'EUR' t_quan = '0.000' t_unit = 'ST' )
      " 100 percent case (60 / 60). t_df34 = 1.005 shows round( t_df34, 2 ) and the decfloat rounding rule.
      ( rec_id = 206 case_desc = 'ARI 100 percent, rounding at 1.005'
        t_int1 = '1' t_int2 = '32' t_int4 = '100' t_int8 = '100' t_dec = '60.000' t_dec2 = '60.00' t_df34 = '1.005'
        t_fltp = '0.1' t_curr = '1000.00' t_cuky = 'EUR' t_quan = '12.000' t_unit = 'ST' )
      " Many decimals: 1234567.891 / 12.34 and division( t_dec, t_dec2, 2 ) produce long decimals; t_int4 = 5 and t_int2 = 7 mix int with dec.
      ( rec_id = 207 case_desc = 'ARI many decimals for division'
        t_int2 = '7' t_int4 = '5' t_dec = '1234567.891' t_dec2 = '12.34' t_df34 = '0.5' )
      " Largest values that still fit dec(15,3) and dec(9,2). Do not multiply them with each other in a demo (overflow not verified).
      ( rec_id = 208 case_desc = 'ARI large decimal values'
        t_dec = '999999999999.999' t_dec2 = '9999999.99' t_df34 = '-0.5' )
      " decfloat16 holds 16 digits, decfloat34 holds 34 digits. Compare both with the plain dec and float value.
      ( rec_id = 301 case_desc = 'MAT decfloat with many digits'
        t_df16 = '1234567890.123456' t_df34 = '1234567890123456789012345678.123456' t_dec = '0.100' t_fltp = '0.1' )
      " One third stored in four types. The more digits the type keeps, the closer to 0.3333...
      ( rec_id = 302 case_desc = 'MAT one third in four types'
        t_dec = '0.333' t_df16 = '0.3333333333333333' t_df34 = '0.3333333333333333333333333333333333'
        t_fltp = '0.3333333333333333' )
      " 0.1 and 0.2 in decfloat and float. In float 0.1 + 0.2 is not exactly 0.3; in decfloat it is.
      ( rec_id = 303 case_desc = 'MAT 0.1 and 0.2 in decfloat and float'
        t_df16 = '0.1' t_df34 = '0.2' t_fltp = '0.2' ) ).
  ENDMETHOD.

  METHOD rows_cond.
    " CONDITIONS (rec_id 401-405, tag CND)
    " t_char1 drives the simple CASE (A, B, C, X, initial). t_int4 and t_dec drive the searched CASE. t_char30 and t_dats drive LIKE and BETWEEN.
    " t_int4 values stay below 101 or above 1000 so they never point to the rec_id of another row in the self join demos.
    " Filter hint: case_desc LIKE 'CND%'
    r = VALUE #(
      " Status A with a small number: first WHEN of the simple CASE; t_int4 = 5 falls in the lowest range of the searched CASE. Text starts with 'SAP' for LIKE 'SAP%'.
      ( rec_id = 401 case_desc = 'CND status A, small number'
        t_char1 = 'A' t_int4 = '5' t_dec = '5.000' t_char30 = 'SAP Business Technology' t_dats = '20260101' )
      " Status B with t_int4 = 50, the middle range of the searched CASE. LIKE 'SAP%' also matches. Date is mid-year for BETWEEN.
      ( rec_id = 402 case_desc = 'CND status B, medium number'
        t_char1 = 'B' t_int4 = '50' t_dec = '50.000' t_char30 = 'SAP ABAP Cloud' t_dats = '20260630' )
      " Status C with t_int4 = 5000, the highest range. LIKE 'SAP%' does not match. Date is year end for BETWEEN.
      ( rec_id = 403 case_desc = 'CND status C, large number'
        t_char1 = 'C' t_int4 = '5000' t_dec = '5000.000' t_char30 = 'Other text entirely' t_dats = '20261231' )
      " Status X: no WHEN matches, so the ELSE branch is used (or NULL if the CASE has no ELSE).
      ( rec_id = 404 case_desc = 'CND status X, no WHEN matches'
        t_char1 = 'X' t_int4 = '0' t_dec = '0.000' )
      " Initial status and a negative number: tests IS INITIAL and the ELSE branch of the searched CASE.
      ( rec_id = 405 case_desc = 'CND initial status, negative number'
        t_int4 = '-1' t_dec = '-1.000' ) ).
  ENDMETHOD.

  METHOD rows_date.
    " DATE AND TIME (rec_id 501-509, tag DAT)
    " Each row holds the same moment in several types: dats/tims, datn/timn, tstmp (YYYYMMDDHHMMSS) and utclong, plus the time zone and the posting period.
    " Rows 501-503 are the same local moment in three time zones, so the timestamp functions give different results.
    " Rows with impossible values are in rows_risky (rec_id 510).
    " Filter hint: case_desc LIKE 'DAT%'
    DATA(lv_now) = utclong_current( ).
    r = VALUE #(
      " Valid date and time with zone UTC. t_utc = now. t_accp = '202610' is the posting period of the date. t_tstmp has the same digits as t_dats + t_tims; t_tzone says in which zone to read them.
      ( rec_id = 501 case_desc = 'DAT valid date and time, zone UTC'
        t_dats = '20261011' t_tims = '083000' t_datn = '20261011' t_timn = '083000' t_tstmp = '20261011083000' t_tzone = 'UTC'
        t_utc = lv_now t_accp = '202610' )
      " Same date and time, zone INDIA: tstmp_to_dats / tstmp_to_tims must give a different result. t_utc = now + 60 seconds.
      ( rec_id = 502 case_desc = 'DAT same moment, zone INDIA'
        t_dats = '20261011' t_tims = '083000' t_datn = '20261011' t_timn = '083000' t_tstmp = '20261011083000' t_tzone = 'INDIA'
        t_utc = utclong_add( val = lv_now seconds = 60 ) t_accp = '202610' )
      " Same date and time, zone JAPAN. t_utc = now - 1 hour, so utcl_seconds_between has a negative case.
      ( rec_id = 503 case_desc = 'DAT same moment, zone JAPAN'
        t_dats = '20261011' t_tims = '083000' t_datn = '20261011' t_timn = '083000' t_tstmp = '20261011083000' t_tzone = 'JAPAN'
        t_utc = utclong_add( val = lv_now hours = -1 ) t_accp = '202610' )
      " Leap day 29 Feb 2024 at 23:59:59: dats_add_days / dats_add_months across the leap day. Posting period 202402.
      ( rec_id = 504 case_desc = 'DAT leap day'
        t_dats = '20240229' t_tims = '235959' t_datn = '20240229' t_timn = '235959' t_tstmp = '20240229235959' t_tzone = 'UTC'
        t_accp = '202402' )
      " 31 January: dats_add_months( t_dats, 1, 'INITIAL' ) must land on the last day of February.
      ( rec_id = 505 case_desc = 'DAT month end January'
        t_dats = '20260131' t_tims = '000000' t_datn = '20260131' t_timn = '000000' t_tstmp = '20260131000000' t_tzone = 'CET'
        t_accp = '202601' )
      " Year end: add days crosses into the next year; posting period 202612.
      ( rec_id = 506 case_desc = 'DAT year end'
        t_dats = '20261231' t_tims = '120000' t_datn = '20261231' t_timn = '120000' t_tstmp = '20261231120000' t_tzone = 'UTC'
        t_accp = '202612' )
      " 00010101 is the earliest date SAP treats as valid (dats_is_valid = 1), 00000000 is not.
      ( rec_id = 507 case_desc = 'DAT earliest valid date'
        t_dats = '00010101' t_tims = '000000' t_datn = '00010101' t_timn = '000000' )
      " Today from the system clock: use it to compare with $session.system_date (dats_days_between = 0).
      ( rec_id = 508 case_desc = 'DAT today by system clock'
        t_dats = cl_abap_context_info=>get_system_date( ) t_tims = cl_abap_context_info=>get_system_time( )
        t_datn = cl_abap_context_info=>get_system_date( ) t_timn = cl_abap_context_info=>get_system_time( ) t_utc = lv_now )
      " Nothing filled: initial date and time. dats_is_valid returns 0 for the initial value.
      ( rec_id = 509 case_desc = 'DAT initial date and time' ) ).
  ENDMETHOD.

  METHOD rows_agg.
    " AGGREGATES, CONVERSION AND UNION (rec_id 601-609, tag AGG)
    " Groups: EUR (4 rows), USD (3 rows), JPY (2 rows) in t_char5. t_cuky always equals the group, so sum( t_curr ) with GROUP BY t_char5, t_cuky works.
    " Status in t_char1 (A or B) overlaps with the group, so a union of 'status A' and 'group EUR' returns rows twice.
    " t_quan/t_unit hold g, kg and litres for unit_conversion; t_char3 is a second grouping level for count( distinct ... ) and HAVING.
    " Filter hint: case_desc LIKE 'AGG%'
    r = VALUE #(
      " Group EUR, status A. Weights in g and kg for unit_conversion; amount in EUR for currency_conversion and sum( ).
      ( rec_id = 601 case_desc = 'AGG group EUR, status A, unit G'
        t_char5 = 'EUR' t_char1 = 'A' t_char3 = 'KG' t_cuky = 'EUR' t_curr = '100.00' t_dec = '10.500' t_dats = '20260115'
        t_numc4 = '0010' t_quan = '1000.000' t_unit = 'G' )
      " Group EUR, status A again: two rows with the same group AND status, so union and union all show duplicates.
      ( rec_id = 602 case_desc = 'AGG group EUR, status A, unit KG'
        t_char5 = 'EUR' t_char1 = 'A' t_char3 = 'KG' t_cuky = 'EUR' t_curr = '250.00' t_dec = '20.250' t_dats = '20260215'
        t_numc4 = '0020' t_quan = '2.500' t_unit = 'KG' )
      " Group EUR, status B, 500 g. t_numc4 = 0100 has leading zeros for sum( cast( t_numc4 as abap.int4 ) ).
      ( rec_id = 603 case_desc = 'AGG group EUR, status B, unit G'
        t_char5 = 'EUR' t_char1 = 'B' t_char3 = 'G' t_cuky = 'EUR' t_curr = '75.50' t_dec = '5.000' t_dats = '20260315'
        t_numc4 = '0100' t_quan = '500.000' t_unit = 'G' )
      " Group EUR, status B, unit L: litre cannot be converted to kg, so this row shows how unit_conversion reacts (behaviour not verified).
      ( rec_id = 604 case_desc = 'AGG group EUR, status B, unit L (other kind)'
        t_char5 = 'EUR' t_char1 = 'B' t_char3 = 'L' t_cuky = 'EUR' t_curr = '10.00' t_dec = '1.000' t_dats = '20260401'
        t_numc4 = '0007' t_quan = '3.000' t_unit = 'L' )
      " Group USD, status A, 1 kg: converts to 1000 g.
      ( rec_id = 605 case_desc = 'AGG group USD, status A, unit KG'
        t_char5 = 'USD' t_char1 = 'A' t_char3 = 'KG' t_cuky = 'USD' t_curr = '300.00' t_dec = '30.000' t_dats = '20260110'
        t_numc4 = '0001' t_quan = '1.000' t_unit = 'KG' )
      " Group USD, status B, litres.
      ( rec_id = 606 case_desc = 'AGG group USD, status B, unit L'
        t_char5 = 'USD' t_char1 = 'B' t_char3 = 'L' t_cuky = 'USD' t_curr = '45.00' t_dec = '4.500' t_dats = '20260210'
        t_numc4 = '0002' t_quan = '2.000' t_unit = 'L' )
      " Group USD, status A, litres: group USD now has 3 rows.
      ( rec_id = 607 case_desc = 'AGG group USD, status A, unit L'
        t_char5 = 'USD' t_char1 = 'A' t_char3 = 'L' t_cuky = 'USD' t_curr = '60.00' t_dec = '6.000' t_dats = '20260310'
        t_numc4 = '0003' t_quan = '10.000' t_unit = 'L' )
      " Group JPY, status A: yen amount for currency_conversion; group has only 2 rows (groups of different size).
      ( rec_id = 608 case_desc = 'AGG group JPY, status A, unit G'
        t_char5 = 'JPY' t_char1 = 'A' t_char3 = 'G' t_cuky = 'JPY' t_curr = '10000.00' t_dec = '1.000' t_dats = '20260105'
        t_numc4 = '0050' t_quan = '100.000' t_unit = 'G' )
      " Group JPY, status B: the second yen row.
      ( rec_id = 609 case_desc = 'AGG group JPY, status B, unit G'
        t_char5 = 'JPY' t_char1 = 'B' t_char3 = 'G' t_cuky = 'JPY' t_curr = '5000.00' t_dec = '2.000' t_dats = '20260205'
        t_numc4 = '0500' t_quan = '250.000' t_unit = 'G' ) ).
  ENDMETHOD.

  METHOD rows_cast.
    " CASTING (rec_id 701-714, tag CST)
    " One block per cast family of the cast matrix: x, y, z, d, p and the [-] combinations.
    " Valid, impossible and zero values sit in different rows (704, 705, 706). Time and period casts use their own rows (707-709).
    " Impossible values are stored as text (char/numc) here, so they can be loaded without problems.
    " Filter hint: case_desc LIKE 'CST%'
    r = VALUE #(
      " Number casts. t_int4 negative, t_dec negative with 3 decimals, t_numc14 = a full timestamp as text, t_char30 longer than 10.
      ( rec_id = 701 case_desc = 'CST number: negative, long text, timestamp text'
        t_int4 = '-7' t_dec = '-0.001' t_numc14 = '20261011083000' t_char30 = 'This text is longer than ten' )
      " Zero values: t_numc14 all zeros, t_char30 shorter than the target field.
      ( rec_id = 702 case_desc = 'CST number: zero, short text, zero timestamp'
        t_int4 = '0' t_dec = '0.000' t_numc14 = '00000000000000' t_char30 = 'Short' )
      " Large values: t_int4 near the int4 limit (still fits). Use 4000000000 in t_numc10 to show an overflow when casting to int4.
      ( rec_id = 703 case_desc = 'CST number: large values'
        t_int4 = '2000000000' t_dec = '1234567.891' t_numc14 = '99999999999999' t_char30 = 'Another text longer than ten' )
      " Valid values for the [y] and [z] casts: char8/numc8 to dats, char6/numc6 to tims, char10/numc10 to numc/int, char1/char3/char5 to lang/unit/cuky.
      ( rec_id = 704 case_desc = 'CST date, time, codes: valid values'
        t_char8 = '20261011' t_numc8 = '20261011' t_char6 = '083000' t_numc6 = '083000' t_char10 = '0000012345'
        t_numc10 = '0000000042' t_char1 = 'E' t_char3 = 'KG' t_char5 = 'EUR' t_dats = '20261011' t_tims = '083000' )
      " Impossible values: month 13, hour 24, minute 61, text with a blank inside. Codes D, ST and USD are valid.
      ( rec_id = 705 case_desc = 'CST date, time, codes: impossible values'
        t_char8 = '20261331' t_numc8 = '20261331' t_char6 = '246000' t_numc6 = '246100' t_char10 = '12 345'
        t_numc10 = '2000000000' t_char1 = 'D' t_char3 = 'ST' t_char5 = 'USD' )
      " Zero and letters: numc8/numc6 all zeros, char10 with letters. Code F (French) and L (litre).
      ( rec_id = 706 case_desc = 'CST date, time, codes: zero and letters'
        t_numc8 = '00000000' t_numc6 = '000000' t_char10 = 'ABC1234567' t_numc10 = '1234567890' t_char1 = 'F' t_char3 = 'L' )
      " Posting period: char6 and numc6 to accp [p]. accp itself holds '202610' for the accp to char cast [z].
      ( rec_id = 707 case_desc = 'CST period: valid year and month'
        t_char6 = '202610' t_numc6 = '202610' t_accp = '202610' )
      " Period zero: 000000.
      ( rec_id = 708 case_desc = 'CST period: zero'
        t_char6 = '000000' t_numc6 = '000000' )
      " Invalid month 13: shows what the cast does with an impossible period.
      ( rec_id = 709 case_desc = 'CST period: invalid month 13'
        t_char6 = '202613' t_numc6 = '202613' )
      " [d] casts: language, unit and currency key to char. E, KG, EUR.
      ( rec_id = 710 case_desc = 'CST text from language, unit, currency'
        t_lang = 'E' t_unit = 'KG' t_cuky = 'EUR' )
      " [d] casts again with D, ST and USD.
      ( rec_id = 711 case_desc = 'CST text from second language, unit, currency'
        t_lang = 'D' t_unit = 'ST' t_cuky = 'USD' )
      " [-] case: char10 = '12345' to dec and int4 = 12345 to numc are not castable; ADT should show a syntax error.
      ( rec_id = 712 case_desc = 'CST number to text, char to dec not allowed'
        t_char10 = '12345' t_int4 = '12345' )
      " [z] cast: accp to char and numc. Posting period 202612.
      ( rec_id = 713 case_desc = 'CST text from posting period'
        t_accp = '202612' )
      " Initial row: initial accp and initial date for the cast demos.
      ( rec_id = 714 case_desc = 'CST initial posting period and date' ) ).
  ENDMETHOD.

  METHOD rows_join.
    " SELF JOIN AND ASSOCIATION (rec_id 801-806, tag JON)
    " t_int4 holds the rec_id of a 'parent' row. 0 or a missing id means no parent. t_char3 groups rows for the inner self join.
    " Row 805 points to 999, which does not exist, to show the unmatched case of a left outer join.
    " Filter hint: case_desc LIKE 'JON%'
    r = VALUE #(
      " Root row: t_int4 = 0 points to nothing. Code AAA is shared with row 802 for the inner self join on t_char3.
      ( rec_id = 801 case_desc = 'JON root row, code AAA'
        t_char3 = 'AAA' t_int4 = '0' )
      " Child of 801 (t_int4 = 801): the left outer self join finds a match, the association [0..1] resolves.
      ( rec_id = 802 case_desc = 'JON child of 801, code AAA'
        t_char3 = 'AAA' t_int4 = '801' )
      " Second child of 801. Code BBB is shared with row 804.
      ( rec_id = 803 case_desc = 'JON second child of 801, code BBB'
        t_char3 = 'BBB' t_int4 = '801' )
      " Child of 802: a second level, t_int4 = 802.
      ( rec_id = 804 case_desc = 'JON child of 802, code BBB'
        t_char3 = 'BBB' t_int4 = '802' )
      " Pointer to row 999, which does not exist: left outer self join gives NULL, coalesce( ..., 'N' ) replaces it.
      ( rec_id = 805 case_desc = 'JON pointer to a missing row, code CCC'
        t_char3 = 'CCC' t_int4 = '999' )
      " Root row with code CCC, shared with row 805.
      ( rec_id = 806 case_desc = 'JON root row, code CCC'
        t_char3 = 'CCC' t_int4 = '0' ) ).
  ENDMETHOD.

  METHOD rows_risky.
    " RISKY ROWS (rec_id 510 and 901)
    " Row 510 holds impossible dates, times and periods in real date/time columns; row 901 fills every column, including t_raw.
    " The database or the type conversion may reject them, so main( ) loads each of these rows in its own TRY block.
    " A rejected row prints its error text and the load continues.
    DATA(lv_now) = utclong_current( ).
    r = VALUE #(
      " Impossible date (month 13), impossible time (hour 24) and impossible period (month 13) in the real date, time and period columns.
      " SAP says dats_is_valid returns 0 for such a date. The database may reject these values, so the row is loaded separately.
      ( rec_id = 510 case_desc = 'DAT impossible date, time and period'
        t_dats = '20261331' t_tims = '246000' t_datn = '20261331' t_timn = '246000' t_accp = '202613' )
      " Every column filled once: use it for scenario 'show every type as a view element'. t_raw is set with a conversion, so this row is loaded separately.
      ( rec_id = 901 case_desc = 'ALL every column filled'
        t_int1 = '1' t_int2 = '2' t_int4 = '3' t_int8 = '4' t_dec = '5.000' t_dec2 = '6.00' t_df16 = '7.5' t_df34 = '8.5'
        t_fltp = '9.5' t_char1 = 'A' t_char3 = 'KG' t_char5 = 'EUR' t_char6 = '083000' t_char8 = '20261011'
        t_char10 = '0000012345' t_char30 = 'Thirty characters at most' t_sstr = 'Short string' t_str = 'Unlimited string'
        t_numc4 = '0004' t_numc6 = '000006' t_numc8 = '20261011' t_numc10 = '0000000010' t_numc14 = '20261011083000'
        t_dats = '20261011' t_datn = '20261011' t_tims = '083000' t_timn = '083000' t_utc = lv_now t_tstmp = '20261011083000'
        t_tstmpl = '20261011083000.1234567' t_tzone = 'UTC' t_accp = '202610' t_lang = 'E' t_cuky = 'EUR' t_curr = '12.50'
        t_unit = 'KG' t_quan = '3.000' t_raw = CONV #( '0123456789ABCDEF' ) ) ).
  ENDMETHOD.

ENDCLASS.
