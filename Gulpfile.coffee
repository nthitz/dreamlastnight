gulp = require 'gulp'
shell = require 'gulp-shell'
livereload = require 'gulp-livereload'
watchify = require 'watchify'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
source = require 'vinyl-source-stream'
streamify = require('gulp-streamify')
coffee =  require 'coffee-script/register' 
rename = require 'gulp-rename'

gulp.task 'tornado', shell.task('foreman start web')

gulp.task 'build', () ->
  b = browserify('./web/cs/dream.coffee')
  b.transform(coffeeify)
  bundle = b.bundle()
  bundle
    .pipe(source('./web/cs/dream.coffee'))
    .pipe(rename('dream.js'))
    .pipe(gulp.dest('./web/js/'))

###
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
###
#https://gist.github.com/torgeir/8507130
#http://gh.codehum.com/unc0/gulp.gs
#https://github.com/gulpjs/plugins/issues/47

#gulp.task 'watch', shell.task(watchify)
#gulp.task 'build', shell.task(browserify)
 
#gulp.task 'reload', ->
#  server = livereload()
#  gulp.watch './app/assets/javascripts/bundle.js'
#    .on 'change', (file) -> server.changed file.path
 
#gulp.task 'default', ['watch', 'reload']
