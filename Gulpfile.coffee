gulp = require 'gulp'
shell = require 'gulp-shell'
livereload = require 'gulp-livereload'
watchify = require 'watchify'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
source = require 'vinyl-source-stream'
streamify = require('gulp-streamify')
coffee =  require 'coffee-script/register' 
shim = require 'browserify-shim'
rename = require 'gulp-rename'

shims = {
  Stats : { path: './web/vendor/Stats.js', exports: 'Stats'}
}
gulp.task 'tornado', shell.task('foreman start web')

gulp.task 'build', () ->
  b = browserify({
    entries: './web/cs/dream.coffee'
    shim: shims
  }) 
  b.transform(coffeeify)
  b.transform(shim)
  bundle = b.bundle()
  bundle
    .pipe(source('./web/cs/dream.coffee'))
    .pipe(rename('dream.js'))
    .pipe(gulp.dest('./web/js/'))
gulp.task 'watchify', () ->
  bundler = watchify('./web/cs/dream.coffee')
  bundler.transform(coffeeify)
  bundler.transform(shim)
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
