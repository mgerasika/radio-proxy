import express, { Request, Response } from 'express';
import ffmpeg from 'fluent-ffmpeg';
import { PassThrough } from 'stream';

const app = express();
const PORT = 8001;

const inputStreamUrl = 'http://live.radioec.com.ua:8000/drimayko';

app.get('/stream', (req: Request, res: Response) => {
  res.setHeader('Content-Type', 'audio/mpeg');

  const stream = new PassThrough();

  // Set up ffmpeg to lower bitrate and reconnect if the connection drops
  ffmpeg(inputStreamUrl)
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
