// script.js

async function getExchangeRate() {
    try {
        const response = await fetch("https://ve.dolarapi.com/v1/dolares/oficial");
        const data = await response.json();
        const tasa = data.promedio.toFixed(4);
        console.log('Tasa de cambio:', tasa);
        return tasa;
    } catch (error) {
        console.error('Error al obtener la tasa de cambio:', error);
        return null;
    }
  }

  async function updateExchangeRate() {
    const exchangeRate = await getExchangeRate();
    if (exchangeRate) {
        document.getElementById('cambio-dolar').textContent = exchangeRate;
    } else {
        document.getElementById('cambio-dolar').textContent = 'Error al obtener la tasa';
    }
}

document.getElementById('convert').addEventListener('click', async function() {
    const amount = parseFloat(document.getElementById('amount').value);
    if (isNaN(amount)) {
        alert('Por favor, ingresa un monto válido.');
        return;
    }

    const exchangeRate = await getExchangeRate();
    if (exchangeRate) {
        const result = amount * exchangeRate;
        document.getElementById('result').innerText = `Resultado: ${result.toFixed(2)} VES`;
    } else {
        document.getElementById('result').innerText = 'Error al obtener la tasa de cambio';
    }
});

// Actualizar la tasa de cambio al cargar la página
updateExchangeRate();

