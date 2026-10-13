const localtunnel = require('localtunnel');

(async () => {
  try {
    const tunnel = await localtunnel({ port: 3000 });
    console.log(tunnel.url);
    
    tunnel.on('close', () => {
      console.log('Tunnel closed');
    });
    
    tunnel.on('error', (err) => {
      console.error('Tunnel error:', err);
    });
    
    // Keep process alive
    setInterval(() => {}, 1000 * 60 * 60);
  } catch (err) {
    console.error('Failed to start tunnel:', err);
  }
})();
