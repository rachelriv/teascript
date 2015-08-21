sinon = require 'sinon'
chai = require 'chai'
sinonChai = require 'sinon-chai'
expect = chai.expect
chai.use(sinonChai)
LineScanner = require '../../../scanner/line_scanner'
scan = require '../../../scanner/scan'

describe 'LineScanner', ->
  
  exampleScanningState = 
    lineNumber: 1
    multiline:
      comment: false
      string: false
    string:
      doubleQuote: false

  describe 'general scanning', ->

    describe '#scan', ->

      context 'when the line has valid teascript tokens', ->
        lineScanner = new LineScanner "f :=  -> 'hello' a.move() true # comment", exampleScanningState
        {lineTokens} = lineScanner.scan()

        it 'returns the appropriate tokens', ->
          expect(lineTokens).to.eql [
            {kind: 'ID', lexeme: 'f', lineNumber: 1, start: 0},
            {kind: ':=', lexeme: ':=', lineNumber: 1, start: 2},
            {kind: '->', lexeme: '->', lineNumber: 1, start: 6},
            {kind: 'STRLIT', lexeme: "'hello'", lineNumber: 1, start: 9},
            {kind: 'ID', lexeme: 'a', lineNumber: 1, start: 17},
            {kind: '.', lexeme: '.', lineNumber: 1, start: 18},
            {kind: 'ID', lexeme: 'move', lineNumber: 1, start: 19},
            {kind: '(', lexeme: '(', lineNumber: 1, start: 23},
            {kind: ')', lexeme: ')', lineNumber: 1, start: 24},
            {kind: 'true', lexeme: 'true', lineNumber: 1, start: 26},
            {kind: 'newline', lexeme: 'newline', lineNumber: 1, start: 27}
          ]

      context 'when the line is empty', ->
        lineScanner = new LineScanner '', exampleScanningState
        lineScanner.skippedSpaces = sinon.stub()
        lineScanner.skippedMultiComments = sinon.stub()
        lineScanner.skippedSingleComments = sinon.stub()
        lineScanner.extractedTwoCharacterToken = sinon.stub()
        lineScanner.extractedOneCharacterToken = sinon.stub()
        lineScanner.extractedWordToken = sinon.stub()
        lineScanner.extractedNumericLiteralToken = sinon.stub()
        result = lineScanner.scan()

        it 'returns without trying to extract any tokens/skip any characters', ->
          expect(lineScanner.skippedSpaces).to.not.have.been.called
          expect(lineScanner.skippedMultiComments).to.not.have.been.called
          expect(lineScanner.skippedSingleComments).to.not.have.been.called
          expect(lineScanner.extractedTwoCharacterToken).to.not.have.been.called
          expect(lineScanner.extractedOneCharacterToken).to.not.have.been.called
          expect(lineScanner.extractedWordToken).to.not.have.been.called
          expect(lineScanner.extractedNumericLiteralToken).to.not.have.been.called

        it 'returns a result with no line tokens', ->
          expect(result.lineTokens).to.eql []

      context 'when the line is full of spaces', ->
        lineScanner = new LineScanner '                    ', exampleScanningState
        lineScanner.extractedTwoCharacterToken = sinon.stub()
        lineScanner.extractedOneCharacterToken = sinon.stub()
        lineScanner.extractedWordToken = sinon.stub()
        lineScanner.extractedNumericLiteralToken = sinon.stub()
        lineScanner.scan()

        it 'returns without trying to extract any tokens', ->
          expect(lineScanner.extractedTwoCharacterToken).to.not.have.been.called
          expect(lineScanner.extractedOneCharacterToken).to.not.have.been.called
          expect(lineScanner.extractedWordToken).to.not.have.been.called
          expect(lineScanner.extractedNumericLiteralToken).to.not.have.been.called

      context 'when the line is commented out', ->
        lineScanner = new LineScanner '# example commented out line', exampleScanningState
        lineScanner.extractedTwoCharacterToken = sinon.stub()
        lineScanner.extractedOneCharacterToken = sinon.stub()
        lineScanner.extractedWordToken = sinon.stub()
        lineScanner.extractedNumericLiteralToken = sinon.stub()
        lineScanner.scan()

        it 'returns without trying to extract any tokens', ->
          expect(lineScanner.extractedTwoCharacterToken).to.not.have.been.called
          expect(lineScanner.extractedOneCharacterToken).to.not.have.been.called
          expect(lineScanner.extractedWordToken).to.not.have.been.called
          expect(lineScanner.extractedNumericLiteralToken).to.not.have.been.called
