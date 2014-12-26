# Load all required libraries.
gulp        = require 'gulp'
gulpif      = require 'gulp-if'
trycatch    = require 'gulp-trycatch-closure'
coffee      = require 'gulp-coffee'
plumber     = require 'gulp-plumber'
coffeelint  = require 'gulp-coffeelint'
concat      = require 'gulp-concat'
del         = require 'del'

# watch task - watches changes in files and runs tasks on changes
# 
# depends on:
#   scripts
#   clint
gulp.task 'watch', ->
  gulp.watch "src/**/*.coffee", ['scripts', 'clint']

# coffee lint - checks the produced coffee files
gulp.task 'clint', ->
  gulp.src './src/**/*.coffee'
  .pipe coffeelint()
  .pipe coffeelint.reporter()

gulp.task 'scripts', ->
  gulp.src ['src/**/*.coffee']
  .pipe plumber()
  .pipe coffee({bare: true})
  .pipe concat('index.js')
  .pipe gulp.dest 'dist'

# Remove generated sources
gulp.task 'clean', ->
  del.sync ['dist/**']

gulp.task 'run', ['clean', 'scripts'], ->
  require './dist/index.js', ->
    console.log 'died while starting the server'
