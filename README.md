# System Identification in Simulink

## Overview

This project focuses on system identification techniques implemented in Simulink, covering both non-parametric and parametric methods. The goal is to model and identify dynamic systems using different types of input signals and estimation approaches.

---

## Objectives

* Perform system identification in the time domain and frequency domain
* Analyze system behavior using different excitation signals
* Apply both non-parametric and parametric identification methods
* Compare multiple model structures and estimation techniques

---

## Methods Used

### 1. Non-Parametric Identification

* Step input signal

  * Identification based on linear regression (time domain)

* Chirp signal (VCO – Voltage Controlled Oscillator)

  * Identification based on the frequency response of the system

---

### 2. Parametric Identification

* SPAB / PRBS (Pseudo-Random Binary Signal) input
* Parameter estimation using:

  * ARX (Auto-Regressive with eXogenous input)
  * ARMAX (Auto-Regressive Moving Average with eXogenous input)
  * IV (Instrumental Variables)
  * OE (Output Error)
  * State-space models

---

## Tools and Technologies

* MATLAB
* Simulink
* System Identification Toolbox

---

## How to Run

1. Open MATLAB
2. Navigate to the project folder
3. Open the desired Simulink model (.slx)
4. Run the simulation
5. Use the provided scripts for analysis and identification

---

## Results

The project demonstrates how different input signals and identification methods influence the accuracy of the estimated model, highlighting the differences between time-domain and frequency-domain approaches.


