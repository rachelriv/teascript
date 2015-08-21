class AnalyzerErrors

  @program01 = 'line 6: Variable x already declared'
  @program02 = 'line 2: * must have integer or float operands (found int and str)'
  @program03 = 'line 7: + must have integer or float operands (found float and str)'
  @program04 = 'line 2: Nested variable declarations not allowed'
  @program05 = 'line 12: Variable z not found'
  @program06 = 'line 1: and must have boolean operands'
  @program07 = 'line 4: isnt must have mutually compatible operands'
  @program08 = 'line 19: Condition in "while" statement must be boolean'
  @program09 = 'line 6: Variable declaration and initialization
                     to an assignment expression not allowed'
  @program10 = 'line 10: Unary - must have integer or float operand'
  @program11 = 'line 10: not must have boolean operand'
  @program12 = 'line 6: .. and ... range operators must have all
                integer operands'
  @program13 = 'line 9: .. and ... range operators must have all
                integer operands'
  @program14 = 'line 3: .. and ... range operators must have all
                integer operands'
  @program15 = 'line 23: cannot [] get item of a int (not iterable)'
  @program16 = 'line 10: str indices must be integers, not float'
  @program17 = 'line 19: Variable c not found'
  @program18 = 'line 12: Duplicate parameter a found in function definition'
  @program19 = 'line 11: field yo not defined in object a'
  @program20 = 'line 18: Variable d not found'
  @program21 = 'line 8: Incompatible types'
  @program22 = 'line 5: Nested variable declarations not allowed'
  @program23 = 'line 30: Object must be iterable'
  @program24 = 'line 11: int is not callable'
  @program25 = 'line 10: f() takes exactly 2 arguments (3 given)'
  @program26 = 'line 10: g() takes exactly 3 arguments (1 given)'
  @program27 = 'line 7: + must have integer or float operands (found int and str)'
  @program28 = 'line 2: * must have integer or float operands (found bool and <arbitrary_type>)'
  @program29 = 'line 6: Duplicate class field b found in class definition'
  @program30 = 'line 18: Incompatible types'
  @program31 = 'line 22: can only access fields of objects (found int)'
  @program32 = 'line 15: field f not defined in object (. (. (. a b) c) d)'


module.exports = AnalyzerErrors