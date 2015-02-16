var path = require('path');
var webpack = require('webpack');

module.exports = {
  // 'context' sets the directory where webpack looks for module files you list in
  // your 'require' statements
  context: __dirname + '/app/assets/javascripts',

  // 'entry' specifies the entry point, where webpack starts reading all
  // dependencies listed and bundling them into the output file.
  // The entrypoint can be anywhere and named anything - here we are calling it
  // '_application' and storing it in the 'javascripts' directory to follow
  // Rails conventions.
  entry: 'sp_react_2',

  // 'output' specifies the filepath for saving the bundled output generated by
  // wepback.
  // It is an object with options, and you can interpolate the name of the entry
  // file using '[name]' in the filename.
  // You will want to add the bundled filename to your '.gitignore'.
  output: {
    filename: 'webpack-bundle.js',
    // We want to save the bundle in the same directory as the other JS.
    path: __dirname + '/app/assets/javascripts'
  },
  externals: {
    jquery: "var jQuery"
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee-loader"  },
      { test: /\.css$/, loader: "style-loader!css-loader" },
      { test: /\.gif$/, loader: "url-loader" },
      { test: /\.png$/, loader: "url-loader" },
      // {
      //   // Pattern to match only files with the '.js' or '.jsx' extension.
      //   // This tells the loader to only run for those files.
      //   test: /\.jsx?$/,
      //   // @see https://github.com/shama/es6-loader
      //   // It was installed with 'npm install es6-loader --save' and transpiles
      //   // es6 to es5.
      //   loader: 'es6-loader'
      // },
      { test: /\.scss$/, loader: "style!css!sass?outputStyle=expanded&imagePath=/assets/images" }
      // { test: require.resolve("jquery"), loader: "expose?jQuery" },
      // { test: require.resolve("jquery"), loader: "expose?$" }
    ]
  },
  resolve: {
    alias: {
      'react$': 'react/addons'
      // 'datetimepicker': 'node_modules/bootstrap-datetimepicker/build/js/bootstrap'
    },
    extensions: ['', '.js.coffee', '.coffee', '.js', '.css', '.scss'],
    root: [
      path.join(__dirname, 'app', 'assets', 'javascripts')
    ],
    modulesDirectories: ['node_modules', 'bower_components', 'web_modules']
  },
  plugins: [
    new webpack.ProvidePlugin({
        '_': 'lodash'
    })
  ]

  // The 'module' and 'loaders' options tell webpack to use loaders.
  // @see http://webpack.github.io/docs/using-loaders.html
};

var devBuild = (typeof process.env["BUILDPACK_URL"]) === "undefined";
if (devBuild) {
  console.log("Webpack dev build for Rails");
  module.exports.devtool = "eval";
} else {
  console.log("Webpack production build for Rails");
}
