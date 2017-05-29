'use strict';

const webpack = require('webpack');
const path = require('path');
const args = require('yargs').argv;
const buildPath = path.join(__dirname, './dist');

const ExtractTextPlugin = require('extract-text-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');

let isProd = args.prod;
let isDev = args.dev;

let entry = ['./src/site.js'];
let devtool;

if (isDev) {
    entry.push('webpack-dev-server/client?http://0.0.0.0:80');
    devtool = 'source-map';
}

let plugins = [
    new ExtractTextPlugin('[name].[hash].css'),
    new HtmlWebpackPlugin({
        template: './src/index.html',
        inject: 'body',
        chunks: 'app'
    }),
    new CleanWebpackPlugin([buildPath])
];

if (isProd) {
    plugins.push(
        new webpack.NoErrorsPlugin(),
        new webpack.optimize.DedupePlugin(),
        new webpack.optimize.UglifyJsPlugin({
            compress: {
                warnings: false
            },
            mangle: true
        }),
        new webpack.optimize.OccurenceOrderPlugin()
    );
}

module.exports = {
    entry: entry,

    output: {
        path: buildPath,
        publicPath: '/',
        filename: '[name].[hash].js'
    },

    module: {
        loaders: [
            { test: /\.json$/, loader: 'json'},
            { test: /\.js$/, exclude: /node_modules/, loader: 'babel'},
            { test: /\.scss$/, exclude: /node_modules/, loader: ExtractTextPlugin.extract('style', 'css?sourceMap!sass') },
            { test: /\.(png|jpg|ico)$/, exclude: /node_modules/, loader: 'file-loader?name=images/[name].[ext]&context=./src/images' },
        ]
    },

    node: {
      console: 'empty',
      fs: 'empty',
      net: 'empty',
      tls: 'empty'
    },

    quiet: false,
    noInfo: false,

    plugins: plugins,

    devtool: devtool,

    devServer: {
        contentBase: buildPath,
        host: '0.0.0.0',
        port: 80,
        disableHostCheck: true,
    }
};
