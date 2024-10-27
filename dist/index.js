"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const fluent_ffmpeg_1 = __importDefault(require("fluent-ffmpeg"));
const stream_1 = require("stream");
const app = (0, express_1.default)();
const PORT = process.env.PORT || 8001;
const inputStreamUrl = 'http://live.radioec.com.ua:8000/drimayko';
app.get('/stream', (req, res) => {
    res.setHeader('Content-Type', 'audio/mpeg');
    const stream = new stream_1.PassThrough();
    // Set up ffmpeg to lower bitrate and reconnect if the connection drops
    (0, fluent_ffmpeg_1.default)(inputStreamUrl)
        .inputOptions(['-reconnect 1', '-reconnect_streamed 1', '-reconnect_delay_max 2'])
        .audioBitrate('64k')
        .format('mp3')
        .on('start', () => {
        console.log('Stream processing started');
    })
        .on('error', (err) => {
        console.error('Stream processing error:', err.message);
        res.status(500).send('Stream processing error');
    })
        .pipe(stream);
    stream.pipe(res);
});
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
