# PCAP_Lab_Project_GolombRulers
Parallel Programming Project : Golomb rulers

This project was created as a part of the course lab ”Parallel Computing and Programming”. The programs are parallelised using the standards MPI and CUDA, and its specifications are written down in the PDF attached as "Final Project Report".

Instructor : Ashwath Rao

How to run
In the Final project directory, just type the following commands


To run cuda code - 

	nvcc cuda.cu -o out
	./out

To run MPI code - 

	mpicc mpi.c -o mpi
	mpiexec -n 40 ./mpi

To run serial implementation -

	gcc serial.c -o output
	./output

You should have gcc, version 5.0 or above installed on your machine for serial implementation. 
To run CUDA code, NVIDIA GPU is required with nvcc installed.
To run MPI code, OpenMPI library must be installed on your machine.
