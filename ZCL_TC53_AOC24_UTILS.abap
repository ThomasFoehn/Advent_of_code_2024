CLASS zcl_tc53_aoc24_utils DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING filename TYPE string.
    METHODS process        EXPORTING part1 TYPE i
                                     part2 TYPE i.

  PROTECTED SECTION.
    DATA file_handler TYPE REF TO zcl_tc53_aoc24_file_handler.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_tc53_aoc24_utils IMPLEMENTATION.

  METHOD constructor.
    me->file_handler = NEW #( filename ).
  ENDMETHOD.

  METHOD process.

  ENDMETHOD.

ENDCLASS.