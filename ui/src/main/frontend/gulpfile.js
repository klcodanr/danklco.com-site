
const gulp        = require('gulp');
const cleanCSS   = require('gulp-clean-css');
var concatCss = require('gulp-concat-css');
var concat = require('gulp-concat');
var rename = require('gulp-rename');
var uglify = require('gulp-uglify');
var merge = require('merge-stream');
var order = require("gulp-order");


var cssStream = gulp.src('./src/css/*.css')
    .pipe(cleanCSS());

var vendorCssStream = gulp.src('./node_modules/bootstrap/dist/bootstrap.min.css');

gulp.task('styles', function() {
	 var mergedStream = merge(cssStream, cssStream)
     	.pipe(concat('styles.min.css'))
        .pipe(gulp.dest('./dist/jcr_root/etc/clientlibs/danklco-com/css'));
	 return mergedStream;
});

var vendorJSStream = gulp.src([
	'./node_modules/jquery/dist/jquery.min.js',
	'./node_modules/bootstrap/dist/bootstrap.min.js']);

var jsStream = gulp.src([
		'./src/js/scripts.js'
	])
	.pipe(uglify());

gulp.task('js', function() {
	var mergedStream = merge(jsStream, vendorJSStream)
		.pipe(order([
			'node_modules/jquery/**/*.js',
			'node_modules/bootstrap/**/*.js',
			'src/js/*.js',
		]))
		.pipe(concat('scripts.min.js'))
		.pipe(gulp.dest('./dist/jcr_root/etc/clientlibs/danklco-com/js'));
});

gulp.task('assets', function() {
	gulp.src('./src/{fonts,img}/**/*')
		.pipe(gulp.dest('./dist/jcr_root/etc/clientlibs/danklco-com'));
});


gulp.task('default', ['styles', 'js', 'assets'], function() {});