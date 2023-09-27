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
    console.log("CSRF Token:", csrftoken);

    $(".configAr").click(function (e) {
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