chai = require 'chai'
expect = chai.expect
CustomError = require '../../error/custom_error'
parse = require '../../parser/parser'
scan = require '../../scanner/scanner'
path = require 'path'
fs = require 'fs'
generate = require '../../generators/jsgenerator'
validTeascriptProgramsPath = "#{__dirname}/input_programs/valid_programs"
expectedOutput = require "#{__dirname}/expected_output/optimized_output"

describe 'Optimize', ->

  context 'optimizing valid stuff', ->

    VALID_OPTIMIZE_TEST_DIR = "#{__dirname}/input_programs/valid_programs"

    checkOptimization = (fileName) ->
      it "performs the appropriate optimizations for #{fileName}", ->
        tokens = scan "#{VALID_OPTIMIZE_TEST_DIR}/#{fileName}"
        program = parse tokens
        program.analyze()
        program = program.optimize()
        program = generate program
        expect(program).to.eql expectedOutput[path.basename(fileName, '.tea')]

    for validFileToOptimize in fs.readdirSync VALID_OPTIMIZE_TEST_DIR
      checkOptimization validFileToOptimize