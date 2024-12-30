# FPGA-Driven Sine Wave Regeneration using ADC-DAC
## **Project Description**
This project demonstrates the design and implementation of a system capable of regenerating an analog sine wave using an FPGA and peripheral devices like ADC and DAC. The system employs the Serial Peripheral Interface (SPI) protocol to facilitate communication between the FPGA and external components.

The project is divided into three distinct tasks:

* VHDL Code Development for SPI Master and SPI Slave
* -  ADC to LCD via SPI
  -  SPI to DAC and multimeter
* Regeneration of Sine Wave using ADC - DAC

For more details on the problem statement, refer to the [Project Question Paper PDF].

## **Key Components**

| **Technology/Component**    | **Details**                                                                                          | **Quantitative Features**                                      |
|------------------------------|------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| **SPI (Serial Peripheral Interface)** | A synchronous, full-duplex protocol for short-distance communication.                           | - Signals: MOSI, MISO, SCLK, CS<br>- Clock Frequency: 1 MHz<br>- Configuration: Mode 0 (CPOL = 0, CPHA = 0) |
| **ADC (Analog-to-Digital Converter)**  | Component: MCP3008<br>Converts analog signals into 10-bit digital values.                       | - Resolution: 10 bits<br>- Input Voltage Range: 0–3.3V<br>- Sampling Rate: 200 kSPS |
| **DAC (Digital-to-Analog Converter)**  | Component: MCP4921<br>Converts 10-bit digital data back to analog form.                        | - Resolution: 10 bits<br>- Output Voltage Range: 0–3.3V<br>- Reference Voltage: 3.3V |
| **FPGA (Field-Programmable Gate Array)** | FPGA Board: XEN 10<br>Handles SPI Master implementation and ADC/DAC communication.       | - SPI Clock Frequency: 1 MHz<br>- Registers for Data Storage: 10-bit width |
| **LCD Display**              | Displays intermediate values, such as voltage calculated from ADC data.                             | - Display Units: Voltage (scaled using 3.3/1024) |

## **Task Workflow** 
### **Task 1** 
Implement SPI communication between Master and Slave.<br>

Files:


### **Task 2: ADC to DAC with LCD Display**
In this task, we interface the MCP3008 ADC, MCP4921 DAC, and an LCD display with an FPGA to convert and visualize analog voltage values. The potentiometer (0-3.3V) provides the analog input to the MCP3008, which converts it into a 10-bit digital value relative to a 3.3V reference. The FPGA, acting as the SPI master, receives the ADC output via SPI communication, and the digital value is transferred to the MCP4921 DAC, which converts it back to analog. The FPGA also calculates the voltage from the ADC’s digital output and displays it on the LCD.<br>

Files:


### **Task 3: Sine Wave Regeneration**
In this task, we reconstruct a sine wave by sampling it with the MCP3008 ADC, transmitting the digital data to the FPGA via SPI, and converting it back to an analog signal using the MCP4921 DAC. The AFG1300 function generator produces the sine wave, which is sampled by the ADC at a defined frequency. The FPGA, acting as the SPI master, receives the 10-bit digital data from the ADC and stores each sample in a register.

The FPGA then sends the stored data to the DAC via SPI, which reconstructs the sine wave in analog form. The regenerated sine wave is visualized on a Digital Storage Oscilloscope (DSO) to verify the accuracy of the reconstruction.<br>

Files:


## Software Used 
- **ModelSim**: Tool for simulating and debugging VHDL/Verilog designs.
- **Quartus Prime**: FPGA design software for synthesis, simulation, and programming.
