chai = require 'chai'
expect = chai.expect
CustomError = require '../../error/custom_error'
parse = require '../../parser/parser'
scan = require '../../scanner/scanner'
validParserProgramsPath = "#{__dirname}/input_programs/valid_programs"
invalidParserProgramsPath = "#{__dirname}/input_programs/invalid_programs"
expectedAnalysis = require "#{__dirname}/expected_output/analyzed_programs"



describe 'Semantic Analyzer', ->

  # For each valid test we have to compare the stringified versions
  # of programs with expected output since our 'program' variable
  # is decorated with functions (analyze(), toString(), optimize())
  # and thus won't be considered deeply equal unless we decorate our
  # expected output with the same functions

  describe 'analyzing a valid program', ->
    context 'when analyzing primitive/reference types', ->
      it 'analyzes correctly and adds proper type annotations', (done) ->
        scan "#{validParserProgramsPath}/program01.tea", (err, tokens) ->
          program = parse tokens
          program.analyze()
          expect(JSON.stringify(program)).to.eql expectedAnalysis.program01
          done()

  describe 'analyzing a valid program', ->
    context 'when analyzing variable declarations', ->
      it 'recursively analyzes the value on the right side
          of the declaration', (done) ->
        scan "#{validParserProgramsPath}/program02.tea", (err, tokens) ->
          program = parse tokens
          program.analyze()
          expect(JSON.stringify(program)).to.eql expectedAnalysis.program02
          done()

  describe 'analyzing a valid program', ->
    context 'when there is an arithmetic expression with
             a float and an int', ->
      it 'sets the type of the entire expression to be a float', (done) ->
        scan "#{validParserProgramsPath}/program03.tea", (err, tokens) ->
          program = parse tokens
          program.analyze()
          expect(JSON.stringify(program)).to.eql expectedAnalysis.program03
          done()



  describe 'analyzing an invalid program', ->
    context 'when a variable has been declared multiple
              times in the same context', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program01.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 6: Variable x already declared'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when there is an arithmetic op
             that does not have both int/float
             operands', ->
      it 'throws an error when the invalid operand is a literal', (done) ->
        scan "#{invalidParserProgramsPath}/program02.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 1: * must have integer or float operands'
          expect(-> program.analyze()).to.throw error
          done()

      it 'throws an error when the invalid operand is a varref', (done) ->
        scan "#{invalidParserProgramsPath}/program03.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 5: + must have integer or float operands'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when there are nested variable declarations', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program04.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 1: Nested variable declarations not allowed'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when a variable is used before it is declared', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program05.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 5: Variable z not found'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when realtional operators do not have
             boolean operands', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program06.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 1: and must have boolean operands'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when comparator operators do not have
             compatible operands', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program07.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 4: isnt must have mutually compatible operands'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when the condition of a while statement
             is not a boolean', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program08.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 19: Condition in "while" statement must be boolean'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when a variable is declared to be
             the value of a var assign exp', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program09.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 6: Variable declaration and initialization
                             to an assignment expression not allowed'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when a unary minus does not have
             an int/float operand', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program10.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 10: Unary - must have integer or float operand'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when a unary not does not have
             a boolean operand', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program11.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 10: not must have boolean operand'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when the beginning of a range expression
             is not an int', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program12.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 6: .. and ... range operators must have all
                   integer operands'
          expect(-> program.analyze()).to.throw error
          done()
    context 'when the ending of a range expression
             is not an int', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program13.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 9: .. and ... range operators must have all
                   integer operands'
          expect(-> program.analyze()).to.throw error
          done()
    context 'when the skip factor of a range expression
             is not an int', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program14.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 3: .. and ... range operators must have all
                   integer operands'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when there is an attempt to
             subscript [] a non
             ordered iterable', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program15.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 22: must take subscript [] of an ordered iterable type'
          expect(-> program.analyze()).to.throw error
          done()
    context 'when there is an attempt to
             subscript [] non int index', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program16.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 10: index must be an integer'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when a function uses a variable that has not been declared', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program17.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 19: Variable c not found'
          expect(-> program.analyze()).to.throw error
          done()

  describe 'analyzing an invalid program', ->
    context 'when a function definition has duplicate arguments', ->
      it 'throws an error', (done) ->
        scan "#{invalidParserProgramsPath}/program18.tea", (err, tokens) ->
          program = parse tokens
          error = 'line 12: Duplicate parameter a found in function definition'
          expect(-> program.analyze()).to.throw error
          done()