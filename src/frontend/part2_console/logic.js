console.log("Hello, World");

pi = 3.14
rs  = [1, 2, 3, 5, 8, 13]
for (i=0 ; i<rs.length ; i++) {
  radius = rs[i];
  area = pi*radius*radius;
  if (area<100) {
    console.log("Cirkel med radius "+radius+" har arealet "+area);
  } else {
    console.log("Cirkel med radius "+radius+" har for stort et areal");
  }
}
