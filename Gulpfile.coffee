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
_ = require 'lodash'
#webserver, quite optional
gulp.task 'server', shell.task('foreman start')

# copy some static files
gulp.task 'copy', () ->
  gulp.src('./web/src/index.html')
  .pipe(gulp.dest('./web/dist/'))
gulp.task 'copy-watch', () ->
  gulp.src('./web/src/index.html')
    .pipe(watch((files) ->
      files.pipe(gulp.dest('./web/dist/'))
    ))

#preprocess sass scss
gulp.task 'sass', () ->
  gulp.src('./web/src/sass/*.scss')
    .pipe(sass())
    .pipe(gulp.dest('./web/dist/css/'))

gulp.task 'sass-watch', () ->
  gulp.src('./web/src/sass/*.scss')
    .pipe(watch((files) ->
      return files.pipe(sass()).pipe(gulp.dest('./web/dist/css'))
    ))


#compile js
gulp.task 'browserify', () ->
  b = browserify({
    entries: './web/src/cs/dreamApp.coffee'
  }) 
  b.transform(coffeeify)
  b.transform(shim) #shims defined in package.json :(
  bundle = b.bundle()
  bundle
    .pipe(source('./web/src/cs/dreamApp.coffee'))
    .pipe(rename('dreamApp.js'))
    .pipe(gulp.dest('./web/dist/js/'))
gulp.task 'watchify', () ->
  bundler = watchify({
    entries: './web/src/cs/dreamApp.coffee'
  })
  bundler.transform(coffeeify)
  bundler.transform(shim) #shims defined in package.json :(
  rebundle = () ->
    bundle = bundler.bundle({debug: true})
    bundle
      .pipe(source('./web/src/cs/dreamApp.coffee'))
      .pipe(rename('dreamApp.js'))
      .pipe(gulp.dest('./web/dist/js/'))
  bundler.on('update', rebundle)
  rebundle()
gulp.task 'build', ['browserify','sass', 'copy',]
gulp.task 'watch', () ->
  lrServer = livereload()
  gulp.watch('./web/dist/**').on('change', (file) ->
    lrServer.changed(file.path)
  )
  _.each(['server','watchify','sass-watch','copy-watch'], (task) ->
    gulp.start(task)
  )
#gulp.task 'default', ['watch', 'reload']
