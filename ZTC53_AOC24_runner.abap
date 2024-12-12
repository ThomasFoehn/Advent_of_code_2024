*&---------------------------------------------------------------------*
*& Report ztc53_aoc24_runner
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztc53_aoc24_runner.

PARAMETERS: day TYPE i.
PARAMETERS: test TYPE c AS CHECKBOX DEFAULT 'X'.

DATA solution_class TYPE REF TO object.
DATA: part1 TYPE int8, part2 TYPE int8.

START-OF-SELECTION.

  DATA(solution_classname) = COND #( WHEN day < 10
                                     THEN |ZCL_TC53_AOC24_0{ day }|
                                     ELSE |ZCL_TC53_AOC24_{ day }| ).


  CREATE OBJECT solution_class TYPE (solution_classname) EXPORTING day = day test = test.
  CALL METHOD solution_class->('PROCESS')
    IMPORTING
      part1 = part1
      part2 = part2.

  WRITE: / 'Puzzle1:', part1.
  WRITE: / 'Puzzle2:', part2.
