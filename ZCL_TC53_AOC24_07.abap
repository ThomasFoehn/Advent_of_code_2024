CLASS zcl_tc53_aoc24_07 DEFINITION
  PUBLIC
  INHERITING FROM zcl_tc53_aoc24_utils
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: process REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA combinations TYPE TABLE OF string.
    DATA data_found TYPE abap_bool.
    METHODS determine_combinations_part1 IMPORTING length TYPE i.
    METHODS determine_combinations_part2 IMPORTING length TYPE i.
    METHODS make_the_maths  IMPORTING upper_index   TYPE i
                                      numbers       TYPE string_table
                            RETURNING VALUE(result) TYPE int8.
    METHODS calc      IMPORTING result_input  TYPE string
                                 numbers       TYPE string_table
                       RETURNING VALUE(result) TYPE int8.

ENDCLASS.

CLASS zcl_tc53_aoc24_07 IMPLEMENTATION.
  METHOD process.
    DO.
      data_found = abap_false.
      TRY.
          DATA(line) = file_handler->get_next_line( ).
          SPLIT line AT ':' INTO DATA(result) DATA(values).
          SHIFT values LEFT DELETING LEADING space.
          SPLIT values AT space INTO TABLE DATA(numbers).
          determine_combinations_part1( lines( numbers ) - 1 ).
          part1 = part1 + calc( result_input = result  numbers = numbers ).
          IF data_found = abap_false.
            determine_combinations_part2( lines( numbers ) - 1 ).
            part2 = part2 + calc( result_input = result  numbers = numbers ).
          ENDIF.
        CATCH zcx_tc53_aoc24_eof.
          EXIT.
      ENDTRY.
    ENDDO.
    part2 = part2 + part1.
  ENDMETHOD.


  METHOD determine_combinations_part1.
    DATA: combination TYPE c LENGTH 20,
          index       TYPE i.

    CLEAR me->combinations.
    " Initiale Kombination mit iv_length Zeichen
    combination = '+'.
    DO length - 1 TIMES.
      CONCATENATE combination '+' INTO combination.
    ENDDO.

    " Generiere alle Kombinationen
    DO 2 ** ( length ) TIMES.
      APPEND combination TO me->combinations.

      " Erhöhe die Kombination
      index = length - 1.
      WHILE index > -1.
        IF combination+index(1) = '+'.
          combination+index(1) = '*'.
          EXIT.
        ELSE.
          combination+index(1) = '+'.
          index = index - 1.
        ENDIF.
      ENDWHILE.
    ENDDO.
  ENDMETHOD.

  METHOD determine_combinations_part2.
    DATA: combination TYPE c LENGTH 20,
          index       TYPE i.

    CLEAR me->combinations.
    " Initiale Kombination mit iv_length Zeichen
    combination = '+'.
    DO length - 1 TIMES.
      CONCATENATE combination '+' INTO combination.
    ENDDO.

    " Generiere alle Kombinationen
    DO 3 ** ( length ) TIMES.
      APPEND combination TO me->combinations.

      " Erhöhe die Kombination
      index = length - 1.
      WHILE index > -1.
        CASE combination+index(1).
          WHEN '+'.
            combination+index(1) = '*'.
            EXIT.
          WHEN '*'.
            combination+index(1) = '-'.
            EXIT.
          WHEN '-'.
            combination+index(1) = '+'.
            index = index - 1.
          WHEN OTHERS.
            EXIT.
        ENDCASE.
      ENDWHILE.
    ENDDO.
  ENDMETHOD.

  METHOD make_the_maths.
    DO lines( numbers ) - 1 TIMES.
      IF sy-index = 1.
        IF substring( val = me->combinations[ upper_index ] off = sy-index - 1 len = 1 ) = '+'.
          result  = numbers[ sy-index ] + numbers[ sy-index + 1 ].
        ENDIF.
        IF substring( val = me->combinations[ upper_index ] off = sy-index - 1 len = 1 ) = '*'.
          result = numbers[ sy-index ] * numbers[ sy-index + 1 ].
        ENDIF.
        IF substring( val = me->combinations[ upper_index ] off = sy-index - 1 len = 1 ) = '-'.
          result = |{ numbers[ sy-index ] }{ numbers[ sy-index + 1 ] }|.
        ENDIF.
      ELSE.
        IF substring( val = me->combinations[ upper_index ] off = sy-index - 1 len = 1 ) = '+'.
          result = result + numbers[ sy-index + 1 ].
        ENDIF.
        IF substring( val = me->combinations[ upper_index ] off = sy-index - 1 len = 1 ) = '*'.
          result = result * numbers[ sy-index + 1 ].
        ENDIF.
        IF substring( val = me->combinations[ upper_index ] off = sy-index - 1 len = 1 ) = '-'.
          result = |{ result }{ numbers[ sy-index + 1 ] }|.
        ENDIF.
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD calc.
    DATA upper_index TYPE i.
    DO  lines( me->combinations ) TIMES.
      upper_index = sy-index.
      DATA(res) =  make_the_maths( upper_index = upper_index  numbers = numbers ).
      IF res = result_input.
        ADD result_input TO result.
        data_found = abap_true.
        EXIT.
      ENDIF.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
