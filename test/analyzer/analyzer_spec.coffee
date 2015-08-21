chai = require 'chai'
expect = chai.expect
CustomError = require '../../error/custom_error'
parse = require '../../parser/parse'
scan = require '../../scanner/scan'
fs = require 'fs'
path = require 'path'
invalidParserProgramsPath = "#{__dirname}/input_programs/invalid_programs"
expectedAnalysis = require "#{__dirname}/expected_output/analyzed_programs"
expectedErrors = require "#{__dirname}/expected_output/analyzer_errors"



describe 'Semantic Analyzer', ->

  context 'analyzing valid teascript programs', ->
  
    # For each valid test we have to compare the stringified versions
    # of programs with expected output since our 'program' variable
    # is decorated with functions (analyze(), toString(), optimize())
    # and thus won't be considered deeply equal unless we decorate our
    # expected output with the same functions
  
    VALID_ANALYZE_TEST_DIR = "#{__dirname}/input_programs/valid_programs"

    checkAnalysis = (fileName) ->
      it "analyzes the program and adds appropriate type annotations to #{fileName}", ->
        tokens = scan "#{VALID_ANALYZE_TEST_DIR}/#{fileName}"
        program = parse tokens
        program.analyze()
        expect(JSON.stringify(program)).to.eql expectedAnalysis[path.basename(fileName, '.tea')]

    for validFileToAnalyze in fs.readdirSync VALID_ANALYZE_TEST_DIR
      checkAnalysis validFileToAnalyze

  context 'analyzing invalid teascript programs', ->

    INVALID_ANALYZE_TEST_DIR = "#{__dirname}/input_programs/invalid_programs"

    checkAnalysisError = (fileName) ->
      it "throws the appropriate error after parsing #{fileName}", ->
        tokens = scan "#{INVALID_ANALYZE_TEST_DIR}/#{fileName}"
        program = parse tokens
        error = expectedErrors[path.basename(fileName, '.tea')]
        expect(-> program.analyze()).to.throw error

    for invalidFileToAnalyze in fs.readdirSync INVALID_ANALYZE_TEST_DIR
      checkAnalysisError invalidFileToAnalyze