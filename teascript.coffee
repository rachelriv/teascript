#!/usr/bin/env coffee

argv = require 'yargs'
  .usage '$0 [-t] [-a] [-u] filename'
  .boolean ['t', 's,', 'a', 'g', 'u']
  .describe 't', 'show tokens after scanning then stop'
  .describe 's', 'show abstract syntax tree after parsing then stop'
  .describe 'a', 'show analyzed program after parsing and then stop'
  .describe 'g', 'generate and display the compiled code then stop'
  .describe 'u', 'uglify (minimize) the generated code'
  .demand 1
  .argv

scan = require './scanner/scan'
parse = require './parser/parse'
generate = require './generators/jsgenerator'
uglify = require 'uglify-js'

tokens = scan argv._[0]
return console.log tokens if argv.t

try 
  program = parse tokens
  return console.log program if argv.s
  program.analyze()
  program.optimize()
  return console.log JSON.stringify(program, null, 2) if argv.a
  
  program = generate program
  if argv.u
    program = uglify.minify(program, {fromString: true}).code
  if argv.g
    console.log program
    return
  console.log program

catch err
  console.log err.message
  throw err
  return