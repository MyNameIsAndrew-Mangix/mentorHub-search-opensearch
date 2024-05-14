const path = require('path');

module.exports = {
    mode: 'production',
  entry: {
    migrate: {
      import: './src/searchinit/migrate.ts',
      filename: './dist/bundle.js'
    },
    import: {
      import: './src/import/import.ts',
      filename: './src/import/importer.js'
    }
  },
  target: 'node',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname),
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
};
