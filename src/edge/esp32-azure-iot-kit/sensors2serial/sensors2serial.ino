#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_HTS221.h>
#include <Adafruit_Sensor.h>
#include <BH1750.h>

#define PIN_SDA 25
#define PIN_SCL 26

Adafruit_HTS221  hts;
Adafruit_MPU6050 mpu;
BH1750           lightMeter;

void setup() {
  Serial.begin(115200);

  // init serial
  Wire.setPins(PIN_SDA, PIN_SCL); // https://deepbluembedded.com/esp32-i2c-tutorial-change-pins-i2c-scanner-arduino/
  
  while (!Serial) delay(1000);     // will pause Zero, Leonardo, etc until serial console opens
  
  // init hts sensor
  if (!hts.begin_I2C()) {
    Serial.println("Failed to find HTS221 chip");
    while (1) { delay(10); }
  }
  
  // init mpu
  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }

  // configure mpu sensor
  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);
  
  // init light sensor
  lightMeter.begin(BH1750::ONE_TIME_HIGH_RES_MODE);
}

void loop() {
  // perform temperature and humidity measurements
  sensors_event_t temp;
  sensors_event_t humidity;
  hts.getEvent(&humidity, &temp);
  
  // perform motion measurements
  sensors_event_t a, g, temp2;
  mpu.getEvent(&a, &g, &temp2);
  
  // perform light measurements
  while (!lightMeter.measurementReady(true)) {
    yield();
  }
  float lux = lightMeter.readLightLevel();
  lightMeter.configure(BH1750::ONE_TIME_HIGH_RES_MODE);
  
  // send out results as JSON
  Serial.print("{");
  Serial.print("\"humidity\": ");
  Serial.print(humidity.relative_humidity);
  Serial.print(", ");
  Serial.print("\"temperature\": ");
  Serial.print(temp.temperature);
  Serial.print(", ");
  Serial.print("\"accel-x\": ");
  Serial.print(a.acceleration.x);
  Serial.print(", ");
  Serial.print("\"accel-y\": ");
  Serial.print(a.acceleration.y);
  Serial.print(", ");
  Serial.print("\"accel-z\": ");
  Serial.print(a.acceleration.z);
  Serial.print(", ");
  Serial.print("\"rot-x\": ");
  Serial.print(g.gyro.x);
  Serial.print(", ");
  Serial.print("\"rot-y\": ");
  Serial.print(g.gyro.y);
  Serial.print(", ");
  Serial.print("\"rot-z\": ");
  Serial.print(g.gyro.z);
  Serial.print(", ");
  Serial.print("\"light\": ");
  Serial.print(lux);
  Serial.print("}");
  Serial.println(""); 
}
