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

  describe 'Extracting Numeric Literals', ->

    describe '#extractedNumericLiteralToken', ->


      context 'when a integer literal is the next token', ->
        lineScanner = new LineScanner '23456', exampleScanningState
        extractionResult = lineScanner.extractedNumericLiteralToken()

        it 'accurately increments the current position of the scanner', ->
          expect(lineScanner.position).to.equal 5

        it 'adds the integer literal to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql [{
            kind: 'INTLIT',
            lexeme: '23456',
            lineNumber: 1,            
            start: 0
          }]

        it 'returns true since a numeric literal was extracted', ->
          expect(extractionResult).to.be.true

      context 'when two numeric literals are separated
               by something other than a period', ->
        lineScanner = new LineScanner '234k567', exampleScanningState
        extractionResult = lineScanner.extractedNumericLiteralToken()

        it 'accurately increments the current position of the scanner', ->
          expect(lineScanner.position).to.equal 3

        it 'adds the integer literal to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql [{
              kind: 'INTLIT',
              lexeme: '234',
              lineNumber: 1,
              start: 0}]

        it 'returns true since a numeric literal was extracted', ->
          expect(extractionResult).to.be.true

      context 'when a float literal is the next token', ->
        lineScanner = new LineScanner '123.456', exampleScanningState
        extractionResult = lineScanner.extractedNumericLiteralToken()

        it 'accurately increments the current position of the scanner', ->
          expect(lineScanner.position).to.equal 7

        it 'adds the integer literal to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql [{
            kind: 'FLOATLIT',
            lexeme: '123.456',
            lineNumber: 1,
            start: 0
          }]

        it 'returns true since a numeric literal was extracted', ->
          expect(extractionResult).to.be.true

      context 'when a float is in scientific notation', ->
        lineScanner = new LineScanner '1.2E-123', exampleScanningState
        extractionResult = lineScanner.extractedNumericLiteralToken()

        it 'accurately increments the current position of the scanner', ->
          expect(lineScanner.position).to.equal 8

        it 'recognizes it as a float', ->
          expect(lineScanner.lineTokens[0].kind).to.equal 'FLOATLIT'

        it 'adds the integer literal to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql [{
            kind: 'FLOATLIT',
            lexeme: '1.2E-123',
            lineNumber: 1,
            start: 0
          }]

        it 'returns true since a numeric literal was extracted', ->
          expect(extractionResult).to.be.true

      context 'when an integer is in scientific notation', ->
        lineScanner = new LineScanner '10E123', exampleScanningState
        extractionResult = lineScanner.extractedNumericLiteralToken()

        it 'accurately increments the current position of the scanner', ->
          expect(lineScanner.position).to.equal 6

        it 'recognizes it as a float', ->
          expect(lineScanner.lineTokens[0].kind).to.equal 'FLOATLIT'

        it 'adds the float literal to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql [{
            kind: 'FLOATLIT',
            lexeme: '10E123',
            lineNumber: 1,
            start: 0
          }]

        it 'returns true since a numeric literal was extracted', ->
          expect(extractionResult).to.be.true

      context 'when numbers followed by a period is
               the next sequence of characters', ->
        lineScanner = new LineScanner '123.', exampleScanningState
        extractionResult = lineScanner.extractedNumericLiteralToken()

        it 'reads the input as a INTLIT (followed by a period operator)
            rather than a FLOATLIT', ->
          expect(lineScanner.lineTokens).to.eql [{
              kind: 'INTLIT',
              lexeme: '123',
              lineNumber: 1,
              start:0
          }]

      context 'when a numeric literal is not the next token', ->
        lineScanner = new LineScanner 'abc.1234', exampleScanningState
        extractionResult = lineScanner.extractedNumericLiteralToken()

        it 'does not increment the current position of the scanner', ->
          expect(lineScanner.position).to.equal 0

        it 'does not add anything to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql []

        it 'returns false since no numeric literal was extracted', ->
          expect(extractionResult).to.be.false
