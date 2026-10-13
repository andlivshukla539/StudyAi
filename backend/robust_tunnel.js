const localtunnel = require('localtunnel');

const PORT = 3000;
const SUBDOMAIN = 'ai-study-companion-123'; // Fixed subdomain for stability

async function startTunnel() {
  try {
    console.log('Starting tunnel...');
    const tunnel = await localtunnel({ port: PORT, subdomain: SUBDOMAIN });

    console.log(`[robust_tunnel] Tunnel is running at: ${tunnel.url}`);

    tunnel.on('close', () => {
      console.error('[robust_tunnel] Tunnel closed! Restarting in 2 seconds...');
      setTimeout(startTunnel, 2000);
    });

    tunnel.on('error', (err) => {
      console.error('[robust_tunnel] Tunnel error:', err);
      // Wait for 'close' to trigger restart, or force close
      tunnel.close();
    });

  } catch (err) {
    console.error('[robust_tunnel] Failed to start tunnel:', err);
    setTimeout(startTunnel, 5000); // retry after 5s
  }
}

startTunnel();
