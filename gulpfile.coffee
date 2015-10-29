gulp             = require 'gulp'
plumber          = require 'gulp-plumber'
sass             = require 'gulp-sass'
sourcemaps       = require 'gulp-sourcemaps'
pleeease         = require 'gulp-pleeease'
webpack          = require 'gulp-webpack'
imagemin         = require 'gulp-imagemin'
browserSync      = require 'browser-sync'


#
# SCSS (with AutoPrefixer, minify, SourceMaps)
#
gulp.task 'styles', ->
  gulp.src './src/styles/*.scss'
    .pipe plumber()
    .pipe sourcemaps.init()
    .pipe sass()
    .pipe pleeease()
    .pipe sourcemaps.write '.'
    .pipe gulp.dest './assets/css/'


#
# webpack (CoffeeScript, require, SourceMaps, Uglify)
#
gulp.task 'scripts', ->
  gulp.src './src/scripts/script.coffee'
    .pipe plumber()
    .pipe webpack
      entry:
        script: './src/scripts/script.coffee'
      output:
        filename: '[name].js'
        publicPath: '/assets/js/'
      resolve:
        extensions: ['', '.js', '.coffee']
        modulesDirectories: [ 'src/scripts', 'node_modules', 'bower_components' ],
      plugins: [
        new webpack.webpack.optimize.UglifyJsPlugin()
      ]
      module:
        loaders: [
          { test: /\.coffee$/, loader: 'coffee-loader' }
        ]
      devtool: 'source-map'
    .pipe gulp.dest './assets/js'


#
# imagemin
#
gulp.task 'images', ->
  gulp.src 'src/images/**/*'
    .pipe imagemin
      progressive: true
      interlaced: true
      svgoPlugins: [{cleanupIDs: false}]
    .pipe gulp.dest './assets/img'


#
# build assets (css, javascript)
#
gulp.task 'build', ['styles', 'scripts', 'images']


#
# Watch
#
gulp.task 'watch', ->
  gulp.watch 'src/styles/**/*.scss', ['styles']
  gulp.watch 'src/scripts/**/*.+(js|coffee)', ['scripts']


#
# start BrowserSync / LiveReload
#
gulp.task 'serve', ['watch'], ->
  browserSync
    notify: false,
    port: 9000,
    server:
      baseDir: '.'

  gulp.watch [
    '**/*.php'
    'assets/**/*'
  ]
  .on 'change', browserSync.reload


#
# default
#
gulp.task 'default', ['build', 'serve']
