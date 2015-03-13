class Tokens

  @oneCharacterTokens = [
    '^', '&', '|',                       # bitwise operators
    '+', '-', '*', '/', '%',             # arithmetic operators
    '(', ')',                            # for tuple construction
    '[', ']',                            # for list construction
    '<', '>',                            # for set construction
    '{', '}',                            # for map construction
    '=',                                 # assignment
    '.',                                 # member access for objects
    ',',                                 # separating args/params
    ':'                                  # start of a block
  ]

  @twoCharacterTokens = [
    '+=', '-=', '*=', '/=',              # mutators
    '**'                                 # exponent
    '<=', '>=',                          # relational operators
    '->',                                # function
    '..',                                # range
    ':='                                 # declaration
  ]

  @reservedWords = [
    'int', 'double', 'bool', 'none',     # primitive types
    'class', 'trait',                    # reference types
    'for', 'in', 'by', 'while', 'end',   # loops/blocks/range keywords
    'and', 'or',                         # logical operators
    'is', 'isnt',                        # relational operators
    'if', 'else',                        # if/then
    'not',                               # negation
    'true', 'false',                     # boolean literals
    'new',                               # instantiate a class/create an object
    'return'                             # we need to return from functions
  ]

module.exports = Tokens
