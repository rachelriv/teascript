class TupleLiteral

  constructor: (@elements) ->

  toString: ->
    "|#{@elements.join(', ')}|"

  analyze: (context) ->
    #TODO

  optimize: ->
    #TODO

module.exports = TupleLiteral
