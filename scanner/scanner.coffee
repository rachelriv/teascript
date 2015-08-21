fs          = require 'fs'
LineScanner = require './line_scanner'
ScanError   = require '../error/scan_error'

getInitialScanningState = ->
  lineNumber: 1
  multiline:
    comment: false
    string: false
  string:
    doubleQuote: false


module.exports = (filePath) ->
  tokens = []
  errors = []
  currentState = getInitialScanningState()
  sourceCodeLines = fs.readFileSync(filePath, {encoding: 'utf8'}).split '\n'

  for sourceCodeLine in sourceCodeLines
    lineScanner = new LineScanner sourceCodeLine, currentState
    {lineErrors, lineTokens, currentState} = lineScanner.scan()
    currentState.lineNumber++
    tokens.push.apply tokens, lineTokens
    errors.push.apply errors, lineErrors

  tokens.push {kind: 'EOF', lexeme: 'EOF', start: 0}  
  throw new ScanError errors if errors.length > 0
  tokens

