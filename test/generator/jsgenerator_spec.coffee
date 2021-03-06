chai = require 'chai'
expect = chai.expect
CustomError = require '../../error/custom_error'
parse = require '../../parser/parse'
scan = require '../../scanner/scan'
generate = require '../../generators/jsgenerator'
validTeascriptProgramsPath = "#{__dirname}/input_programs/valid_programs"
expectedOutput = require "#{__dirname}/expected_output/compiled_output"
path = require 'path'
fs = require 'fs'

describe 'JS generator', ->
  
  context 'fully compiling valid teascript programs', ->

    VALID_COMPILE_TEST_DIR = "#{__dirname}/input_programs/valid_programs"

    checkCompiledProgram = (fileName) ->
      it "outputs the correct javascript for #{fileName}", ->
        tokens  = scan "#{VALID_COMPILE_TEST_DIR}/#{fileName}"
        program = parse tokens
        program.analyze()
        expect(generate program).to.eql expectedOutput[path.basename(fileName, '.tea')]

    for validFileToCompile in fs.readdirSync VALID_COMPILE_TEST_DIR
      checkCompiledProgram validFileToCompile
