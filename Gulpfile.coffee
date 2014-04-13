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
gulp.task 'watchify', () ->
  bundler = watchify('./web/cs/dream.coffee')
  bundler.transform(coffeeify)
  rebundle = () ->
    bundle = bundler.bundle({debug: true})
    bundle
      .pipe(source('./web/cs/dream.coffee'))
      .pipe(rename('dream.js'))
      .pipe(gulp.dest('./web/js/'))
  bundler.on('update', rebundle)
  rebundle()

gulp.task 'watch', ['tornado','watchify']
#gulp.task 'default', ['watch', 'reload']
