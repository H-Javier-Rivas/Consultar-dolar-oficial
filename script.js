const precioRefTxt = document.getElementById('precio-ref');
const cambioDolarTxt = document.getElementById('cambio-dolar');
const precioBsTxt = document.getElementById('precio-bs');
const precioUsdTxt = document.getElementById('precio-usd');
const bolivaresTotal = document.getElementById('bolivares');
const dolaresTotal = document.getElementById('dolares');
const precioBsChk = document.getElementById('precio-bs-chk');
const precioDolarChk = document.getElementById('precio-dolar-chk');
const tasksContainer = document.getElementById('tasksContainer');
const themeToggle = document.getElementById('theme-toggle');
const tasaChips = document.querySelectorAll('.tasa-chip');

let currentRateType = localStorage.getItem('dolarRateType') || 'bcv';
let exchangeRates = { bcv: 0, usdt: 0, manual: 0 };

// --- THEME MANAGEMENT ---
const initTheme = () => {
    const savedTheme = localStorage.getItem('dolarTheme') || 'dark';
    document.documentElement.setAttribute('data-theme', savedTheme);
    updateThemeIcon(savedTheme);
};

const updateThemeIcon = (theme) => {
    themeToggle.textContent = theme === 'dark' ? '🌙' : '☀️';
};

themeToggle.addEventListener('click', () => {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('dolarTheme', newTheme);
    updateThemeIcon(newTheme);
});

// --- EXCHANGE RATE LOGIC ---
async function fetchRates() {
    try {
        const [bcvRes, usdtRes] = await Promise.all([
            fetch("https://ve.dolarapi.com/v1/dolares/oficial"),
            fetch("https://ve.dolarapi.com/v1/dolares/paralelo")
        ]);
        const bcvData = await bcvRes.json();
        const usdtData = await usdtRes.json();
        
        exchangeRates.bcv = bcvData.promedio;
        exchangeRates.usdt = usdtData.promedio;
        
        const savedManual = localStorage.getItem('dolarManualRate');
        if (savedManual) exchangeRates.manual = parseFloat(savedManual);

        updateRateUI();
    } catch (error) {
        console.error('Error fetching rates:', error);
        cambioDolarTxt.textContent = 'Error';
    }
}

function updateRateUI() {
    tasaChips.forEach(chip => {
        chip.classList.toggle('active', chip.dataset.tasa === currentRateType);
    });

    const rate = exchangeRates[currentRateType];
    if (currentRateType === 'manual' && rate === 0) {
        promptManualRate();
    } else {
        cambioDolarTxt.textContent = rate ? rate.toFixed(2) : '---';
        updateCalculations();
    }
}

function promptManualRate() {
    const val = prompt("Ingresa la tasa manual (ej: 40.50):", exchangeRates.manual || "");
    if (val && !isNaN(val)) {
        exchangeRates.manual = parseFloat(val);
        localStorage.setItem('dolarManualRate', val);
        updateRateUI();
    } else if (exchangeRates.manual === 0) {
        currentRateType = 'bcv';
        updateRateUI();
    }
}

tasaChips.forEach(chip => {
    chip.addEventListener('click', () => {
        currentRateType = chip.dataset.tasa;
        localStorage.setItem('dolarRateType', currentRateType);
        if (currentRateType === 'manual') {
            promptManualRate();
        } else {
            updateRateUI();
        }
    });
});

// --- CALCULATIONS ---
function updateCalculations() {
    let inputVal = parseFloat(precioRefTxt.value) || 0;
    const rate = parseFloat(cambioDolarTxt.textContent) || 0;
    
    if (inputVal < 0) {
        precioRefTxt.value = '';
        inputVal = 0;
    }

    let subBs, subUsd;
    if (precioDolarChk.checked) {
        subUsd = inputVal;
        subBs = inputVal * rate;
    } else {
        subBs = inputVal;
        subUsd = rate > 0 ? inputVal / rate : 0;
    }

    precioBsTxt.textContent = subBs.toLocaleString('es-VE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    precioUsdTxt.textContent = subUsd.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

precioRefTxt.addEventListener('input', updateCalculations);
precioBsChk.addEventListener('change', updateCalculations);
precioDolarChk.addEventListener('change', updateCalculations);

// --- TOTALS MANAGEMENT ---
function modifyTotal(multiplier) {
    const rate = parseFloat(cambioDolarTxt.textContent) || 1;
    const currentSubBs = parseFloat(precioBsTxt.textContent.replace(/\./g, '').replace(',', '.')) || 0;
    let currentTotalBs = parseFloat(bolivaresTotal.textContent.replace(/\./g, '').replace(',', '.')) || 0;

    const newTotalBs = currentTotalBs + (currentSubBs * multiplier);
    
    if (newTotalBs < 0) {
        alert("El total no puede ser negativo.");
        return;
    }

    bolivaresTotal.textContent = newTotalBs.toLocaleString('es-VE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    dolaresTotal.textContent = (newTotalBs / rate).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

    precioRefTxt.value = '';
    updateCalculations();
    saveAppState();
}

document.getElementById('sumar').addEventListener('click', () => modifyTotal(1));
document.getElementById('restar').addEventListener('click', () => modifyTotal(-1));

document.getElementById('bye-bye').addEventListener('click', () => {
    if (confirm("¿Seguro que quieres limpiar todo?")) {
        bolivaresTotal.textContent = '0,00';
        dolaresTotal.textContent = '0.00';
        precioRefTxt.value = '';
        updateCalculations();
        saveAppState();
    }
});

// --- PERSISTENCE ---
function saveAppState() {
    const state = {
        bs: bolivaresTotal.textContent,
        usd: dolaresTotal.textContent
    };
    localStorage.setItem('dolarAppStateV2', JSON.stringify(state));
}

function loadAppState() {
    const saved = localStorage.getItem('dolarAppStateV2');
    if (saved) {
        const state = JSON.parse(saved);
        bolivaresTotal.textContent = state.bs;
        dolaresTotal.textContent = state.usd;
    }
}

// --- TODO LIST ---
const saveTasks = () => {
    const tasks = [];
    tasksContainer.querySelectorAll('.task').forEach(el => {
        tasks.push({
            text: el.querySelector('.task-text').textContent,
            done: el.classList.contains('done')
        });
    });
    localStorage.setItem('dolarTasksV2', JSON.stringify(tasks));
}

const loadTasks = () => {
    const saved = localStorage.getItem('dolarTasksV2');
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

window.addNewTask = (event) => {
    event.preventDefault();
    const input = event.target.taskText;
    if (!input.value.trim()) return;
    renderTask(input.value);
    input.value = '';
    saveTasks();
};

window.clearDoneTasks = () => {
    tasksContainer.querySelectorAll('.done').forEach(task => task.remove());
    saveTasks();
};

window.renderOrderedTasks = () => {
    const tasks = Array.from(tasksContainer.childNodes);
    tasks.sort((a, b) => a.classList.contains('done') - b.classList.contains('done'));
    tasks.forEach(el => tasksContainer.appendChild(el));
};

// --- INITIALIZATION ---
const setDate = () => {
    const date = new Date();
    document.getElementById('dateNumber').textContent = date.getDate();
    document.getElementById('dateText').textContent = date.toLocaleString('es', { weekday: 'long' });
    document.getElementById('dateMonth').textContent = date.toLocaleString('es', { month: 'short' });
    document.getElementById('dateYear').textContent = date.getFullYear();
};

document.addEventListener('DOMContentLoaded', () => {
    initTheme();
    setDate();
    fetchRates();
    loadTasks();
    loadAppState();
});
