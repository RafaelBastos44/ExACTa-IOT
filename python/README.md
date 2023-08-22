# Mosquitto broker

## Instalar mosquitto

Para instalar no Ubuntu, digite no terminal:

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install mosquitto mosquitto-clients
```

## Configurar o broker mosquitto

Abra o arquivo com algum editor de texto, segue o exemplo abaixo:

```
sudo nano /etc/mosquitto/conf.d/mosquitto.conf
```

Adicione as linhas abaixo ao arquivo e o salve:

```
listener 1883
allow_anonymous true
```

Adicione as permissões ao arquivo de configurações:

```
sudo chmod +rw /etc/mosquitto/conf.d/mosquitto.conf
```

## Iniciando o servidor broker

```
mosquitto --verbose --config-file /etc/mosquitto/conf.d/mosquitto.conf
```


## Testando

Caso não possua o paho-mqtt instado no python, use `pip install paho-mqtt` no terminal para instalar a dependencia.

Para iniciar, execute `python3 sub.py` em um terminal.

Para testar, altere a variável broker no arquivo `pub.py` para o endereço do servidor na rede e em seguida execute `python3 pub.py` em outro terminal. Confira se as mensagens foram enviadas e recebidas corretamente.

