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
watch = require 'gulp-watch'


gulp.task 'tornado', shell.task('foreman start web')

gulp.task 'sass', () ->
  gulp.src('./web/src/sass/*.scss')
    .pipe(sass())
    .pipe(gulp.dest('./web/dist/css/'))

gulp.task 'watch-sass', () ->
  gulp.src('./web/src/sass/*.scss')
    .pipe(watch((files) ->
      return files.pipe(sass()).pipe(gulp.dest('./web/dist/css'))
    ))
gulp.task 'browserify', () ->
  b = browserify({
    entries: './web/src/cs/dream.coffee'
  }) 
  b.transform(coffeeify)
  b.transform(shim) #shims defined in package.json :(
  bundle = b.bundle()
  bundle
    .pipe(source('./web/src/cs/dream.coffee'))
    .pipe(rename('dream.js'))
    .pipe(gulp.dest('./web/dist/js/'))
gulp.task 'watchify', () ->
  bundler = watchify({
    entries: './web/cs/dream.coffee'
  })
  bundler.transform(coffeeify)
  bundler.transform(shim) #shims defined in package.json :(
  rebundle = () ->
    bundle = bundler.bundle({debug: true})
    bundle
      .pipe(source('./web/src/cs/dream.coffee'))
      .pipe(rename('dream.js'))
      .pipe(gulp.dest('./web/dist/js/'))
  bundler.on('update', rebundle)
  rebundle()
gulp.task 'build', ['browserify','sass']
gulp.task 'watch', ['tornado','watchify','watch-sass']
#gulp.task 'default', ['watch', 'reload']
