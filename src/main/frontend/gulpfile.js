const gulp = require('gulp');
const cleanCSS   = require('gulp-clean-css');
var concatCss = require('gulp-concat-css');
var concat = require('gulp-concat');
var rename = require('gulp-rename');
var uglify = require('gulp-uglify');
var merge = require('merge-stream');
var order = require("gulp-order");
const rev = require('gulp-rev');
var revReplace = require("gulp-rev-replace");

var cssStream = gulp.src('./src/css/*.css')
    .pipe(cleanCSS());

var vendorCssStream = gulp.src([
			'./node_modules/bootstrap/dist/css/bootstrap.min.css',
			'./node_modules/font-awesome/css/font-awesome.min.css'
	]);

gulp.task('styles', function() {
	 var mergedStream = merge(cssStream, vendorCssStream)
		.pipe(order([
			'node_modules/bootstrap/dist/css/bootstrap.min.css',
			'node_modules/font-awesome/css/font-awesome.min.css',
			'src/css/*.css',
		], { base: './' }))
     	.pipe(concat('styles.min.css'))
		.pipe(rev())
        .pipe(gulp.dest('./dist/jcr_root/static/clientlibs/danklco-com/css'))
        .pipe(rev.manifest())
        .pipe(gulp.dest('./dist/css'));
});

var vendorJSStream = gulp.src([
	'./node_modules/jquery/dist/jquery.min.js',
	'./node_modules/bootstrap/dist/js/bootstrap.min.js']);

var jsStream = gulp.src([
		'./src/js/scripts.js'
	]);

gulp.task("revreplace", function(){
  var manifest = gulp.src([
      "./dist/css/rev-manifest.json",
      "./dist/js/rev-manifest.json"
  ]);
 
  return gulp.src("./src/fed.jsp")
    .pipe(revReplace({
      manifest: manifest,
      replaceInExtensions:['.jsp']
    }))
    .pipe(gulp.dest('./dist/jcr_root/apps/danklco-com/components/pages/base'));
});

gulp.task('js', function() {
	var mergedStream = merge(jsStream, vendorJSStream)
		.pipe(order([
			'node_modules/jquery/dist/jquery.min.js',
			'node_modules/bootstrap/dist/js/bootstrap.min.js',
			'src/js/*.js',
		], { base: './' }))
		.pipe(concat('scripts.min.js'))
		.pipe(rev())
		.pipe(gulp.dest('./dist/jcr_root/static/clientlibs/danklco-com/js'))
        .pipe(rev.manifest())
		.pipe(gulp.dest('./dist/js'));
});

gulp.task('assets', function() {
	gulp.src([
		'./src/{fonts,img}/**/*'
	]).pipe(gulp.dest('./dist/jcr_root/static/clientlibs/danklco-com'));

	gulp.src([
		'./node_modules/font-awesome/fonts/*.*'
	]).pipe(gulp.dest('./dist/jcr_root/static/clientlibs/danklco-com/fonts'));
});


gulp.task('default', ['styles', 'js', 'assets','revreplace'], function() {});