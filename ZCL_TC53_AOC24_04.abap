CLASS zcl_tc53_aoc24_04 DEFINITION
  PUBLIC
  INHERITING FROM zcl_tc53_aoc24_utils
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: process REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS search_xmas      IMPORTING searchstring  TYPE string
                             RETURNING VALUE(result) TYPE i.
    METHODS search_cross      IMPORTING searchstring  TYPE string
                              RETURNING VALUE(result) TYPE i.

ENDCLASS.

CLASS zcl_tc53_aoc24_04 IMPLEMENTATION.

  METHOD process.

    DATA(input) = file_handler->get_all_table( ).
*** horizontal straight ***
*** REGEX is not working when overlapping both patterns ***
    FIND ALL OCCURRENCES OF regex 'XMAS' IN TABLE input RESULTS DATA(results).
    DATA(lines) = lines( results ).
    ADD lines TO part1.
*** horizontal backwards ***
    FIND ALL OCCURRENCES OF 'SAMX' IN TABLE input RESULTS results.
    lines = lines( results ).
    ADD lines TO part1.
*** vertical straight and backwards ***
    DO lines( input ) - 3 TIMES.
      READ TABLE input INTO DATA(line1) INDEX sy-index.
      READ TABLE input INTO DATA(line2) INDEX sy-index + 1.
      READ TABLE input INTO DATA(line3) INDEX sy-index + 2.
      READ TABLE input INTO DATA(line4) INDEX sy-index + 3.
      DO strlen( line1 ) TIMES.
        DATA(index) = sy-index - 1.
        part1 = part1 + search_xmas( |{ line1+index(1) }{ line2+index(1) }{ line3+index(1) }{ line4+index(1) }| ).
      ENDDO.
*** diagonal one side straight and backwards ***
      DO strlen( line1 ) - 3 TIMES.
        DATA(index1) = sy-index - 1.
        DATA(index2) = sy-index.
        DATA(index3) = sy-index + 1.
        DATA(index4) = sy-index + 2.
        part1 = part1 + search_xmas( |{ line1+index1(1) }{ line2+index2(1) }{ line3+index3(1) }{ line4+index4(1) }| ).
      ENDDO.
*** diagonal other side straight and backwards ***
      DO strlen( line1 ) - 3 TIMES.
        index1 = sy-index + 2.
        index2 = sy-index + 1.
        index3 = sy-index.
        index4 = sy-index - 1.
        part1 = part1 + search_xmas( |{ line1+index1(1) }{ line2+index2(1) }{ line3+index3(1) }{ line4+index4(1) }| ).
      ENDDO.
    ENDDO.

*** Part2 ***
    DO lines( input ) - 2 TIMES.
      READ TABLE input INTO line1 INDEX sy-index.
      READ TABLE input INTO line2 INDEX sy-index + 1.
      READ TABLE input INTO line3 INDEX sy-index + 2.

      DO strlen( line1 ) - 2 TIMES.
        index1 = sy-index - 1.
        index2 = sy-index.
        index3 = sy-index + 1.
        part2 = part2 + search_cross( |{ line1+index1(1) }{ line1+index3(1) }{ line2+index2(1) }{ line3+index1(1) }{ line3+index3(1) }| ).
      ENDDO.
    ENDDO.

  ENDMETHOD.

  METHOD search_xmas.

    result = COND #( WHEN searchstring = 'XMAS' OR searchstring = 'SAMX'
    THEN 1
    ELSE 0 ).

  ENDMETHOD.

  METHOD search_cross.
    result = COND #( WHEN searchstring = 'MSAMS' OR searchstring = 'MMASS' OR searchstring = 'SSAMM' or searchstring = 'SMASM'
    THEN 1
    ELSE 0 ).

  ENDMETHOD.

ENDCLASS.
