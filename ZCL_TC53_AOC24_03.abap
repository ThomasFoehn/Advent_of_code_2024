CLASS zcl_tc53_aoc24_03 DEFINITION
  PUBLIC
  INHERITING FROM zcl_tc53_aoc24_utils
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS process REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS find_and_calc IMPORTING stream        TYPE string
                          RETURNING VALUE(result) TYPE i.
    METHODS get_next_active_part      IMPORTING stream        TYPE string
                                      RETURNING VALUE(result) TYPE string.
    DATA stream TYPE string.
ENDCLASS.

CLASS zcl_tc53_aoc24_03 IMPLEMENTATION.
  METHOD process.
    DATA: result_tab TYPE match_result_tab.

    file_handler = NEW #( filename ).
    me->stream = file_handler->get_stream( ).
    part1 = find_and_calc( stream ).


    FIND FIRST OCCURRENCE OF 'don''t()' IN stream RESULTS result_tab.
    LOOP AT result_tab INTO DATA(result).
      DATA(streampart) = stream(result-offset).
      part2 = find_and_calc( streampart ).
    ENDLOOP.

    SHIFT me->stream BY result-offset + result-length PLACES.
    FIND FIRST OCCURRENCE OF 'do()' IN stream RESULTS result_tab.
    result = result_tab[ 1 ].
    SHIFT me->stream BY result-offset PLACES.
    DO.
      streampart = get_next_active_part( stream ).
      IF strlen( streampart ) = 0.
        EXIT.
      ENDIF.
      part2 = part2 + find_and_calc( streampart ).
      SHIFT me->stream BY strlen( streampart ) + 7 PLACES.
    ENDDO.
  ENDMETHOD.

  METHOD find_and_calc.
    DATA: result_tab TYPE match_result_tab.

    DATA string2 TYPE string.
    DATA: string3 TYPE string.
    DATA: offset TYPE i.
    DATA length TYPE i.

    FIND ALL OCCURRENCES OF REGEX 'mul\(\d{1,3},\d{1,3}\)' IN stream RESULTS result_tab.
    LOOP AT result_tab INTO DATA(result_line).
      offset = result_line-offset + 4.
      length = result_line-length - 5.
      SPLIT stream+offset(length) AT ',' INTO string2 string3.
      result = result + string2 * string3.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_next_active_part.
    DATA: result_tab TYPE match_result_tab.
    FIND FIRST OCCURRENCE OF 'do()' IN stream RESULTS result_tab.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    DATA(begin) = result_tab[ 1 ].
    FIND FIRST OCCURRENCE OF 'don''t()' IN stream+begin-offset RESULTS result_tab.
    IF sy-subrc <> 0.
      result = stream+begin-offset.
      RETURN.
    ENDIF.
    DATA(end) = result_tab[ 1 ].
    result = stream+begin-offset(end-offset).
    SHIFT me->stream BY begin-offset PLACES.
  ENDMETHOD.

ENDCLASS.