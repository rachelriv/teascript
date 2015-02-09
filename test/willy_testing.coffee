chai = require 'chai'
sinonChai = require 'sinon-chai'
expect = chai.expect
chai.use(sinonChai)
Scanner = require '../scanner'
MyTokens = require './MyTokens'


describe 'FileScanner', ->
  describe '#test1', ->
    context 'when the file has correctly scanned tokens', ->
      myTokens = MyTokens.tokens1()
      scanned = Scanner 'scanner_test_willy_1.txt', (tokens) -> console.log tokens # But don't log

      it 'returns the appropriate tokens', ->
        console.log myTokens
        console.log scanned
        expect(scanned).to.eql myTokens