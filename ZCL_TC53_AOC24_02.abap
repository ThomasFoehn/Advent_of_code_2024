CLASS zcl_tc53_aoc24_02 DEFINITION
INHERITING FROM zcl_tc53_aoc24_utils
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS process REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.


    METHODS is_valid IMPORTING data          TYPE table
                     RETURNING VALUE(result) TYPE i.
    METHODS all_inc      IMPORTING data          TYPE table
                         RETURNING VALUE(result) TYPE abap_bool.
    METHODS all_dec      IMPORTING data          TYPE table
                         RETURNING VALUE(result) TYPE abap_bool.
    METHODS distance_ok      IMPORTING data          TYPE table
                             RETURNING VALUE(result) TYPE abap_bool.
    METHODS damperer      IMPORTING data          TYPE string_table
                          RETURNING VALUE(result) TYPE i.

ENDCLASS.


CLASS zcl_tc53_aoc24_02 IMPLEMENTATION.


  METHOD process.
    DATA: valid TYPE i.
    DATA counter1 TYPE i.
    DATA counter2 TYPE i.
    CLEAR: part1, part2.
    file_handler = NEW #( filename ).
    DO.
      TRY.
          DATA(line) = file_handler->get_next_line( ).
          SPLIT line AT space INTO TABLE DATA(linevalues).
          ADD 1 TO part2.
          valid = is_valid( linevalues ).
          counter1 = counter1 + valid.
          IF valid = 0.
            valid = damperer( linevalues ).
          ENDIF.
          counter2 = counter2 + valid.
        CATCH zcx_tc53_aoc24_eof.
          EXIT.
      ENDTRY.
    ENDDO.
    part1 = counter1.
    part2 = counter2.
  ENDMETHOD.

  METHOD is_valid.
    result = COND #( WHEN ( all_inc( data ) = abap_true AND distance_ok( data ) )
                     THEN 1
                     ELSE COND #( WHEN ( all_dec( data ) = abap_true AND distance_ok( data ) )
                     THEN 1
                     ELSE 0 ) ).
    IF result = 0.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD all_inc.
    DATA(line_count) = lines(  data ).
    result = abap_false.
    DO line_count  - 1 TIMES.
      IF CONV i( data[ sy-index ] ) < CONV i( data[ sy-index + 1 ] ).
        result = abap_true.
      ELSE.
        result = abap_false.
        RETURN.
      ENDIF.
    ENDDO.

  ENDMETHOD.

  METHOD all_dec.
    DATA(line_count) = lines(  data ).
    result = abap_false.
    DO line_count  - 1 TIMES.
      IF CONV i( data[ sy-index ] ) > CONV i( data[ sy-index + 1 ] )..
        result = abap_true.
      ELSE.
        result = abap_false.
        RETURN.
      ENDIF.
    ENDDO.

  ENDMETHOD.

  METHOD distance_ok.
    DATA ok TYPE abap_bool.
    DATA(line_count) = lines(  data ).
    result = abap_false.
    DO line_count  - 1 TIMES.
      IF abs( data[ sy-index ] - data[ sy-index + 1 ] ) > 0 AND
         abs( data[ sy-index ] - data[ sy-index + 1 ] ) < 4.
        result = abap_true.
      ELSE.
        result = abap_false.
        RETURN.
      ENDIF.
    ENDDO.

  ENDMETHOD.

  METHOD damperer.
    DO lines( data ) TIMES.
      DATA(tablevalue) = data.
      DELETE tablevalue INDEX sy-index .
      result = is_valid( tablevalue ).
      IF result = 1.
        EXIT.
      ENDIF.
    ENDDO.
  ENDMETHOD.

ENDCLASS.