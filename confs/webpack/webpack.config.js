/****************************************************
  > File Name    : webpack.conf.js
  > Author       : Cole Smith
  > Mail         : tobewhatwewant@gmail.com
  > Github       : whatwewant
  > Created Time : 2016年03月31日 星期四 14时45分59秒
 ****************************************************/

var webpack = require('webpack');
var webpackMerge = require('webpack-merge');
var path = require('path');
var htmlWebpackPlugin = require('html-webpack-plugin');

// npm start for develop
// npm build for product
var MODE = process.env.npm_lifecycle_event;

var common = {
    entry: [
        path.join(__dirname, 'app.js')
    ],
    output: {
        path: path.join(__dirname, 'build'),
        filename: 'bundle.js',
    },
    module: {
        loaders: [
            {test: /\.scss$/, loader: 'style!css!autoprefixer?{browsers:["last 2 version", "> 1%"]}!sass'},
            {
                test: /\.js$/, 
                exclude: /node_modules/, 
                loader: 'babel-loader?presets[]=es2015'
            },
            {
                test: /\.jsx$/,
                exclude: /node_modules/,
                loader: 'babel-loader',
                query: {
                    presets: [
                        'es2015',
                        'react'
                    ]
                }
            },
            {
                test: /\.(png|jpg)$/,
                loader: 'url-loader',
                query: {
                    limit: 8192,
                    name: 'images/[name].[ext]'
                }
            }
        ],
    },
};


// About Package.json: https://docs.npmjs.com/cli/run-script
// product mode
// how to: 
//  npm run build
//  OR npm run release
//  OR npm run product
if (MODE === 'build' || MODE === 'release' || MODE === 'product') {
    module.exports = webpackMerge(common, {
        plugins: [
            new webpack.optimize.UglifyJsPlugin({
                compress: {
                    warnings: false
                }
            }),
            new htmlWebpackPlugin()
        ]
    })
} 
// develop mode
// how to:
//  npm start
//  OR npm run start
else {
    module.exports = webpackMerge(common, {
        devtool: 'eval-source-map',
        devServer: {
            contentBase: path.join(__dirname, 'build'),
            historyApiFallback: true,
            hot: true,
            inline: true,
            progress: true,

            stats: 'errors-only',

            host: "127.0.0.1",
            port: 8081
        },
        plugins: [
            new webpack.HotModuleReplacementPlugin(),
            new htmlWebpackPlugin()
        ]
    });
}
