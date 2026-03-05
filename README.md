# Architecture Project — Pipeline Processor 

## Contents

- **projectArch/** — Active-HDL project (Verilog pipeline processor design)
- **Arch_Report_1220184_1220871_1220031.pdf** — Project report 

## Design overview

Verilog implementation of a **pipelined processor** with:

- **Stages:** Fetch, Decode, Execute, Memory, Write-Back  
- **Pipeline buffers:** IF/ID, ID/EX, EX/MEM, MEM/WB  
- **Hazard handling:** Forwarding unit, stall unit, kill unit, hazard control  
- **Components:** ALU, register file, instruction/data memory, control unit, PC control

## Tools

- **Aldec Active-HDL** (or compatible Verilog simulator) for simulation and synthesis.

## How to run

1. Open `projectArch/proccessor.wsp` (or the main workspace) in Active-HDL.
2. Compile and run simulation as per your course instructions.

## Report

See `Arch_Report_1220184_1220871_1220031.pdf` in this repository for design description and results.
