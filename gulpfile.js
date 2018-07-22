let gulp = require('gulp');
let exec = require('child_process').exec;
let gultpConcat = require('gulp-concat');
let gultpLess = require('gulp-less');
let gultpMinifyCss = require('gulp-clean-css');
let gultpMinifyHtml = require('gulp-htmlmin');
let gultpMinifyJs = require('gulp-uglify');

let paths = {
	css: {
		src: './static/css/**/*.less',
		dest: './static/webtemp',
	},
	js: {
		src: './static/js/**/*.js',
		dest: './static/webtemp',
	},
	html: {
		src: './public/**/*.html',
		dest: './public',
	},
};

function css() {
	return gulp.src(paths.css.src)
		.pipe(gultpLess())
		.pipe(gultpMinifyCss({compatibility: 'ie8'}))
		.pipe(gultpConcat('bundle.css'))
		.pipe(gulp.dest(paths.css.dest));
}

function js() {
	return gulp.src(paths.js.src)
		.pipe(gultpMinifyJs())
		.pipe(gultpConcat('bundle.js'))
		.pipe(gulp.dest(paths.js.dest));
}

function html() {
	return gulp.src(paths.html.src)
		.pipe(gultpMinifyHtml({collapseWhitespace: true}))
		.pipe(gulp.dest(paths.html.dest));
}

function watch() {
	gulp.watch(paths.css.src, css);
	gulp.watch(paths.js.src, js);
}

gulp.task('css', css);
gulp.task('js', js);
gulp.task('html', html);
gulp.task('watch', watch);
