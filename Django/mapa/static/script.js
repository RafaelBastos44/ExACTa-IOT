var idAr;

function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    else {
        console.log("ERRO :(")
    }
    return cookieValue;
}

function enviaConfiguracao(ligado) {
    const numberInput = document.getElementById('number');
    const modoInput = document.getElementById('modo');

    dados = {
        'idAr': idAr,
        'ligado': ligado,
        'tempAr': parseInt(numberInput.value),
        'modoAr': modoInput.value
    };

    fetch('/arconfig/', {
        method: 'POST',
        body: JSON.stringify(dados),
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRFToken': csrftoken
        }
    })
        .then(function (response) {
            if (response.ok) {
                console.log('POST bem-sucedido');
            } else {
                console.log('Ocorreu um erro ao realizar o POST.');
            }
        })
        .catch(function (error) {
            console.log('Erro de rede ao realizar o POST.');
        });
}


document.addEventListener('click', function (event) {
    const modal = document.getElementById('modal');
    const overlay = document.getElementById('overlay');
    var aresCondicionados = document.getElementsByClassName("arCondicionado");

    for (var i = 0; i < aresCondicionados.length; i++) {
        var arCondicionado = aresCondicionados[i];
        if (arCondicionado.contains(event.target)) {
            idAr = arCondicionado.getAttribute('data-idAr');
            document.getElementById('idAr').textContent = idAr;
            console.log(`Clicou no Ar ${idAr}`);
            modal.style.display = 'flex';
            overlay.style.display = 'block';
            return;
        }
    }

    if (modal.style.display != 'none') {
        if (!modal.contains(event.target)) {
            console.log("Fora do modal");
            modal.style.display = 'none';
            overlay.style.display = 'none';
        }
    }
});

document.addEventListener('DOMContentLoaded', function () {
    const decreaseButton = document.getElementById('decrease');
    const increaseButton = document.getElementById('increase');
    const numberInput = document.getElementById('number');
    const submitButton = document.getElementById('botao-submit');
    const offButton = document.getElementById('botao-off');
    const closeModal = document.getElementById('close-modal');

    const minValue = parseInt(numberInput.getAttribute('min'));
    const maxValue = parseInt(numberInput.getAttribute('max'));

    submitButton.addEventListener('click', function () {
        enviaConfiguracao("ON")
    });
    offButton.addEventListener('click', function () {
        enviaConfiguracao("OFF")
    });

    decreaseButton.addEventListener('click', function () {
        decreaseNumber();
    });

    increaseButton.addEventListener('click', function () {
        increaseNumber();
    });

    numberInput.addEventListener('blur', function () {
        validateNumber();
    });

    closeModal.addEventListener('click', function () {
        document.getElementById('modal').style.display = 'none';
        document.getElementById('overlay').style.display = 'none';
    });

    function decreaseNumber() {
        let currentValue = parseInt(numberInput.value);

        if (currentValue > minValue) {
            currentValue--;
            numberInput.value = currentValue;
        }
    }

    function increaseNumber() {
        let currentValue = parseInt(numberInput.value);

        if (currentValue < maxValue) {
            currentValue++;
            numberInput.value = currentValue;
        }
    }

    function validateNumber() {
        let currentValue = parseInt(numberInput.value);

        if (isNaN(currentValue)) {
            currentValue = minValue;
        } else if (currentValue < minValue) {
            currentValue = minValue;
        } else if (currentValue > maxValue) {
            currentValue = maxValue;
        }

        numberInput.value = currentValue;
    }

    csrftoken = getCookie('csrftoken');
    console.log(`Token: ${csrftoken}`);
});
