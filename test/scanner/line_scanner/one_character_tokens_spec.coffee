chai = require 'chai'
expect = chai.expect
LineScanner = require '../../../scanner/line_scanner'

describe 'LineScanner', ->
  exampleScanningState = 
    lineNumber: 1
    multiline:
      comment: false
      string: false
    string:
      doubleQuote: false
  
  describe 'Extracting One-Character Tokens', ->

    describe '#extractedOneCharacterToken', ->

      context 'when a one-character token is the next token', ->
        lineScanner = new LineScanner '*5', exampleScanningState
        extractionResult = lineScanner.extractedOneCharacterToken()

        it 'accurately increments the current position of the scanner', ->
          expect(lineScanner.position).to.equal 1

        it 'adds the one-character token to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql [{
            kind: '*',
            lexeme: '*',
            lineNumber: 1,
            start: 0
          }]

        it 'returns true since a one-character token was successfully
            extracted', ->
          expect(extractionResult).to.be.true

      context 'when a one-character token is not the next token', ->
        lineScanner = new LineScanner ' x', exampleScanningState
        extractionResult = lineScanner.extractedOneCharacterToken()

        it 'does not increment the current position of the scanner', ->
          expect(lineScanner.position).to.equal 0

        it 'does not add anything to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql []

        it 'returns false since a one-character token was not extracted', ->
          expect(extractionResult).to.be.false
