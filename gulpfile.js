let gulp = require('gulp');
let terser = require('terser');
let gulpConcat = require('gulp-concat');
let gulpLess = require('gulp-less');
let gulpMinifyCss = require('gulp-clean-css');
let gulpMinifyHtml = require('gulp-htmlmin');
let gulpMinifyJsComposer = require('gulp-uglify/composer');
let gulpMinifyJs = gulpMinifyJsComposer(terser, console);

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
		.pipe(gulpLess())
		.pipe(gulpMinifyCss({compatibility: 'ie8'}))
		.pipe(gulpConcat('bundle.css'))
		.pipe(gulp.dest(paths.css.dest));
}

function js() {
	return gulp.src(paths.js.src)
		.pipe(gulpMinifyJs())
		.pipe(gulpConcat('bundle.js'))
		.pipe(gulp.dest(paths.js.dest));
}

function html() {
	return gulp.src(paths.html.src)
		.pipe(gulpMinifyHtml({collapseWhitespace: true}))
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
