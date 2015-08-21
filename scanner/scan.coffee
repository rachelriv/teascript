fs          = require 'fs'
LineScanner = require './line_scanner'
ScanError   = require '../error/scan_error'

getInitialScanningState = ->
  lineNumber: 1
  multiline:
    comment: false
    string:  false
  string:
    doubleQuote: false

module.exports = (filePath) ->
  [tokens, errors] = [[], []]
  currentScanningState = getInitialScanningState()
  sourceCodeLines = fs.readFileSync(filePath, {encoding: 'utf8'}).split '\n'

  for line in sourceCodeLines
    lineScanner = new LineScanner line, currentScanningState
    {lineErrors, lineTokens, currentScanningState} = lineScanner.scan()
    currentScanningState.lineNumber++
    tokens.push.apply tokens, lineTokens
    errors.push.apply errors, lineErrors
  
  throw new ScanError errors if errors.length > 0

  tokens.push {kind: 'EOF', lexeme: 'EOF', start: 0}  
  tokens
