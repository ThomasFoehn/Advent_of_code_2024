CLASS zcl_tc53_aoc24_06 DEFINITION
  PUBLIC
  INHERITING FROM zcl_tc53_aoc24_utils
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES ty_char130 TYPE c LENGTH 130.
    TYPES ty_char130tab TYPE STANDARD TABLE OF ty_char130 WITH EMPTY KEY.
    METHODS: process REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_position,
             line   TYPE i,
             offset TYPE i,
           END OF ty_position.

    DATA map TYPE STANDARD TABLE OF ty_char130 WITH EMPTY KEY.
    DATA direction TYPE c VALUE 'U'.

    METHODS up IMPORTING line          TYPE i
                         offset        TYPE i
               RETURNING VALUE(result) TYPE ty_position.

    METHODS down IMPORTING line          TYPE i
                           offset        TYPE i
                 RETURNING VALUE(result) TYPE ty_position.

    METHODS left IMPORTING line          TYPE i
                           offset        TYPE i
                 RETURNING VALUE(result) TYPE ty_position.

    METHODS right IMPORTING line          TYPE i
                            offset        TYPE i
                  RETURNING VALUE(result) TYPE ty_position.

    METHODS mark_position IMPORTING line   TYPE i
                                    offset TYPE i.
    METHODS check_obstacle IMPORTING position_new  TYPE ty_position
                           RETURNING VALUE(result) TYPE abap_bool.

    METHODS next_position IMPORTING turn          TYPE abap_bool
                                    position      TYPE ty_position
                          RETURNING VALUE(result) TYPE ty_position.
    METHODS walk IMPORTING start TYPE ty_position.
    METHODS get_max
      RETURNING VALUE(result) TYPE i.
ENDCLASS.



CLASS zcl_tc53_aoc24_06 IMPLEMENTATION.

  METHOD process.
*** ONLY PART 1 *******
    me->map = file_handler->get_all_table( ).
    FIND '^' IN TABLE map
    RESULTS DATA(result).
    mark_position( EXPORTING line = result-line  offset = result-offset ).
    walk( start = VALUE #( line = result-line  offset = result-offset ) ).
    FIND ALL OCCURRENCES OF 'X' IN TABLE map RESULTS DATA(count).
*** The last step is not count, therefore +1
    part1 = lines( count ) + 1.
  ENDMETHOD.

  METHOD down.
    result-line = line + 1.
    result-offset = offset.
    me->direction = 'D'.
  ENDMETHOD.

  METHOD left.
    result-line = line.
    result-offset = offset - 1.
    me->direction = 'L'.
  ENDMETHOD.

  METHOD right.
    result-line = line.
    result-offset = offset + 1.
    me->direction = 'R'.
  ENDMETHOD.

  METHOD up.
    result-line = line - 1.
    result-offset = offset.
    me->direction = 'U'.
  ENDMETHOD.

  METHOD mark_position.
    FIELD-SYMBOLS <fs> TYPE ty_char130.

    ASSIGN me->map[ line ] TO <fs>.
    <fs>+offset(1) = 'X'.
  ENDMETHOD.

  METHOD check_obstacle.
    FIELD-SYMBOLS <fs> TYPE ty_char130.
    ASSIGN me->map[ position_new-line ] TO <fs>.
    result = COND #( WHEN <fs>+position_new-offset(1) = '#'
                     THEN abap_true
                     ELSE abap_false ) .
  ENDMETHOD.


  METHOD walk.
    DATA pos TYPE ty_position.
    DATA obstacle TYPE abap_bool.
    pos = start.
    DO.
      pos = next_position( turn =  obstacle position = pos ).
      DATA(check_pos) = next_position( turn = abap_false  position = pos  ).
      IF pos-line > get_max( ) OR pos-line < 1 OR pos-offset < 0 OR pos-offset > get_max( ) OR
         check_pos-line > get_max( ) OR check_pos-line < 1 OR check_pos-offset < 0 OR check_pos-offset > get_max( ).
        EXIT.
      ENDIF.
      mark_position(  line = pos-line offset =  pos-offset ).
      obstacle = check_obstacle( position_new = check_pos ).
    ENDDO.

  ENDMETHOD.

  METHOD next_position.
    IF turn = abap_true.
      result = SWITCH #( me->direction
                         WHEN 'U' THEN right( line = position-line offset = position-offset )
                         WHEN 'R' THEN down( line = position-line offset = position-offset )
                         WHEN 'D' THEN left( line = position-line offset = position-offset )
                         WHEN 'L' THEN up( line = position-line offset = position-offset ) ).
    ELSE.
      result = SWITCH #( me->direction
                         WHEN 'U' THEN up( line = position-line offset = position-offset )
                         WHEN 'R' THEN right( line = position-line offset = position-offset )
                         WHEN 'D' THEN down( line = position-line offset = position-offset )
                         WHEN 'L' THEN left( line = position-line offset = position-offset ) ).
    ENDIF.
  ENDMETHOD.


  METHOD get_max.
    result = COND #( WHEN test = abap_true
                        THEN 10
                        ELSE 130 ).

  ENDMETHOD.

ENDCLASS.
