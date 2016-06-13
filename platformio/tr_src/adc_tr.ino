/*
Prototypical arduino/teensy code.
*/

#include "ADC.h"
#include "IntervalTimer.h"

// only the lines below needs to change
// first line does which analog channels to read,
// second line sets the sampling interval (in microseconds)
const int channel_array[6] = {A0, A1, A2, A3, A4, A5};
const int period_0 = 2000;

const int array_size = sizeof(channel_array) / sizeof(int);
int value_array[array_size];

elapsedMicros current_time;
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
  adc->setResolution(16);
  adc->setConversionSpeed(ADC_HIGH_SPEED);
  adc->setSamplingSpeed(ADC_HIGH_SPEED);
  timer_0.priority(0);
  timer_0.begin(timerCallback, period_0);
  delay(500);
}

volatile bool go_flag = false;

FASTRUN void timerCallback(void) {
  go_flag = true;
}

void loop() {
  bool go_flag_copy = false;
  go_flag = false;
  for (int nn = 0; nn < array_size; nn++) {
    value_array[nn] = adc->analogRead(channel_array[nn]);
  }

  Serial.print(current_time);
  Serial.print("\t");

  for (int nn = 0; nn < array_size; nn++) {
    Serial.print(value_array[nn]);
    Serial.print("\t");
  }
  Serial.print(current_time);
  Serial.print("\n");

  while(!go_flag_copy) {
    noInterrupts();
    go_flag_copy = go_flag;
    interrupts();
  }
}
