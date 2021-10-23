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
  payload = JSON.parse(message.payloadString);
  keys = Object.keys(payload);
  
  result = "<p>Status:</p>";
  result += "<ul>";
  for (i=0 ; i<keys.length ; i++) {
    key = keys[i];
    value = payload[key];
    result += "<li><b>"+key+":</b> "+value+"</li>";
  }
  result += "</ul>";
  
  document.getElementById("data").innerHTML = result;
}

