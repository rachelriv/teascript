chai = require 'chai'
expect = chai.expect
fs = require 'fs'
path = require 'path'
scan = require '../../scanner/scan'
expectedOutputTokens = require "#{__dirname}/expected_output/output_tokens"
expectedErrors = require "#{__dirname}/expected_output/expected_scanner_errors"


describe 'Scanner', ->

  context 'scanning valid teascript programs', ->

    VALID_SCAN_TEST_DIR = "#{__dirname}/input_programs/valid_programs"

    checkScannerOutputTokens = (fileName) ->
      it "outputs the appropriate tokens after scanning #{fileName}", ->
        outputTokens = scan "#{VALID_SCAN_TEST_DIR}/#{fileName}"
        expect(outputTokens).to.eql expectedOutputTokens[path.basename(fileName, '.tea')]
    
    for validFileToScan in fs.readdirSync VALID_SCAN_TEST_DIR
      checkScannerOutputTokens validFileToScan


  context 'scanning invalid teascript programs', ->

    INVALID_SCAN_TEST_DIR = "#{__dirname}/input_programs/invalid_programs"

    checkScanError = (fileName) ->
      it "throws the appropriate error after scanning #{fileName}", ->
        expect(-> scan "#{INVALID_SCAN_TEST_DIR}/#{fileName}")
          .to.throw expectedErrors[path.basename(fileName, '.tea')]

    for invalidFileToScan in fs.readdirSync INVALID_SCAN_TEST_DIR
      checkScanError invalidFileToScan