CLASS zcl_tc53_aoc24_file_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING input TYPE string.
    METHODS get_next_line RETURNING VALUE(result) TYPE string.
    METHODS get_stream RETURNING VALUE(result) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA inputfile TYPE string.
ENDCLASS.



CLASS zcl_tc53_aoc24_file_handler IMPLEMENTATION.

  METHOD constructor.
    me->inputfile = input.
    OPEN DATASET me->inputfile FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  ENDMETHOD.

  METHOD get_next_line.
    READ DATASET me->inputfile INTO result.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_tc53_aoc24_eof.
    ENDIF.
  ENDMETHOD.

  METHOD get_stream.
    DATA line TYPE string.
    DO.
      READ DATASET me->inputfile INTO line.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      CONCATENATE result line INTO result.
    ENDDO.
  ENDMETHOD.

ENDCLASS.