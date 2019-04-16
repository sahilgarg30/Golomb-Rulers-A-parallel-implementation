# PCAP_Lab_Project_GolombRulers
Parallel Programming Project : Golomb rulers

This project was created as a part of the course lab ”Parallel Computing and Programming”. The programs are parallelised using the standards MPI and CUDA, and its specifications are written down in the PDF attached as "Final Project Report".

Instructor/Mentor : Ashwath Rao (Professor, Manipal Institute of Technology, Manipal)

How to run
In the Final project directory, just type the following commands


To run cuda code - 

	nvcc cuda.cu -o out
	./out

To run MPI code - 

	mpicc mpi.c -o mpiout
	mpiexec -n 40 ./mpiout

To run serial implementation -

	gcc serial.c -o output
	./output

You should have gcc, version 5.0 or above installed on your machine for serial implementation. 
To run CUDA code, NVIDIA GPU is required with nvcc installed.
To run MPI code, OpenMPI library must be installed on your machine.

The problem under discussion is a combinatorial optimisation problem, believed (although not yet proven) to be NP-Hard and even the most efficient parallel algorithms (and their implementations) of today, require years of running time to solve instances with n > 24. Besides exposing ourselves to the already known embarrassingly parallel nature of the OGR-n problem, our parallelisation efforts will additionally allow us for arbitrary selection of the amount of work assigned to each computational node. For the optimal Golomb ruler construction problem, all the sequences are not equivalent : we will have to minimise the length of the constructed solutions as a cost function.

Our main purpose in this project is to solve the OGR-n problem with a parallel algorithm. We first obtain the design of a sequential algorithm for OGR-n, which we will subsequently go on to parallelise in the future stages.

In this project, a construction of the Golomb optimal rulers is studied with a tree search approach. Improvements to the basic algorithm are understood and it is parallelised using global as well as shared memory. The application associated to this approach is written in C using the standard CUDA and MPI libraries. The algorithm will use collaborative mechanisms between processors with effective load balancing.

