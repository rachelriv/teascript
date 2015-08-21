tokens = require './tokens'
format = require 'string-format'
format.extend String.prototype
CustomError = require '../error/custom_error'

class LineScanner
  constructor: (@line, @currentScanningState) ->
    @start = 0
    @position = 0
    @lineTokens = []
    @lineErrors = []

  scan: ->
    return {@lineErrors, @lineTokens, @currentScanningState} unless @line

    while @position < @line.length
      # continue iterating over the line of characters
      # if we've been able to do one of the following:
      # 1. skip one or more insignificant characters (white space, comment, etc)
      # 2. extract a valid teascript token
      continue if @skippedSpaces()
      continue if @skippedMultiComments()
      continue if @skippedSingleComments()
      continue if @extractedNumericLiteralToken()
      continue if @extractedThreeCharacterToken()
      continue if @extractedTwoCharacterToken()
      continue if @extractedOneCharacterToken()
      continue if @extractedWordToken()
      continue if @extractedStringLiteralToken()

      # return an error otherwise
      @lineErrors.push new CustomError "invalid token at position #{@position}",
                                        @currentScanningState.lineNumber
      return {@lineErrors, @lineTokens, @currentScanningState}

    @addToken {kind: 'newline'} if @lineTokens.length > 0
    {@lineErrors, @lineTokens, @currentScanningState}

  addToken: ({kind, lexeme}) ->
    lexeme ?= kind
    token = {lexeme, kind, @start}
    token.lineNumber = @currentScanningState.lineNumber
    @lineTokens.push token
    @lineTokens

  skippedSpaces: ->
    skippedSpaces = false
    if /\s/.test @line[@position]
      @position++ and @start++ while /\s/.test @line[@position]
      skippedSpaces = true
    skippedSpaces

  skippedSingleComments: ->
    skippedSingleComments = false
    if @line[@position] is '#'
      @position = @line.length
      skippedSingleComments = true
    skippedSingleComments

  skippedMultiComments: ->
    skippedMultiComments = false
    if @currentScanningState.multiline.comment
      @lookForMultiCommentEnd()
      skippedMultiComments = true
    else if @line[@position..@position + 1] is '##'
      @position += 2
      @currentScanningState.multiline.comment = true
      @lookForMultiCommentEnd()
      skippedMultiComments = true
    skippedMultiComments

  lookForMultiCommentEnd: ->
    relativePositionOfTrailingHashes = @line[@position..].indexOf '##'
    if relativePositionOfTrailingHashes >= 0
      # we have found the trailing hashes
      @position += relativePositionOfTrailingHashes + 2
      @currentScanningState.multiline.comment = false
    else
      # no trailing hashes
      @position = @line.length

  extractedThreeCharacterToken: ->
    @start = @position
    if @line[@position...@position + 3] in tokens.threeCharacterTokens
      @addToken {kind: @line[@position...@position + 3]}
      @position += 3
      return true
    return false

  extractedTwoCharacterToken: ->
    @start = @position
    if @line[@position...@position + 2] in tokens.twoCharacterTokens
      @addToken {kind: @line[@position...@position + 2]}
      @position += 2
      return true
    return false

  extractedOneCharacterToken: ->
    @start = @position
    if @line[@position] in tokens.oneCharacterTokens
      @addToken {kind: @line[@position]}
      @position++
      return true
    return false

  extractedStringLiteralToken: ->
    if @currentScanningState.multiline.string
      @extractMultilineString()
      return true
    else if /\"|\'/.test @line[@position]
      @currentScanningState.string.doubleQuote = /\"/.test @line[@position]
      @position++
      # strings multiline by default
      @currentScanningState.multiline.string = true
      @extractMultilineString()
      return true
    else
      return false

  extractMultilineString: ->
    quotes = if @currentScanningState.string.doubleQuote then '"' else "'"


    regexp = '([^{0}\\\\]|\\\\[\'"\\\\rnst])*({0})'.format quotes
    compiledRegexp = new RegExp regexp
    stringGroup = compiledRegexp.exec @line[@position..]

    if stringGroup
      # found trailing quote
      @currentScanningState.multiline.string = false
      @position += stringGroup[0].length
      @addToken {kind: 'STRLIT', lexeme: @line[@start...@position]}
    else
      # no trailing quote found
      @position = @line.length

  extractedWordToken: ->
    @start = @position
    if /[a-zA-Z_]/.test @line[@position]
      @position++ while /\w/.test(@line[@position]) and @position < @line.length
      @addWord @line[@start...@position]
      return true
    return false

  addWord: (word) ->
    if word in tokens.reservedWords
      @addToken {kind: word}
    else
      @addToken {kind: 'ID', lexeme: word}

  extractedNumericLiteralToken: ->
    @start = @position
    if /\d/.test @line[@position]
      numberGroups = /(?:\d+)(?:\.\d+)?(?:E[+-]?(?:\d+)(?:\.\d+)?)?/.exec @line[@position..]
      numLit = numberGroups[0]
      # A number is considered a float if it has a decimal or has an exponent
      kind = if '.' in numLit or 'E' in numLit then 'FLOATLIT' else 'INTLIT'
      @addToken {kind, lexeme: numLit}
      @position += numLit.length
      return true
    return false

module.exports = LineScanner
