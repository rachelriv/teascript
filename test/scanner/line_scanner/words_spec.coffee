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

  describe 'Extracting Words', ->

    describe '#extractedWordToken', ->

      context 'when a reserved word is the next token', ->
        lineScanner = new LineScanner 'true =', exampleScanningState
        extractionResult = lineScanner.extractedWordToken()

        it 'accurately increments the current position of the scanner', ->
          expect(lineScanner.position).to.equal 4

        it 'adds the reserved word to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql [{
            kind: 'true',
            lexeme: 'true',
            lineNumber: 1,
            start: 0
          }]

        it 'returns true since it was successful in extracting a word', ->
          expect(extractionResult).to.be.true

      context 'when an identifer is the next token', ->
        lineScanner = new LineScanner 'myVariable := () ->', exampleScanningState
        extractionResult = lineScanner.extractedWordToken()

        it 'accurately increments the current position of the scanner', ->
          expect(lineScanner.position).to.equal 10

        it 'adds the identifer to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql [{
            kind: 'ID',
            lexeme: 'myVariable',
            lineNumber: 1,
            start: 0
          }]

        it 'returns true since it was successful in extracting a word', ->
          expect(extractionResult).to.be.true

      context 'when a word is not the next token', ->
        lineScanner = new LineScanner '* 5', exampleScanningState
        extractionResult = lineScanner.extractedWordToken()

        it 'does not increment the current position of the scanner', ->
          expect(lineScanner.position).to.equal 0

        it 'does not add anything to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql []

        it 'returns false since it could not extract a word', ->
          expect(extractionResult).to.be.false

      context 'when an identifier is only one character', ->
        lineScanner = new LineScanner 'x := 123456', exampleScanningState
        extractionResult = lineScanner.extractedWordToken()

        it 'accurately increments the current position of the scanner', ->
          expect(lineScanner.position).to.equal 1

        it 'adds the identifer to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql [{
            kind: 'ID',
            lexeme: 'x',
            lineNumber: 1,
            start: 0
          }]

        it 'returns true since it was successful in extracting a word', ->
          expect(extractionResult).to.be.true

      context 'when an identifier that does not begin with a letter is next', ->
        lineScanner = new LineScanner '5myVar = 1', exampleScanningState
        extractionResult = lineScanner.extractedWordToken()

        it 'does not increment the current position of the scanner', ->
          expect(lineScanner.position).to.equal 0

        it 'does not add anything to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql []

        it 'returns false since it could not extract a word', ->
          expect(extractionResult).to.be.false
