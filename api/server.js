const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// Route santé
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    service: 'ECOTRACK API',
    timestamp: new Date().toISOString()
  });
});

// Route capteurs IoT
app.get('/api/capteurs', (req, res) => {
  res.json({ 
    message: 'ECOTRACK - 2000 capteurs actifs',
    zones: 12
  });
});

// Route données
app.post('/api/data', (req, res) => {
  console.log('Données reçues:', req.body);
  res.json({ status: 'reçu', data: req.body });
});

app.listen(PORT, () => {
  console.log(`ECOTRACK API démarrée sur le port ${PORT}`);
});