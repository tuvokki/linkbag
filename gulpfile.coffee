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
# depends on:
#   scripts
#   clint
gulp.task 'watch', ['clint'], ->
  gulp.watch 'src/**/*.coffee', ['clint', 'scripts']
  gulp.watch 'test/**/*.coffee', ['clint', 'testscripts']

# coffee lint - checks the produced coffee files
gulp.task 'clint', ->
  gulp.src ['./src/**/*.coffee', './test/**/*.coffee']
  .pipe coffeelint()
  .pipe coffeelint.reporter()

gulp.task 'scripts', ->
  gulp.src ['src/**/*.coffee']
  .pipe plumber()
  .pipe coffee({bare: true})
    .on 'error', (err) ->
      console.log 'Compile error in ' + err
      console.log 'Run `gulp watch` to evaluate and compile'
      process.exit()
  .pipe concat('index.js')
  .pipe gulp.dest 'dist'

gulp.task 'testscripts', ->
  gulp.src ['test/**/*.coffee']
  .pipe plumber()
  .pipe coffee({bare: true})
    .on 'error', (err) ->
      console.log 'Compile error in ' + err
      console.log 'Run `gulp watch` to evaluate and compile'
      process.exit()
  .pipe concat 'test.js'
  .pipe gulp.dest 'test'
  .pipe mocha {reporter: 'nyan'}

# Remove generated sources
gulp.task 'clean', ->
  del.sync ['dist/**', 'test/test.js']

gulp.task 'run', ['clean', 'scripts'], ->
  require './dist/index.js', ->
    console.log 'died while starting the server'
