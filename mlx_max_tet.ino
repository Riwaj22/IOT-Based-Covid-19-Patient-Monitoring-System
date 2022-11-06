#include <Arduino.h>
#include <Wire.h>
#include <SPI.h>
#include <Adafruit_MLX90614.h>
#include <Adafruit_GFX.h>
#include <Adafruit_PCD8544.h>
#include "MAX30100.h"
#include "MAX30100_PulseOximeter.h"

#define REPORTING_PERIOD_MS 1000
#define COMPENSATION 5
/*
 * Nokia 5510 display
 * Software SPI (slower updates, more flexible pin options):
 * pin D7 - Serial clock out (SCLK)
 * pin D6 - Serial data out (DIN)
 * pin D5 - Data/Command select (D/C)
 * pin D4 - LCD chip select (CS)
 * pin D3 - LCD reset (RST)
*/

// Initializing sensor objects
PulseOximeter pox;
MAX30100 sensor;
Adafruit_MLX90614 mlx = Adafruit_MLX90614();
Adafruit_PCD8544 lcd = Adafruit_PCD8544(D8, D4, D5, D6, D7);  // Adafruit_PCD8544(SCLK, DIN, DC, CS, RST);
//LiquidCrystal_I2C lcd = LiquidCrystal_I2C(0x27,16,2);// Variables

int temp_F, temp_C, heartRate, spo2;
uint32_t tsLastReport = 0;
//uint16_t ir = 0, red = 0;

void onBeatDetected() {

  Serial.println("Beat!");  
}

void setup() {
  delay(5000);

  // Initializing I2C protocol
  Wire.begin();    
  //Wire.setClock(100000);  // I2C clock set to 100KHz
  //Wire.setClock(400000);  // I2C clock set to 400KHz
  Serial.begin(9600);
  while(!Serial);
  
  // Initializing 5110
  lcd.begin();
  lcd.setContrast(75);
  lcd.setTextSize(1);
  lcd.setTextColor(BLACK);

  // Initializing mlx90614
  Serial.println("=================== MLX90614 testing ===================");

  if(!mlx.begin()) {
    Serial.println("Initializing MLX90614 failed.");
  }
  else {
    Serial.println("MLX90614 initialized successfully"); 
    Serial.print("Emissivity = "); Serial.println(mlx.readEmissivity());
    Serial.println("=========================================================");
  }
  
  delay(5000);

  // Initializing max30100
  Serial.println("=================== MAX30100 testing ====================");

  if(!pox.begin(PULSEOXIMETER_DEBUGGINGMODE_RAW_VALUES)) {
    Serial.println("MAX30100 failed to initialize");
  }
  else {
    Serial.println("MAX30100 initialized successfully");
  }

  //pox.setIRLedCurrent(MAX30100_LED_CURR_11MA);

  delay(5000);
  
  pox.setOnBeatDetectedCallback(onBeatDetected);
}

// Loop starts here
void loop() {
    // Oximeter reading
    // Make sure to call update as fast as possible
    pox.update();
    //sensor.update();
    //while (sensor.getRawValues(&ir, &red)) {}

    temp_F = mlx.readObjectTempF();
    temp_C = mlx.readObjectTempC();
    
  
    // Asynchronously dump heart rate and oxidation levels to the serial
    // For both, a value of 0 means "invalid"
    if (millis() - tsLastReport > REPORTING_PERIOD_MS) {
        heartRate = pox.getHeartRate(); // Heart rate 
        spo2 = pox.getSpO2(); // Oxygen concentration
        //temp_F = mlx.readObjectTempF() + COMPENSATION;  // Temperature
        //temp_C = mlx.readObjectTempC();
        tsLastReport = millis();
    }

    // Displaying in both serial monitor and lcd
    
    Serial.print("Heartbeat: "); Serial.print(heartRate); Serial.print(" SpO2: "); Serial.println(spo2);
    lcd.setCursor(0,0);
    lcd.print(heartRate);
    lcd.display();
    lcd.setCursor(32,0);
    lcd.print("bpm");
    lcd.setCursor(0,8);
    lcd.print(spo2);
    lcd.display();
    lcd.setCursor(32,8);
    lcd.print("%");
    lcd.display();
    
    Serial.print("Temperature: "); Serial.print(temp_F); Serial.print("*F, "); Serial.print(temp_C); Serial.println("*C");
    lcd.setCursor(0,16);
    lcd.print(temp_F);
    lcd.display();
    lcd.setCursor(32,16);
    lcd.print("*F");
    lcd.display();
    lcd.setCursor(0,24);
    lcd.print(temp_C);
    lcd.display();
    lcd.setCursor(32,24);
    lcd.print("*C");
    lcd.display();
  
    lcd.clearDisplay();
    delay(1000);
}
