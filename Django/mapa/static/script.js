document.addEventListener('DOMContentLoaded', function () {
    const decreaseButton = document.getElementById('decrease');
    const increaseButton = document.getElementById('increase');
    const numberInput = document.getElementById('number');
    const minValue = parseInt(numberInput.getAttribute('min'));
    const maxValue = parseInt(numberInput.getAttribute('max'));

    decreaseButton.addEventListener('click', function () {
        decreaseNumber();
    });

    increaseButton.addEventListener('click', function () {
        increaseNumber();
    });

    numberInput.addEventListener('blur', function () {
        validateNumber();
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
});

$(document).ready(function () {

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
        return cookieValue;
    }

    const csrftoken = getCookie('csrftoken');
    const modal = document.getElementById('configModal');

    console.log("CSRF Token:", csrftoken);

    $(".arCondicionado").click(function (e) {
        modal.style.display = 'block';
        console.log(csrftoken);
        e.preventDefault();
        var valor = $(this).data('valor');  // 
        $.ajax({
            type: "POST",
            url: "/arconfig/",
            data: {
                'chaveAr': valor,
                'csrfmiddlewaretoken': csrftoken
            },
            success: function () {
                //   alert(`Ar ${valor} configurado`);
            },
            error: function () {
                alert("Ocorreu um erro ao realizar o POST.");
            }
        });
    });
});