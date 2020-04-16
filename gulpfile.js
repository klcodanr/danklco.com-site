const { series, src, dest, watch } = require("gulp");
const cleanCSS = require("gulp-clean-css");
const babel = require("gulp-babel");
const concat = require("gulp-concat");
const noop = require("gulp-noop");
let prod = false;

function img() {
  return src("./src/main/frontend/img/*.*").pipe(
    dest("./target/dist/jcr_root/static/clientlibs/danklco-com/img")
  );
}

function fonts() {
  return src(["./node_modules/font-awesome/fonts/*"]).pipe(
    dest("./target/dist/jcr_root/static/clientlibs/danklco-com/fonts")
  );
}

function scripts() {
  return src([
    "./node_modules/jquery/dist/jquery.js",
    "./node_modules/bootstrap/dist/js/bootstrap.js",
    "./src/main/frontend/js/scripts.js",
  ])
    .pipe(
      prod
        ? babel({
            presets: ["@babel/env"],
          })
        : noop()
    )
    .pipe(concat("scripts.js"))
    .pipe(dest("./target/dist/jcr_root/static/clientlibs/danklco-com/js"));
}

function styles() {
  return src([
    "./node_modules/bootstrap/dist/css/bootstrap.css",
    "./node_modules/font-awesome/css/font-awesome.min.css",
    "./src/main/frontend/css/custom.css",
  ])
    .pipe(
      prod
        ? cleanCSS({
            compatibility: "ie8",
          })
        : noop()
    )
    .pipe(concat("styles.css"))
    .pipe(dest("./target/dist/jcr_root/static/clientlibs/danklco-com/css"));
}

function setProd(cb) {
  prod = true;
  cb();
}

exports.build = series(img, scripts, fonts, styles);
exports.prod = series(setProd, exports.build);
exports.default = exports.build;
