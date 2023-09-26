# Mosquitto broker

## Instalar mosquitto

Para instalar no Ubuntu, digite no terminal:

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install mosquitto mosquitto-clients
```

## Iniciando o servidor broker

Estando no mesmo diretório que o arquivo `mosquitto.conf`, digitte no terminal para iniciar o broker:

```
mosquitto --config-file mosquitto.conf
```

Para encerrar mosquittos que estejam rodando em segundo plano, digite:

```
sudo killall mosquitto
```

## Testando

Caso não possua o paho-mqtt instado no python, use `pip install paho-mqtt` no terminal para instalar a dependencia.

Para iniciar, execute `python3 sub.py` em um terminal.

Para testar, altere a variável broker no arquivo `pub.py` para o endereço do servidor na rede e em seguida execute `python3 pub.py` em outro terminal. Confira se as mensagens foram enviadas e recebidas corretamente.

