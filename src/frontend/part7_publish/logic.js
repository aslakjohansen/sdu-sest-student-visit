function clicked() {
  client_id = "mqtt_producer_"+(new Date()).getTime()
  topic   = document.getElementById("topic").value
  payload = document.getElementById("payload").value

  function callback () {
    msg = new Paho.MQTT.Message(payload);
    msg.destinationName = topic;
    client.send(msg);
  }

  // Create a client instance
  client = new Paho.MQTT.Client("broker.hivemq.com", 8000, client_id);
  client.connect({onSuccess:callback}); 
}
