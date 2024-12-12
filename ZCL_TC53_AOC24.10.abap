CLASS zcl_tc53_aoc24_10 DEFINITION
  PUBLIC
  INHERITING FROM zcl_tc53_aoc24_utils
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: process REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES ty_char130 TYPE c LENGTH 50.
    TYPES ty_position_table TYPE TABLE OF zcl_tc53_aoc24_position_mover=>ty_position WITH EMPTY KEY.
    DATA start_pos TYPE zcl_tc53_aoc24_position_mover=>ty_position.
    DATA score TYPE i.
    DATA map TYPE STANDARD TABLE OF ty_char130 WITH EMPTY KEY.
    METHODS next_steps      IMPORTING position      TYPE zcl_tc53_aoc24_position_mover=>ty_position
                            RETURNING VALUE(result) TYPE ty_position_table.
    METHODS next      IMPORTING step          TYPE zcl_tc53_aoc24_position_mover=>ty_position
                                value         TYPE i
                      RETURNING VALUE(result) TYPE i.

ENDCLASS.

CLASS zcl_tc53_aoc24_10 IMPLEMENTATION.
  METHOD process.
    map = file_handler->get_all_table( ).
    FIND ALL OCCURRENCES OF '0' IN TABLE map RESULTS DATA(trailheads).
    LOOP AT trailheads INTO DATA(trailhead).
      REPLACE ALL OCCURRENCES OF 'X' IN TABLE map WITH '9'.
      start_pos = VALUE #( line = trailhead-line offset = trailhead-offset ).
      LOOP AT next_steps( start_pos ) INTO DATA(around).
        TRY.
            IF substring( val = map[ around-line ] off = around-offset len = 1 ) = 1.
              score = score + next( step = around value = 2 ).
            ENDIF.
          CATCH cx_sy_itab_line_not_found cx_sy_range_out_of_bounds.
        ENDTRY.
      ENDLOOP.
    ENDLOOP.
    part1 = score.
  ENDMETHOD.

  METHOD next_steps.
    APPEND position_mover->up( line = position-line offset = position-offset ) TO result.
    APPEND position_mover->right( line = position-line offset = position-offset ) TO result.
    APPEND position_mover->left( line = position-line offset = position-offset ) TO result.
    APPEND position_mover->down( line = position-line offset = position-offset ) TO result.
  ENDMETHOD.


  METHOD next.
    FIELD-SYMBOLS <fs> TYPE ty_char130.
    DATA(steps) = next_steps( step ).
    LOOP AT steps INTO DATA(next_step).
      TRY.
          IF substring( val = map[ next_step-line ] off = next_step-offset len = 1 ) = value.
            IF value < 9.
              result = result + next( step = next_step value = value + 1 ).
            ELSE.
**** ACTIVATE This to get solution of solution1
*              ASSIGN me->map[ next_step-line ] TO <fs>.
*              <fs>+next_step-offset(1) = 'X'.
**** ACTIVATE This to get solution of solution1
              ADD 1 TO result.
            ENDIF.
          ENDIF.
        CATCH cx_sy_itab_line_not_found cx_sy_range_out_of_bounds.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
