class FloatLiteral

  constructor: (@value) ->

  toString: -> @value.lexeme

  analyze: (context) ->
    #TODO

  optimize: -> this

module.exports = FloatLiteral