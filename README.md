# Materiale for SDU SE/ST Studiepraktik Program

Dette repositorie indeholder alt materiale til et fagligt forløb der introducerer elever med en gymnasial baggrund til at lave datadrevne hjemmesider med sproget JavaScript.

Det er bygget op omkring et såkaldt publish/subscribe mønster. IoT devices er blevet programmeret til at sende JSON objekter indeholdende sensordata ud over en seriel linje. En gateway modtager disse (og forkaster åbenlyst fejlformede input) og *publicerer* dem på en offentlig broker ([denne](http://www.mqtt-dashboard.com)). Eleverne udvikler herefter trinvist et dashboard der *subscriber* på denne datastrøm, behandler indkommende data og viser dem i en browser.

Repositoriet er struktureret således:
- [doc](doc) Kildekode for præsentationen (kræver make, latex, perl, python3, inkscape og [svgnarrative](https://pypi.org/project/svgnarrative/)).
- [src](src) Relevant kildekode, herunder:
  - [edge](src/edge) Kildekode til de edge devices der skal producerer sensorværdier.
  - [gateway](src/gateway) Kildekode til den gateway der modtager data fra disse edge devices og publicerer dem til den offentlige broker.
  - [frontend](src/frontend) Reference kildekode til samtlige trin i udviklingsprocessen for browserapplikationen.

