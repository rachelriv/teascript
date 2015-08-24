chai           = require 'chai'
expect         = chai.expect
parse          = require '../../parser/parse'
scan           = require '../../scanner/scan'
path           = require 'path'
fs             = require 'fs'
outputASTs     = require "#{__dirname}/expected_output/output_ASTs"
expectedErrors = require "#{__dirname}/expected_output/expected_parse_errors"


describe 'Parser', ->

  context 'parsing valid teascript programs', ->

    VALID_PARSE_TEST_DIR = "#{__dirname}/input_programs/valid_programs"

    checkAST = (fileName) ->
      it "outputs the appropriate AST after parsing #{fileName}", ->
        tokens = scan "#{VALID_PARSE_TEST_DIR}/#{fileName}"
        AST    = parse tokens
        expect(AST.toString()).to.eql outputASTs[path.basename(fileName, '.tea')]

    for validFileToParse in fs.readdirSync VALID_PARSE_TEST_DIR
      checkAST validFileToParse

  context 'parsing invalid teascript programs', ->

    INVALID_PARSE_TEST_DIR = "#{__dirname}/input_programs/invalid_programs"

    checkParseError = (fileName) ->
      it "throws the appropriate error after parsing #{fileName}", ->
        tokens = scan "#{INVALID_PARSE_TEST_DIR}/#{fileName}"
        error  = expectedErrors[path.basename(fileName, '.tea')] 
        expect(-> parse tokens).to.throw error

    for invalidFileToParse in fs.readdirSync INVALID_PARSE_TEST_DIR
      checkParseError invalidFileToParse