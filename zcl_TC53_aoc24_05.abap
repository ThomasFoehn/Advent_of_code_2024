CLASS zcl_tc53_aoc24_05 DEFINITION
  PUBLIC
  INHERITING FROM zcl_tc53_aoc24_utils
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: process REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_rule,
             before TYPE i,
             after  TYPE i,
           END OF ty_rule.
    DATA rules TYPE STANDARD TABLE OF ty_rule WITH EMPTY KEY.
    METHODS read_rules.
    METHODS sum_middle      IMPORTING linevalues    TYPE string_table
                            RETURNING VALUE(result) TYPE i.

    METHODS check_with_index      IMPORTING linevalues    TYPE string_table
                                  RETURNING VALUE(result) TYPE i.

    METHODS corrected_sum_middle      IMPORTING linevalues    TYPE string_table
                                      RETURNING VALUE(result) TYPE  i.
ENDCLASS.

CLASS zcl_tc53_aoc24_05 IMPLEMENTATION.
  METHOD process.

    read_rules( ).
    DO.
      TRY.
          DATA(line) = file_handler->get_next_line( ).
          SPLIT line AT ',' INTO TABLE DATA(linevalues).
          IF check_with_index( linevalues ) is INITIAL.
            part1 = part1 + sum_middle( linevalues ).
          ELSE.
            part2 = part2 + corrected_sum_middle( linevalues ).
          ENDIF.
        CATCH zcx_tc53_aoc24_eof.
          EXIT.
      ENDTRY.
    ENDDO.

  ENDMETHOD.

  METHOD read_rules.
    DATA rule_split TYPE ty_rule.
    DATA(rules_input) = NEW zcl_tc53_aoc24_file_handler( COND #(  WHEN test IS INITIAL
                                                          THEN |/transfer/aoc24_05_rules.txt|
                                                          ELSE |/transfer/aoc24_05_rules_test.txt| ) )->get_all_table( ).
    LOOP AT rules_input INTO DATA(rule).
      SPLIT rule AT '|' INTO  DATA(split1) DATA(split2).
      rule_split-before = split1.
      rule_split-after = split2.
      APPEND rule_split TO me->rules.
    ENDLOOP.
  ENDMETHOD.

  METHOD sum_middle.
    result = linevalues[ lines( linevalues ) / 2 ].
  ENDMETHOD.

  METHOD corrected_sum_middle.
    DATA input TYPE string_table.
    input = linevalues.
* Switch values
    DO.
      DATA(index) = check_with_index( input ).
      IF index IS INITIAL.
        result = sum_middle( input  ).
        EXIT.
      ENDIF.
      DATA(hlp) = input[ index ].
      input[ index ] = input[ index + 1 ].
      input[ index + 1 ] = hlp.
    ENDDO.
  ENDMETHOD.

  METHOD check_with_index.
    result = 0.
    DO lines( linevalues ) - 1 TIMES.
      DATA(index_before) = sy-index.
      DO lines( linevalues ) - index_before TIMES.
        IF line_exists( me->rules[ before = linevalues[ index_before + 1 ]  after = linevalues[ index_before ] ] ).
          result = index_before.
          EXIT.
        ENDIF.
      ENDDO.
    ENDDO.
  ENDMETHOD.

ENDCLASS.
