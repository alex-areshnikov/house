const { environment } = require('@rails/webpacker')
const TerserPlugin = require('terser-webpack-plugin');

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

// it's almost default terser config https://github.com/rails/webpacker/blob/master/package/environments/production.js#L48
const terserConfig = new TerserPlugin({
  terserOptions: {
    parse: {
      ecma: 8,
    },
    compress: {
      ecma: 5,
      warnings: false,
      comparisons: false,
      inline: 2,
      drop_console: true,
    },
    mangle: {
      safari10: true,
    },
    output: {
      ecma: 5,
      comments: false,
      ascii_only: true,
    },
  },
  // according to https://github.com/webpack-contrib/terser-webpack-plugin#parallel
  parallel: 3,
  cache: true,
  sourceMap: false,
  extractComments: false,
})

module.exports = environment
