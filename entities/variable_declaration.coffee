Type = require './type'
CustomError = require '../error/custom_error'
VariableAssignment = require './variable_assignment'

class VariableDeclaration

  constructor: (@id, @value) ->

  toString: ->
    "(VarDec (#{@id.lexeme} #{@value}))"

  analyze: (context) ->
    @checkForNestedDeclarations()
    @checkForDeclarationToVarAssign()
    context.variableMustNotBeAlreadyDeclared @id

    context.addVariable @id.lexeme, this

    # have to pass name in case the value is a class
    # (class names define a new type)
    @value.analyze context, @id.lexeme
    context.symbolTable[@id.lexeme].type = @value.type

  optimize: -> this

  checkForNestedDeclarations: ->
    if @value instanceof VariableDeclaration
      throw new CustomError 'Nested variable declarations not allowed',
                             @id.lineNumber

  checkForDeclarationToVarAssign: ->
    if @value instanceof VariableAssignment
      throw new CustomError 'Variable declaration and initialization
                             to an assignment expression not allowed',
                             @id.lineNumber

VariableDeclaration.ARBITRARY = new VariableDeclaration '<arbitrary>',
                                                        Type.ARBITRARY

module.exports = VariableDeclaration
