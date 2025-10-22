# ASCON-AEAD128

## Overview
This project implements the **ASCON-AEAD128 authenticated encryption algorithm** in **SystemVerilog**.  
ASCON was selected by **NIST** as the standard for lightweight cryptography.  
The goal of this work was to design, simulate, and verify a **complete hardware model** of the algorithm, using a **finite-state machine (FSM)** to control all stages of encryption.

> This project was completed as part of the *“Conception des Systèmes Numériques”* course  
> at **Mines Saint-Étienne (ISMIN, 1st year)**.

---

##  Architecture

The top-level module `ascon_top.sv` integrates all major components required to perform authenticated encryption:

- **FSM (Finite State Machine):** controls the algorithm flow (initialization, processing, finalization).  
- **Permutation Blocks:**  
  - `pc.sv` — constant addition  
  - `ps.sv` — substitution (S-box layer)  
  - `pl.sv` — linear diffusion  
- **XOR blocks:** `xor_begin` and `xor_end` handle mixing of key and data at specific stages.  
- **Registers:** store the internal 320-bit state, cipher text, and authentication tag.  
- **Permutation_finale.sv:** integrates all transformation stages and output registers.

The module takes as input the **key**, **nonce**, and **plaintext**, and outputs the **cipher text** and **authentication tag**.

---

##  FSM Description

The FSM manages the full encryption sequence.
Each state activates control signals (permutation start, XOR enable, register write) to ensure synchronization with the system clock.

Although a **block counter** was planned to manage multi-block messages, it was not implemented due to time constraints.  
However, the FSM sequencing guarantees correct behavior for two encryption blocks.

---

##  Simulation & Verification

All modules were **individually simulated** using **ModelSim**:
- Constant addition (`pc.sv`), substitution (`ps.sv`), and diffusion (`pl.sv`) were validated against official **ASCON reference vectors**.
- The **final permutation** and **FSM integration** were validated using the `ascon_top_tb.sv` testbench.
- The **cipher text and authentication tag** outputs matched the expected NIST results.

---

##  Tools & Environment

| Category | Tools |
|-----------|--------|
| Language | SystemVerilog |
| Simulation | ModelSim |

---

##  Difficulties & Improvements

###  Synchronization
- Managing correct timing of XOR and register writes was challenging.
- Adjustments were made to ensure proper data capture on the correct clock edge.

###  Missing Block Counter
- The FSM currently handles a fixed number of rounds.
- Future improvement: implement a **dynamic block counter** to support variable-length messages.

---

##  Results
- Full hardware simulation of **ASCON-AEAD128 encryption**.  
- Functional validation using **NIST reference test vectors**.  
- Modular design with clear hierarchy and reusability.  
- Enhanced understanding of **cryptographic hardware design**.

---

##  Conclusion
This project provided a hands-on implementation of the **ASCON-AEAD128** algorithm in hardware, demonstrating:
- A complete FSM-controlled architecture,
- Validated modular design,
- Understanding of synchronization and state sequencing in digital systems.

It served as an excellent introduction to **hardware cryptography** and **SystemVerilog modeling**.

---

##  Contributors
- **Hamza Belarbi**  

