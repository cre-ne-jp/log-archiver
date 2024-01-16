const path = require("path");
const WebpackAssetsManifest = require("webpack-assets-manifest");
const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

const { NODE_ENV } = process.env;
const isProd = NODE_ENV === "production";

module.exports = {
  mode: isProd ? "production" : "development",
  devtool: "source-map",
  entry: {
    application: path.resolve(__dirname, "app/javascript/packs/application.js"),
  },
  output: {
    filename: isProd ? "[name]-[contenthash].js" : "[name].js",
    path: path.resolve(__dirname, "public/packs"),
    publicPath: isProd ? "/packs/" : "//localhost:8080/packs/",
  },
  resolve: {
    extensions: [".js"],
    modules: [
      path.resolve(__dirname, "./app/javascript"),
      "node_modules"
    ],
  },
  module: {
    strictExportPresence: true,
    rules: [
      {
        test: /\.(scss|sass|css)$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'sass-loader'
        ],
      },
    ]
  },
  plugins: [
    new CaseSensitivePathsPlugin(),
    new MiniCssExtractPlugin({
      filename: isProd ? "[name]-[contenthash].css" : "[name].css",
    }),
    new WebpackAssetsManifest({
      entrypoints: true,
      writeToDisk: true,
      publicPath: true,
      output: "manifest.json",
    }),
  ],
  devServer: {
    host: "localhost",
    headers: {
      "Access-Control-Allow-Origin": "*",
    },
    hot: false,
    devMiddleware: {
      publicPath: "/packs/",
    },
    static: {
      directory: path.resolve(__dirname, "public/packs"),
    },
  },
};
