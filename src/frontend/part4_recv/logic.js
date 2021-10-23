client_id = "client"+Date.now();
topic = "dk/sdu/sest/test";

// Create a client instance
client = new Paho.MQTT.Client("broker.hivemq.com", 8000, client_id);
client.onMessageArrived = onMessageArrived;
client.connect({onSuccess:onConnect});

function onConnect() {
  client.subscribe(topic);
}

function onMessageArrived(message) {
  document.getElementById("data").innerHTML = message.payloadString;
}

