document.getElementById("data").innerHTML = "<p>Hello, World</p>";

pi = 3.14
rs  = [1, 2, 3, 5, 8, 13]
for (i=0 ; i<rs.length ; i++) {
  radius = rs[i];
  area = pi*radius*radius;
  if (area<100) {
    entry = "<p>Cirkel med radius "+radius+" har arealet "+area+"</p>";
  } else {
    entry = "<p>Cirkel med radius "+radius+" har for stort et areal</p>";
  }
  document.getElementById("data").innerHTML += entry
}
