// Función para obtener la tasa de cambio
async function getExchangeRate() {
    try {
        const response = await fetch("https://ve.dolarapi.com/v1/dolares/oficial");
        const data = await response.json();
        const tasa = data.promedio.toFixed(4);
        return tasa;
    } catch (error) {
        console.error('Error al obtener la tasa de cambio:', error);
        return null;
    }
}

// Función para actualizar la tasa de cambio
async function updateExchangeRate() {
    const exchangeRate = await getExchangeRate();
    if (exchangeRate) {
        document.getElementById('cambio-dolar').textContent = exchangeRate;

    } else {
        document.getElementById('cambio-dolar').textContent = 'Error al obtener la tasa';
    }
}

updateExchangeRate();  // Actualizar la tasa de cambio al cargar la página

document.getElementById('amount').addEventListener('input', function () {
    const amount = parseFloat(document.getElementById('amount').value);
    if (isNaN(amount)) {
        alert('Por favor, ingresa un monto válido.');
        return;
    }
    document.getElementById('result').innerText = `${amount.toFixed(2)}`;
});

document.getElementById('convert').addEventListener('click', async function () {
    const amount = parseFloat(document.getElementById('amount').value);
    if (isNaN(amount)) {
        alert('Por favor, ingresa un monto válido.');
        return;
    }

    const exchangeRate = await getExchangeRate();
    if (exchangeRate) {
        const result = amount * exchangeRate;
        document.getElementById('result').innerText = `${result.toFixed(2)}`;
    } else {
        document.getElementById('result').innerText = 'Error al obtener la tasa de cambio';
    }
});

document.getElementById('sumar').addEventListener('click', function () {
    let bolivaresAcum = parseFloat(document.getElementById('bolivares').textContent);
    let resultadoNum = parseFloat(document.getElementById('result').textContent);
    let tasa = parseFloat(document.getElementById('cambio-dolar').textContent);

    if (isNaN(bolivaresAcum)) bolivaresAcum = 0.00;    

    bolivaresAcum += resultadoNum;
    document.getElementById('bolivares').innerText = `${bolivaresAcum.toFixed(2)}`;

    let montoEnDolares = bolivaresAcum / tasa;
    document.getElementById('dolares').innerText = `${montoEnDolares.toFixed(2)}`;
});

document.getElementById('restar').addEventListener('click', function () {
    let bolivaresAcum = parseFloat(document.getElementById('bolivares').textContent);
    let resultadoNum = parseFloat(document.getElementById('result').textContent);
    let tasa = parseFloat(document.getElementById('cambio-dolar').textContent);

    if (isNaN(bolivaresAcum)) bolivaresAcum = 0.00;    

    bolivaresAcum -= resultadoNum;
    document.getElementById('bolivares').innerText = `${bolivaresAcum.toFixed(2)}`;

    let montoEnDolares = bolivaresAcum / tasa;
    document.getElementById('dolares').innerText = `${montoEnDolares.toFixed(2)}`;
});