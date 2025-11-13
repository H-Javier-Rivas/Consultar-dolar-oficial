const precioRefTxt = document.getElementById('precio-ref');
const cambioDolarTxt = document.getElementById('cambio-dolar');

const precioBsTxt = document.getElementById('precio-bs');
const precioDolarTxt = document.getElementById('precio-dolar');

const bolivares = document.getElementById('bolivares');
const dolares = document.getElementById('dolares');

const precioBsChk = document.getElementById('precio-bs-chk');
const precioDolarChk = document.getElementById('precio-dolar-chk');

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
        //return tasa = 81.00;
    }
}

// Función para actualizar la tasa de cambio
async function updateExchangeRate() {
    const exchangeRate = await getExchangeRate();
    if (exchangeRate) {
        cambioDolarTxt.textContent = exchangeRate;
    } else {
        cambioDolarTxt.textContent = '⚠';
        const userRate = prompt("No se pudo obtener la tasa de cambio. Por favor, ingrese la tasa manualmente:");
        if (userRate && !isNaN(userRate)) {
            cambioDolarTxt.textContent = parseFloat(userRate).toFixed(4);
        } else {
            alert("Tasa inválida. Por favor, recargue la página e intente nuevamente.");
        }
    }
}

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
