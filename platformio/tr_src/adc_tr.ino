/*
Prototypical arduino/teensy code.
TODO: prepend zeros to outputs to make lines identical?
*/

#include "ADC.h"
#include "IntervalTimer.h"

// only the lines below needs to change
// first line does which analog channels to read,
// second line sets the sampling interval (in microseconds)
const unsigned int channel_array[2] = {A0, A7};
const unsigned long period_0 = 5000;

const unsigned int array_size = sizeof(channel_array) / sizeof(int);
unsigned int value_array[array_size];
unsigned int ii;

elapsedMicros current_time;
IntervalTimer timer_0;

ADC *adc = new ADC();

void setup() {
  for(ii = 0; ii < array_size; ii++) {
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
bool go_flag_copy = false;

FASTRUN void timerCallback(void) {
  go_flag = true;
}

void loop() {

  while(!go_flag_copy) {
    noInterrupts();
    go_flag_copy = go_flag;
    interrupts();
  }
  go_flag_copy = false;
  go_flag = false;


  for (ii = 0; ii < array_size; ii++) {
    value_array[ii] = adc->analogRead(channel_array[ii]);
  }

  // if s is missing, incomplete line!
  //Serial.print("s");
  //Serial.print("\t");
  Serial.print(current_time);
  Serial.print("\t");

  for (ii = 0; ii < array_size; ii++) {
    Serial.print(value_array[ii]);
    Serial.print("\t");
  }
  //Serial.print(current_time);
  Serial.print("\n");

}
