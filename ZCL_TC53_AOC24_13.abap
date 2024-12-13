CLASS zcl_tc53_aoc24_13 DEFINITION
  PUBLIC
  INHERITING FROM zcl_tc53_aoc24_utils
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: process REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_factors,
             xa TYPE i,
             xb TYPE i,
             ya TYPE i,
             yb TYPE i,
             x  TYPE int8,
             y  TYPE int8,
           END OF ty_factors.
    METHODS calcfirst      IMPORTING calculation   TYPE zcl_tc53_aoc24_13=>ty_factors
                      RETURNING VALUE(result) TYPE i.
    METHODS calc      IMPORTING calculation   TYPE zcl_tc53_aoc24_13=>ty_factors
                       RETURNING VALUE(result) TYPE int8.
ENDCLASS.

CLASS zcl_tc53_aoc24_13 IMPLEMENTATION.
  METHOD process.
    DATA calculation TYPE ty_factors.
    DO.
      TRY.
          DATA(line) = file_handler->get_next_line( ).
          IF line <> ' '.
            IF substring( val = line off = 0 len = 9 ) = 'Button A:'.
              SPLIT line AT '+' INTO DATA(prefix) DATA(xa) DATA(rest).
              calculation-ya = rest.
              SPLIT xa AT ',' INTO xa rest.
              calculation-xa = xa.
              line = file_handler->get_next_line( ).
              SPLIT line AT '+' INTO prefix DATA(xb) rest.
              calculation-yb = rest.
              SPLIT xb AT ',' INTO xb rest.
              calculation-xb = xb.
              line = file_handler->get_next_line( ).
              SPLIT line AT '=' INTO prefix DATA(x) rest.
              calculation-y = rest.
              SPLIT x AT ',' INTO x rest.
              calculation-x = x.
              part1 = part1 + calc( calculation ).
              calculation-x = calculation-x + 10000000000000.
              calculation-y = calculation-y + 10000000000000.
              part2 = part2 + calc( calculation ).
            ENDIF.
          ENDIF.
        CATCH zcx_tc53_aoc24_eof.
          EXIT.
      ENDTRY.
    ENDDO.
  ENDMETHOD.

  METHOD calc.
    DATA(timesb) = abs( ( calculation-y * calculation-xa - calculation-x * calculation-ya ) / ( calculation-xb * calculation-ya - calculation-yb * calculation-xa ) ).
    DATA(timesa) = ( calculation-x - calculation-xb * timesb ) / calculation-xa.
    IF calculation-x = timesa * calculation-xa + timesb * calculation-xb AND
       calculation-y = timesa * calculation-ya + timesb * calculation-yb.
      result = 3 * timesa + timesb.
    ELSE.
      result = 0.
    ENDIF.
  ENDMETHOD.

  METHOD calcfirst.
**** FIRST ATTEMPT: WORKED for Part 1 :-) ****************************
    DATA upper_index TYPE i.
    DATA found TYPE abap_bool.

    WHILE upper_index < 101 AND found = abap_false.
      upper_index = sy-index.
      found = abap_false.
      DO 100 TIMES.
        IF calculation-xa * upper_index + calculation-xb * sy-index = calculation-x AND
           calculation-ya * upper_index + calculation-yb * sy-index = calculation-y.
          DATA(index) = sy-index.
          found = abap_true.
          EXIT.
        ENDIF.
      ENDDO.
    ENDWHILE.
    result = COND #(  WHEN found = abap_true
                      THEN 3 * upper_index + index
                      ELSE 0 ).
  ENDMETHOD.

ENDCLASS.
