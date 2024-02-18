const path = require('path');
const NodePolyfillPlugin = require("node-polyfill-webpack-plugin");
const webpack = require("webpack")

module.exports = {
    mode: 'production',
  entry: './build/migrate.js',
  target: 'node',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist'),
  },
  // Add any necessary modules/loaders
  module: {
    rules: [
      {
        test: /\.ts?$/,
        use: 'ts-loader',
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    extensions: ['.ts', '.js'],
    
  },
  plugins: [
    new NodePolyfillPlugin(),
    new webpack.DefinePlugin({
        'process.env.HOST': JSON.stringify(process.env.HOST),
        'process.env.PROTOCOL': JSON.stringify(process.env.PROTOCOL),
        'process.env.PORT': JSON.stringify(process.env.PORT),
        'process.env.AUTH': JSON.stringify(process.env.AUTH),
        'process.env.OPENSEARCH_INDEX': JSON.stringify(process.env.OPENSEARCH_INDEX),
    })
]
};
