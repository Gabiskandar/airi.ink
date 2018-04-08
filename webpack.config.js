var path = require('path');

const webpack = require('webpack');

module.exports = {
    entry: {
        aether: './assets/scripts/ts/aether.ts',
        analytics: './assets/scripts/ts/analytics/index.ts',
        core: [
            "./assets/scripts/ts/util/logging.ts",
        ]
    },
    module: {
        rules: [
            {
                exclude: '/node_modules/',
                loader: 'ts-loader',
                test: /\.tsx?$/
            }
        ]
    },
    plugins: [
        new webpack.optimize.CommonsChunkPlugin({
            name: "core"
        }),
        new webpack.optimize.CommonsChunkPlugin({
            name: "runtime"
        }),
        new webpack.optimize.CommonsChunkPlugin({
            name: 'manifest',
            chunks: 'runtime',
            minChunks: Infinity
        }),
    ],
    output: {
        filename: '[name].js',
        path: path.resolve(__dirname, '.build/assets/scripts/js')
    },
    resolve: {
        extensions: [".ts", ".json", ".js"]
    }
}
