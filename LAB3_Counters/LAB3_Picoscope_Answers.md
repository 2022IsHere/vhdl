Measure the following: 

Frequency of the LSb (least significant bit) on jb. 37.5 MHz - This shows incorrect result because of aliasing,
the picoscope 2025A has a limitation of 100 Ms/s sample rate which falls short with our (62.5) experiment's requirements 

Frequency of the MSb (most significant bit) on jb Most significant (5th bit of Jb) is 4.8Mhz

Frequency of the MSb (most significant bit) on ja. 488 kHz

Pulse ratio of the MSb on jb ( = duty cycle, i.e. how many % of the time the signal is high). 

Pulse ratio of the Msb on ja.

Q1: Based on the measurement results, what is the frequency of sysclk? 
2nd bit of Ja's frequency is 31.23MHz so our system clock is 4 times the value of it. 31.23 * 4 = 124.92 MHz

Q2: Explain the pulse ratio of MSb of jb. 

Signal for ja exhibits a nearly symmetrical duty cycle with a slight bias towards the "on" or high phase, showing a positive duty cycle of 50.39% and a negative duty cycle of 49.61%.
This close to equal distribution between the "on" and "off" phases is a result of ja being incremented continuously, without any reset condition, making the signal oscillate between 0 and 255.

Signal  for jb, the duty cycle was found to be more skewed with a negative duty cycle of 61.06% and a positive duty cycle of 38.94%.
This imbalance arises from the reset condition in jb, where it resets to 0 after reaching 25 instead of counting up to 31.
This means jb spends more time in the lower half of its range (0 to 15) as compared to the upper half (16 to 25), thus causing the asymmetry in its duty cycle.
