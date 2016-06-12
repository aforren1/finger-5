/*
Prototypical arduino/teensy code.
TODO: Pass number of analog channels at
compile time?
*/

#include "ADC.h"
#include "IntervalTimer.h"

// only the line below needs to change for adding or removing channels
const int channel_array[6] = {A0, A1, A2, A3, A4, A5};

const int array_size = sizeof(channel_array) / sizeof(int);
int value_array[array_size];

const unsigned long time_0 = millis();
const int period_0 = 5000;
IntervalTimer timer_0;

ADC *adc = new ADC();

void setup() {
  for(int ii = 0; ii < array_size; ii++) {
    pinMode(channel_array[ii], INPUT);
  }

  Serial.begin(9600);
  delay(1000);

  adc->setReference(ADC_REF_3V3, ADC_0);
  adc->setAveraging(8);
  adc->setResolution(12);
  adc->setConversionSpeed(ADC_HIGH_SPEED);
  adc->setSamplingSpeed(ADC_HIGH_SPEED);
  timer_0.priority(10);
  timer_0.begin(timerCallback, period_0);
  delay(500);
}

volatile bool go_flag = false;

void timerCallback(void) {
  go_flag = true;
}

void loop() {
  bool go_flag_copy = false;
  go_flag = false;
  for (int nn = 0; nn < array_size; nn++) {
    value_array[nn] = adc->analogRead(channel_array[nn]);
  }

  Serial.print((long)(millis() - time_0));
  Serial.print("\t");

  for (int nn = 0; nn < array_size; nn++) {
    Serial.print(value_array[nn]);
    Serial.print("\t");
  }
  Serial.print("\n");
  
  while(!go_flag_copy) {
    noInterrupts();
    go_flag_copy = go_flag;
    interrupts();
  }
}
