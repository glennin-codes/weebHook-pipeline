
const express = require('express');
const exec = require('child_process').exec;

const app = express();
const port = 3000;

app.use(express.json());

// Endpoint for GitHub Webhook
app.post('/webhook', (req, res) => {
  console.log('Received webhook push event.');

  // Run the post-receive hook to deploy the code
  exec('/home/ubuntu/weebHook-pipeline/deploy.log/deploy.sh', (error, stdout, stderr) => {
    if (error) {
      console.error(`exec error: ${error}`);

      return res.status(500).send('Deployment failed');
    }
    console.log(stdout);
    res.send('Deployment triggered successfully');
  });
});

app.listen(port, () => {
  console.log(`Webhook server listening at http://localhost:${port}`);
});
