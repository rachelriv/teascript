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

  describe 'Extracting String Literals', ->

    describe '#extractedStringLiteralToken', ->

      context 'when the next token is a string without a defined ending', ->
        lineScanner = new LineScanner '\'this is a multiline string without a
                                       defined ending', exampleScanningState
        result = lineScanner.extractedStringLiteralToken()

        it 'sets the current state of the mulitline string of the scanner to be
            true', ->
          expect(lineScanner.currentScanningState.multiline.string).to.be.true

        it 'increments the scanner position to the end of the line', ->
          expect(lineScanner.position).to.equal 52

        it 'does not add any tokens yet to the line tokens', ->
          expect(lineScanner.lineTokens).to.eql []

        it 'returns true since part of a multiline string was extracted', ->
          expect(result).to.be.true

      context 'when the scanner is in the middle of a multiline string', ->
        currentScannerState =
          lineNumber: 1
          multiline:
            string: true
          string:
            doubleQuote: false
        lineScanner = new LineScanner 'this is the continuation of a multiline
                                       string begun elsewhere \''
                                      , currentScannerState
        result = lineScanner.extractedStringLiteralToken()

        it 'toggles the current state of the multiline string of the
            scanner back to false', ->
          expect(lineScanner.currentScanningState.multiline.string).to.be.false

        it 'increments the scanner position to the end of the string', ->
          expect(lineScanner.position).to.equal 64

        it 'adds the string token to the line tokens', ->
          expect(lineScanner.lineTokens).to
            .eql [{
              start: 0,
              kind: 'STRLIT',
              lineNumber: 1,
              lexeme: 'this is the continuation of a multiline string begun
                       elsewhere \''
            }]

        it 'returns true since part of a multiline string was extracted', ->
          expect(result).to.be.true

      context 'when there is a multiline string with a defined ending', ->
        exampleScanningState =
          lineNumber: 1
          multiline:
            comment: false
            string: false
          string:
            doubleQuote: false
        lineScanner = new LineScanner '\'this is a multiline string with
                                       a defined ending \'f := 5', exampleScanningState
        result = lineScanner.extractedStringLiteralToken()

        it 'toggles the current state of the multiline string of the scanner
            back to false', ->
          expect(lineScanner.currentScanningState.multiline.string).to.be.false

        it 'increments the scanner position to just after the string', ->
          expect(lineScanner.position).to.equal 51

        it 'adds the string literal to the line tokens', ->
          expect(lineScanner.lineTokens).to
            .eql [{
                start: 0,
                kind: 'STRLIT',
                lineNumber: 1,
                lexeme: '\'this is a multiline string with a defined ending \''
              }]

        it 'returns true since part of a multiline string was extracted', ->
          expect(result).to.be.true

      context 'when there is a multiline string that begins with double quotes
              and "ends" with single', ->
        exampleScanningState =
          lineNumber: 1
          multiline:
            comment: false
            string: false
          string:
            doubleQuote: false
        lineScanner = new LineScanner '"this is a string that begins with double
                                       quotes and ends with single\'', exampleScanningState
        res = lineScanner.extractedStringLiteralToken()
        it "doesn't toggle the current state of the multiline string of the
            scanner back to false", ->
          expect(lineScanner.currentScanningState.multiline.string).to.be.true

        it 'is in the double quote state', ->
          expect(lineScanner.currentScanningState.string.doubleQuote).to.be.true

       context 'when there is a multiline string that begins with single quotes
                and "ends" with double', ->
        exampleScanningState =
          lineNumber: 1
          multiline:
            comment: false
            string: false
          string:
            doubleQuote: false
               
        lineScanner = new LineScanner '\'this is a string that begins with
                                       single quotes and ends with double"', exampleScanningState
        res = lineScanner.extractedStringLiteralToken()
        it "doesn't toggle the current state of the multiline string of the
            scanner back to false", ->
          expect(lineScanner.currentScanningState.multiline.string).to.be.true

        it 'is in the double quote state', ->
          expect(lineScanner.currentScanningState.string.doubleQuote).to.be.false

      context 'when a double quoted string contains single quotes', ->
        exampleScanningState =
          lineNumber: 1
          multiline:
            comment: false
            string: false
          string:
            doubleQuote: false
        lineScanner = new LineScanner '"I contain \'single\' quotes!"', exampleScanningState
        res = lineScanner.extractedStringLiteralToken()
        it 'scans correctly', ->
          expect(lineScanner.lineTokens).to
            .eql [{
              start: 0,
              kind: 'STRLIT',
              lineNumber: 1,
              lexeme: '"I contain \'single\' quotes!"'
            }]

      context 'when a single quoted string contains double quotes', ->
        exampleScanningState =
          lineNumber: 1
          multiline:
            comment: false
            string: false
          string:
            doubleQuote: false
        lineScanner = new LineScanner "'I contain \"double\" quotes!'", exampleScanningState
        res = lineScanner.extractedStringLiteralToken()
        it 'scans correctly', ->
          expect(lineScanner.lineTokens).to
            .eql [{
              start: 0,
              kind: 'STRLIT',
              lineNumber: 1,
              lexeme: "'I contain \"double\" quotes!'"
            }]

            
