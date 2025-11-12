# FIAMMA

## Overview

FIAMMA is a specialized MATLAB-based computational tool designed to model and analyze the dynamics of diffusion flames and estimate their Flame Transfer Functions (FTFs). I started developing this project during my PhD at Imperial College London in Prof. Morgans’ lab. Since the start of the project, multiple codes have been developed to address different scenarios. The structure of the project reflects these different branches.

## Objective

The primary objective of FIAMMA is to provide a modular MATLAB project for studying different variants of diffusion flames.

## Key Features

- **Customizable Domain Parameters**  
  FIAMMA allows users to define the physical dimensions of the combustion domain, including the fuel inlet, oxidizer inlet, and overall geometry. This flexibility enables the simulation of various flame geometries, sizes, and configurations.

- **Boundary Condition Specification**  
  Users can set specific boundary conditions for both the fuel and oxidizer sides, providing control over the composition of the reactants entering the combustion domain.

- **Velocity Boundary Conditions**  
  The tool allows the specification of inlet velocities for both fuel and oxidizer streams, enabling the study of flame behavior under different flow conditions.

- **Forcing Inputs**  
  FIAMMA v1.0 includes functionality to apply perturbations at specified frequencies and amplitudes, facilitating the analysis of flame response to external disturbances.

## Modeling Approach

FIAMMA employs different variations of the conservation equations for mass, species, mixture fraction, momentum, energy, or combinations of these, depending on the specific modelling assumptions. Most versions of the code use finite-difference methods to solve the equations. Variants for steady and unsteady simulations are available in the time domain. Finite-element and frequency-domain simulations are among the ideas planned for future development.

## User Interface and Experience

Designed with user-friendliness in mind, FIAMMA features a clear and intuitive code structure. Users can easily input parameters, execute simulations, and visualize results. The tool’s modular structure enables users to modify or extend its capabilities, allowing for customization to meet specific research needs.

## Application and Relevance

The ability to accurately model and predict the behavior of jet diffusion flames is of paramount importance in numerous industrial applications, including power generation, aerospace, and manufacturing. FIAMMA’s modeling capabilities make it a valuable tool for researchers and engineers working in these areas. By providing insights into flame stability and dynamics, it supports the development of more efficient and safer combustion systems.

## Technical Specifications

FIAMMA is written in MATLAB. Specific toolboxes might be required for different variations of the code.

## Getting Started

To begin using FIAMMA v1.0, users need a working installation of MATLAB. After loading the tool, users can follow the provided guide and input their specific parameters for the combustion domain, boundary conditions, and forcing inputs.

## Contact and Support

For technical support, queries, or feedback, please contact me.
