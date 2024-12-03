CLASS zcl_tc53_aoc24_utils DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS process        IMPORTING filename TYPE string
                           EXPORTING part1    TYPE i
                                     part2    TYPE i.

  PROTECTED SECTION.
    DATA file_handler TYPE REF TO zcl_tc53_aoc24_file_handler.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_tc53_aoc24_utils IMPLEMENTATION.

  METHOD process.

  ENDMETHOD.

ENDCLASS.