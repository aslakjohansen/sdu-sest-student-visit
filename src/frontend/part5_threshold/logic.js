client = new Paho.MQTT.Client("broker.hivemq.com", 8000, "client"+Date.now());
client.onMessageArrived = onMessageArrived;
client.connect({onSuccess:onConnect});

function onConnect() {
  client.subscribe("dk/sdu/sest/test");
}

function colorize(type, value) {
  if (type==="temperature" && value>25) {
    return '<span style="color:#bb2200;">'+value+'</span>';
  } else {
    return value;
  }
}

function onMessageArrived(message) {
  payload = JSON.parse(message.payloadString);
  keys = Object.keys(payload);
  
  result = "<p>Status:</p>";
  result += "<ul>";
  for (i=0 ; i<keys.length ; i++) {
    key = keys[i];
    value = payload[key];
    result += "<li><b>"+key+":</b> "+colorize(key, value)+"</li>";
  }
  result += "</ul>";
  
  document.getElementById("data").innerHTML = result;
}

