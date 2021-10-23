data = {"temp": 21.3, "hum": 61.7};
result = "<p>Indhold:</p>";

keys = Object.keys(data);
result += "<ul>";
for (i=0 ; i<keys.length ; i++) {
  key = keys[i];
  value = data[key];
  result += "<li><b>"+key+"</b> peger på <i>værdien</i> "+value+".</li>";
}
result += "</ul>";

if ('temp' in data)
  result += "<p>data inddeholder nøglen 'temp'</p>";
if ('wind' in data)
  result += "<p>data inddeholder nøglen 'wind'</p>";

document.getElementById("data").innerHTML = result;
