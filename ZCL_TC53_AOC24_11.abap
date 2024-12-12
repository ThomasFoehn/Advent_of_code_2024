CLASS zcl_tc53_aoc24_11 DEFINITION
  PUBLIC
  INHERITING FROM zcl_tc53_aoc24_utils
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: process REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_tc53_aoc24_11 IMPLEMENTATION.
  METHOD process.
    DATA add TYPE i.
    DATA(stream) = file_handler->get_stream( ).
    SPLIT stream AT space INTO TABLE DATA(input).
    DO 25 TIMES.
*Part 2: change Loop to 75. But it runs long and very memory consuming
      DO lines( input ) TIMES.
        ASSIGN input[ sy-index + add ] TO FIELD-SYMBOL(<value>).
        IF <value> = 0.
          <value> = '1'.
        ELSE.
          IF strlen( <value> ) MOD 2 = 0.
            DATA(half) = strlen( <value> ) / 2.
            DATA(new) = substring( val = <value> off = half len = half ).
            SHIFT new LEFT DELETING LEADING '0'.
            IF new <> space.
              IF sy-index < lines( input ).
                INSERT new INTO input INDEX sy-index + 1 + add.
                ADD 1 TO add.
              ELSE.
                APPEND new TO input.
              ENDIF.
            ELSE.
              IF sy-index < lines( input ).
                INSERT '0' INTO input INDEX sy-index + 1 + add.
                ADD 1 TO add.
              ELSE.
                APPEND '0' TO input.
              ENDIF.
            ENDIF.
            <value> = substring( val = <value> off = 0 len = half ).
          ELSE.
            <value> = <value> * 2024.
            SPLIT <value> AT '.' INTO <value> DATA(rest).
          ENDIF.
        ENDIF.
      ENDDO.
      add = 0.
    ENDDO.
    part1 = lines( input ).
  ENDMETHOD.

ENDCLASS.
