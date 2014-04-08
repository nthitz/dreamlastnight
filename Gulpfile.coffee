gulp = require 'gulp'
shell = require 'gulp-shell'
livereload = require 'gulp-livereload'
 
watchify = "watchify
  app/assets/javascripts/initialize.coffee
  --outfile app/assets/javascripts/bundle.js
  --extension='.coffee'
  --transform coffeeify
  --transform debowerify
  --transform browserify-eco
  --debug"
 
browserify = "browserify
  app/assets/javascripts/initialize.coffee
  --outfile app/assets/javascripts/bundle.js
  --extension='.coffee'
  --transform coffeeify
  --transform debowerify
  --transform browserify-eco"
 
gulp.task 'watch', shell.task(watchify)
gulp.task 'build', shell.task(browserify)
 
gulp.task 'reload', ->
  server = livereload()
  gulp.watch './app/assets/javascripts/bundle.js'
    .on 'change', (file) -> server.changed file.path
 
gulp.task 'default', ['watch', 'reload']