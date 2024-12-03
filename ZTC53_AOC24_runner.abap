*&---------------------------------------------------------------------*
*& Report ztc53_aoc24_runner
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztc53_aoc24_runner.

PARAMETERS: day TYPE i.
PARAMETERS: test TYPE c AS CHECKBOX DEFAULT 'X'.

START-OF-SELECTION.
  IF test IS INITIAL.
    DATA(input) = COND #( WHEN day < 10
                         THEN |/transfer/aoc24_0{ day }.txt|
                         ELSE |/transfer/aoc24_{ day }.txt| ).

  ELSE.
    input = COND #( WHEN day < 10
                         THEN |/transfer/aoc24_0{ day }_test.txt|
                         ELSE |/transfer/aoc24_{ day }_test.txt| ).
  ENDIF.

  DATA(solution_classname) = COND #( WHEN day < 10
                                     THEN |ZCL_TC53_AOC24_0{ day }|
                                     ELSE |ZCL_TC53_AOC24_{ day }| ).


  DATA solution_class TYPE REF TO object.
  DATA: part1 TYPE i, part2 TYPE i.
  CREATE OBJECT solution_class TYPE (solution_classname).
  CALL METHOD solution_class->('PROCESS')
    EXPORTING
      filename = input
    IMPORTING
      part1    = part1
      part2    = part2.

  WRITE: / 'Part1:', part1.
  WRITE: / 'Part2:', part2.