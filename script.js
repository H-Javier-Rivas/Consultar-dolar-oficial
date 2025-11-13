const precioRefTxt = document.getElementById('precio-ref');
const cambioDolarTxt = document.getElementById('cambio-dolar');

const precioBsTxt = document.getElementById('precio-bs');
const precioDolarTxt = document.getElementById('precio-dolar');

const bolivares = document.getElementById('bolivares');
const dolares = document.getElementById('dolares');

const precioBsChk = document.getElementById('precio-bs-chk');
const precioDolarChk = document.getElementById('precio-dolar-chk');

// ==================== TASA DE CAMBIO ====================

const cambioDolarTxt = document.getElementById('cambio-dolar');
const tasaManualInput = document.getElementById('tasa-manual');
const toggleRateModeBtn = document.getElementById('toggle-rate-mode');
const rateModeIndicator = document.getElementById('rate-mode-indicator');

let isManualMode = localStorage.getItem('isManualMode') === 'true';
let manualRate = parseFloat(localStorage.getItem('manualRate')) || 0;

// Función para obtener la tasa de cambio (API BCV)
async function getExchangeRateFromAPI() {
    try {
        const response = await fetch("https://ve.dolarapi.com/v1/dolares/oficial");
        const data = await response.json();
        return data.promedio.toFixed(4);
    } catch (error) {
        console.error('Error al obtener la tasa de cambio:', error);
        return null;
    }
}

// Función para actualizar la tasa en el DOM
async function updateExchangeRate() {
    let rateToDisplay = '';
    
    if (isManualMode && manualRate > 0) {
        // Usar tasa manual
        rateToDisplay = manualRate.toFixed(4);
        cambioDolarTxt.textContent = rateToDisplay;
        tasaManualInput.value = manualRate;
        rateModeIndicator.textContent = 'Modo Manual';
        rateModeIndicator.classList.add('manual');
        tasaManualInput.classList.add('active');
    } else {
        // Obtener tasa BCV
        const exchangeRate = await getExchangeRateFromAPI();
        if (exchangeRate) {
            rateToDisplay = exchangeRate;
            cambioDolarTxt.textContent = rateToDisplay;
            rateModeIndicator.textContent = 'Modo BCV';
            rateModeIndicator.classList.remove('manual');
            tasaManualInput.classList.remove('active');
        } else {
            // Fallback si la API falla
            cambioDolarTxt.textContent = '⚠';
            rateModeIndicator.textContent = 'Error API';
            alert("No se pudo obtener la tasa BCV. Active el modo manual para ingresar una tasa.");
        }
    }
    
    // Guardar preferencia
    localStorage.setItem('isManualMode', isManualMode);
    if (isManualMode) {
        localStorage.setItem('manualRate', manualRate);
    }
}

// Inicializar tasa al cargar
updateExchangeRate();

// Actualizar tasa cada 5 minutos (solo en modo automático)
setInterval(() => {
    if (!isManualMode) {
        updateExchangeRate();
    }
}, 300000);

// Toggle entre modos
toggleRateModeBtn.addEventListener('click', () => {
    isManualMode = !isManualMode;
    if (isManualMode) {
        const currentRate = parseFloat(cambioDolarTxt.textContent);
        if (currentRate && !isNaN(currentRate)) {
            tasaManualInput.value = currentRate;
            manualRate = currentRate;
        }
    }
    updateExchangeRate();
});

// Guardar tasa manual cuando el usuario la edita
tasaManualInput.addEventListener('input', () => {
    const newRate = parseFloat(tasaManualInput.value);
    if (!isNaN(newRate) && newRate > 0) {
        manualRate = newRate;
        if (isManualMode) {
            cambioDolarTxt.textContent = manualRate.toFixed(4);
            localStorage.setItem('manualRate', manualRate);
        }
    }
});

// ==================== CALCULADORA ====================

updateExchangeRate();  // Actualizar la tasa de cambio al cargar la página

precioRefTxt.addEventListener('input', function () {
    let precioRef = parseFloat(precioRefTxt.value);
    if (precioRef < 0) {
        alert("No se permiten valores negativos.");
        precioRefTxt.value = '';
        precioBsTxt.innerText = '0.00';
        return;
    }
    const currentExchangeRate = parseFloat(cambioDolarTxt.textContent);
    if (!isNaN(precioRef) && currentExchangeRate) {
        const precioBs = precioDolarChk.checked ? precioRef * currentExchangeRate : precioRef;
        precioBsTxt.innerText = `${precioBs.toFixed(2)}`;
    }
});

precioBsChk.addEventListener('input', function () {
    const precioBs = parseFloat(precioRefTxt.value);
    if (precioBsChk.checked) {
        precioBsTxt.innerText = `${precioBs.toFixed(2)}`;
    }
});   

precioDolarChk.addEventListener('input', function () {
    const precioRef = parseFloat(precioRefTxt.value);
    const currentExchangeRate = parseFloat(cambioDolarTxt.textContent);
    const precioBs = precioRef * currentExchangeRate;
    if (precioDolarChk.checked) {
        precioBsTxt.innerText = `${precioBs.toFixed(2)}`;
    }
});

document.getElementById('sumar').addEventListener('click', function () {
    let bolivaresAcum = parseFloat(bolivares.textContent);
    let resultadoNum = parseFloat(precioBsTxt.textContent);
    let tasa = parseFloat(cambioDolarTxt.textContent);

    if (isNaN(bolivaresAcum)) bolivaresAcum = 0.00;

    bolivaresAcum += resultadoNum;
    bolivares.innerText = `${bolivaresAcum.toFixed(2)}`;

    let montoEnDolares = bolivaresAcum / tasa;
    dolares.innerText = `${montoEnDolares.toFixed(2)}`;

    precioRefTxt.value = '';
    precioBsTxt.innerText = '0.00';
});

document.getElementById('restar').addEventListener('click', function () {
    let bolivaresAcum = parseFloat(bolivares.textContent);
    let resultadoNum = parseFloat(precioBsTxt.textContent);
    let tasa = parseFloat(cambioDolarTxt.textContent);

    if (isNaN(bolivaresAcum)) bolivaresAcum = 0.00;

    if (resultadoNum <= bolivaresAcum) {
        bolivaresAcum -= resultadoNum;
        bolivares.innerText = `${bolivaresAcum.toFixed(2)}`;

        let montoEnDolares = bolivaresAcum / tasa;
        dolares.innerText = `${montoEnDolares.toFixed(2)}`;
    } else {
        alert("No se puede restar un monto mayor al acumulado.");
    }
});

document.getElementById('bye-bye').addEventListener('click', function () {
    // Reset accumulated values
    bolivares.innerText = `${'0.00'}`;
    dolares.innerText = `${'0.00'}`;

    // Reset input fields
    precioRefTxt.value = '';
    precioBsTxt.innerText = '0.00';
    precioDolarTxt.innerText = '0.00';

    // Uncheck checkboxes
    precioBsChk.checked = false;
    precioDolarChk.checked = false;
});

// -------------------------- TODO LIST --------------------------

// Info date
const dateNumber = document.getElementById('dateNumber');
const dateText = document.getElementById('dateText');
const dateMonth = document.getElementById('dateMonth');
const dateYear = document.getElementById('dateYear');

// Tasks container
const tasksContainer = document.getElementById('tasksContainer');

const setDate = () => {
	const date = new Date();
	dateNumber.textContent = date.toLocaleString('es', { day: 'numeric' });
	dateText.textContent =   date.toLocaleString('es', { weekday: 'long' });
	dateMonth.textContent =  date.toLocaleString('es', { month: 'short' });
	dateYear.textContent =   date.toLocaleString('es', { year: 'numeric' });
};

const addNewTask = (event) => {
	event.preventDefault();
	const { value } = event.target.taskText;
	if (!value) return;
	const task = document.createElement('div');
	task.classList.add('task', 'roundBorder');
	task.addEventListener('click', changeTaskState);
	task.textContent = value;
	tasksContainer.prepend(task);
	event.target.reset();
}

const changeTaskState = event => {
	event.target.classList.toggle('done');
}

const order = () => {
	const done = [];
	const toDo = [];
	tasksContainer.childNodes.forEach( el => {
		el.classList.contains('done') ? done.push(el) : toDo.push(el)		
	});
	return [...toDo, ...done];
}

const renderOrderedTasks = () => {
	order().forEach(el => tasksContainer.appendChild(el))
}	

const clearDoneTasks = () => {
	const doneTasks = tasksContainer.querySelectorAll('.done');
	doneTasks.forEach(task => task.remove());
};

setDate();
