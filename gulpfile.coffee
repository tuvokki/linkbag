# Load all required libraries.
gulp        = require 'gulp'
gulpif      = require 'gulp-if'
trycatch    = require 'gulp-trycatch-closure'
coffee      = require 'gulp-coffee'
plumber     = require 'gulp-plumber'
coffeelint  = require 'gulp-coffeelint'
concat      = require 'gulp-concat'
del         = require 'del'
mocha       = require 'gulp-mocha'

# watch task - watches changes in files and runs tasks on changes
# 
# todo:
#   run tests on change of scripts
#
# depends on:
#   scripts
#   clint
gulp.task 'watch', ['clint', 'testscripts', 'scripts'], ->
  gulp.watch 'src/app/**/*.coffee', ['clint', 'scripts']
  gulp.watch 'src/test/**/*.coffee', ['clint', 'testscripts']

# coffee lint task - checks the produced coffee files
gulp.task 'clint', ->
  gulp.src ['./src/**/*.coffee', './test/**/*.coffee']
  .pipe coffeelint()
  .pipe coffeelint.reporter()

# scripts task - compiles the coffee script into javascript
gulp.task 'scripts', ->
  gulp.src ['src/app/**/*.coffee']
  .pipe plumber()
  .pipe coffee({bare: true})
    .on 'error', (err) ->
      console.log 'Compile error in ' + err
      console.log 'Run `gulp watch` to evaluate and compile'
      process.exit()
  .pipe concat('index.js')
  .pipe gulp.dest 'dist'

# testscripts task - compiles the coffee
# script tests into javascript and runs them
gulp.task 'testscripts', ->
  gulp.src ['src/test/**/*.coffee']
  .pipe plumber()
  .pipe coffee({bare: true})
    .on 'error', (err) ->
      console.log 'Compile error in ' + err
      console.log 'Run `gulp watch` to evaluate and compile'
      process.exit()
  .pipe concat 'test.js'
  .pipe gulp.dest 'test'
  .pipe mocha {reporter: 'nyan'}

# clean task - removes generated sources
gulp.task 'clean', ->
  del.sync ['dist/**', 'test/**']

# run task - runs the server on cleaned sources
gulp.task 'run', ['clean', 'scripts'], ->
  require './dist/index.js', ->
    console.log 'died while starting the server'
