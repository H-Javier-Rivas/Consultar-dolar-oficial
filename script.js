const precioRefTxt = document.getElementById('precio-ref');
const cambioDolarTxt = document.getElementById('cambio-dolar');
const precioBsTxt = document.getElementById('precio-bs');
const bolivaresTotal = document.getElementById('bolivares');
const dolaresTotal = document.getElementById('dolares');
const precioBsChk = document.getElementById('precio-bs-chk');
const precioDolarChk = document.getElementById('precio-dolar-chk');
const tasksContainer = document.getElementById('tasksContainer');

// --- TASA DE CAMBIO ---
async function getExchangeRate() {
    try {
        const response = await fetch("https://ve.dolarapi.com/v1/dolares/oficial");
        const data = await response.json();
        return data.promedio.toFixed(4);
    } catch (error) {
        console.error('Error al obtener la tasa:', error);
        return null;
    }
}

async function updateExchangeRate() {
    const exchangeRate = await getExchangeRate();
    if (exchangeRate) {
        cambioDolarTxt.textContent = exchangeRate;
        updateCalculations();
    } else {
        cambioDolarTxt.textContent = '⚠';
        const userRate = prompt("No se pudo obtener la tasa. Ingresa el valor manualmente (Ej: 36.50):");
        if (userRate && !isNaN(userRate)) {
            cambioDolarTxt.textContent = parseFloat(userRate).toFixed(4);
            updateCalculations();
        }
    }
}

// --- LÓGICA DE CÁLCULO ---
function updateCalculations() {
    let precioRef = parseFloat(precioRefTxt.value) || 0;
    const currentExchangeRate = parseFloat(cambioDolarTxt.textContent) || 0;
    
    if (precioRef < 0) {
        alert("No se permiten valores negativos.");
        precioRefTxt.value = '';
        precioRef = 0;
    }

    const subtotal = precioDolarChk.checked ? precioRef * currentExchangeRate : precioRef;
    precioBsTxt.innerText = subtotal.toLocaleString('es-VE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

precioRefTxt.addEventListener('input', updateCalculations);
precioBsChk.addEventListener('change', updateCalculations);
precioDolarChk.addEventListener('change', updateCalculations);

document.getElementById('sumar').addEventListener('click', () => {
    modifyTotal(1);
});

document.getElementById('restar').addEventListener('click', () => {
    modifyTotal(-1);
});

function modifyTotal(multiplier) {
    let currentTotal = parseFloat(bolivaresTotal.textContent.replace(/\./g, '').replace(',', '.')) || 0;
    let subtotalText = precioBsTxt.textContent.replace(/\./g, '').replace(',', '.');
    let subtotal = parseFloat(subtotalText) || 0;
    let tasa = parseFloat(cambioDolarTxt.textContent) || 1;

    let newTotal = currentTotal + (subtotal * multiplier);
    
    if (newTotal < 0) {
        alert("El total no puede ser negativo.");
        return;
    }

    bolivaresTotal.innerText = newTotal.toLocaleString('es-VE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    dolaresTotal.innerText = (newTotal / tasa).toFixed(2);

    precioRefTxt.value = '';
    precioBsTxt.innerText = '0,00';
    
    // Guardar estado en localStorage (opcional para el total)
    saveAppState();
}

document.getElementById('bye-bye').addEventListener('click', () => {
    if (confirm("¿Seguro que quieres limpiar todo?")) {
        bolivaresTotal.innerText = '0,00';
        dolaresTotal.innerText = '0.00';
        precioRefTxt.value = '';
        precioBsTxt.innerText = '0,00';
        saveAppState();
    }
});

// --- TODO LIST CON PERSISTENCIA ---
const saveTasks = () => {
    const tasks = [];
    tasksContainer.querySelectorAll('.task').forEach(el => {
        tasks.push({
            text: el.querySelector('.task-text').textContent,
            done: el.classList.contains('done')
        });
    });
    localStorage.setItem('dolarOficialTasks', JSON.stringify(tasks));
}

const loadTasks = () => {
    const saved = localStorage.getItem('dolarOficialTasks');
    if (saved) {
        const tasks = JSON.parse(saved);
        tasks.forEach(t => renderTask(t.text, t.done));
    }
}

const renderTask = (text, done = false) => {
    const task = document.createElement('div');
    task.classList.add('task');
    if (done) task.classList.add('done');
    
    task.innerHTML = `
        <span class="task-text">${text}</span>
        <span class="task-status">${done ? '✅' : '⏳'}</span>
    `;
    
    task.addEventListener('click', () => {
        task.classList.toggle('done');
        task.querySelector('.task-status').textContent = task.classList.contains('done') ? '✅' : '⏳';
        saveTasks();
    });
    
    tasksContainer.prepend(task);
}

const addNewTask = (event) => {
    event.preventDefault();
    const input = event.target.taskText;
    if (!input.value.trim()) return;
    
    renderTask(input.value);
    input.value = '';
    saveTasks();
}

const clearDoneTasks = () => {
    const doneTasks = tasksContainer.querySelectorAll('.done');
    doneTasks.forEach(task => task.remove());
    saveTasks();
};

const renderOrderedTasks = () => {
    const tasks = Array.from(tasksContainer.childNodes);
    tasks.sort((a, b) => a.classList.contains('done') - b.classList.contains('done'));
    tasks.forEach(el => tasksContainer.appendChild(el));
};

// --- DATA PERSISTENCE (TOTALS) ---
function saveAppState() {
    const state = {
        bolivares: bolivaresTotal.innerText,
        dolares: dolaresTotal.innerText
    };
    localStorage.setItem('dolarOficialState', JSON.stringify(state));
}

function loadAppState() {
    const saved = localStorage.getItem('dolarOficialState');
    if (saved) {
        const state = JSON.parse(saved);
        bolivaresTotal.innerText = state.bolivares;
        dolaresTotal.innerText = state.dolares;
    }
}

// --- FECHA ---
const setDate = () => {
    const date = new Date();
    document.getElementById('dateNumber').textContent = date.toLocaleString('es', { day: 'numeric' });
    document.getElementById('dateText').textContent = date.toLocaleString('es', { weekday: 'long' });
    document.getElementById('dateMonth').textContent = date.toLocaleString('es', { month: 'short' });
    document.getElementById('dateYear').textContent = date.toLocaleString('es', { year: 'numeric' });
};

// --- INIT ---
document.addEventListener('DOMContentLoaded', () => {
    setDate();
    updateExchangeRate();
    loadTasks();
    loadAppState();
});
