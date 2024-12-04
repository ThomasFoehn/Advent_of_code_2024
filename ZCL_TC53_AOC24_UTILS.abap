CLASS zcl_tc53_aoc24_utils DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING day  TYPE i
                                  test TYPE abap_bool.
    METHODS process    ABSTRACT    EXPORTING part1 TYPE i
                                             part2 TYPE i .

  PROTECTED SECTION.
    DATA file_handler TYPE REF TO zcl_tc53_aoc24_file_handler.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_tc53_aoc24_utils IMPLEMENTATION.

  METHOD constructor.

    me->file_handler = NEW #( COND #( WHEN day < 10
                                      THEN COND #( WHEN test IS INITIAL
                                                   THEN |/transfer/aoc24_0{ day }.txt|
                                                   ELSE |/transfer/aoc24_0{ day }_test.txt| )
                                      ELSE COND #( WHEN test IS INITIAL
                                                   THEN |/transfer/aoc24_{ day }.txt|
                                                   ELSE |/transfer/aoc24_{ day }_test.txt| ) )  ).
  ENDMETHOD.

ENDCLASS.
