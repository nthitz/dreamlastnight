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
sass = require 'gulp-sass'


gulp.task 'tornado', shell.task('foreman start web')

gulp.task 'sass', () ->
  gulp.src('./web/scss/*.scss')
    .pipe(sass())
    .pipe(gulp.dest('./web/css/'))
gulp.task 'build', () ->
  b = browserify({
    entries: './web/cs/dream.coffee'
  }) 
  b.transform(coffeeify)
  b.transform(shim) #shims defined in package.json :(
  bundle = b.bundle()
  bundle
    .pipe(source('./web/cs/dream.coffee'))
    .pipe(rename('dream.js'))
    .pipe(gulp.dest('./web/js/'))
gulp.task 'watchify', () ->
  bundler = watchify({
    entries: './web/cs/dream.coffee'
  })
  bundler.transform(coffeeify)
  bundler.transform(shim) #shims defined in package.json :(
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
