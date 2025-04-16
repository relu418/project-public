# Milestone Report

Ryan Lau (rwlau), Hong Lin (honglin)

Project Website: [Simulating Deformation Using a Parallelized Finite Element
Method](https://relu418.github.io/project-public/)

## 1. Work done so far

We have created a script that uses the `gmsh` program to convert a `.stl` 
file to a `.msh` file at various levels of granularity (i.e. number of 
tetrahedrons), which can then be consumed by our program. As a baseline, we then 
completed an sequential implementation of the DSM algorithm, where all
matrices were represented as simple dense arrays. 

We then began implementing an initial GPU version of the code. Calculation 
of the local stiffness matrices for each tetrahedron could be done 
independently with fixed size matrices and was thus embarassingly 
parallelizable. Subsequently, combining the local matrices into a global matrix 
required synchronization between threads, which we decided to resolve with 
atomic add operations. To speedup calculations and help with GPU memory 
constraints, we explored alternative matrix storage formats for the sparse 
global matrix, ultimately settling on the EllPack format for now. 

Finally, to solve for the nodal displacements involving a system of linear 
equations with the global matrix, we implemented the conjugate gradient 
method, parallelizing the EllPack matrix - vector multiplications by row.

## 2. Anticipated progress

Given the feedback on our proposal, we decided to self-implement the linear 
algebra operations necessary for computation,  as well as immediately begin 
with a 3-D version of the program (with each mesh element being tetrahedrons).

We believe that we should still be able to produce all our deliverables on 
time. Our remaining stretch goal, which is to produce a time-integrator, 
could be achieved by adding a simple loop around the code. At the moment we 
are uncertain whether the program would be able to simulate everything in real-
time.

## 3. List of goals for poster session and further explorations

- Explore different methods of allocating/parallelizing the 
  parallelized assembly of the global stiffness matrix
  - Coloring-based, to reduce impact of serialization from atomic operations 
    on the global stiffness matrix.
  - Assigning mesh elements to blocks such that elements sharing a vertex will 
    be, as much as possible, in the same block, to allow use of shared memory 
    and improve locality of memory accesses.
- Optimizing memory throughput in solving the global stiffness matrix.
  - Since the global stiffness matrix can be expressed as a matrix over $3 
    \times 3$ blocks, we could perform all operations over these blocks to 
    improve locality. However, it is unclear whether the odd size may lead 
    to non-optimal memory access patterns.

## 4. Poster session deliverables
+ Overview of the steps of the algorithm and calculations involved
+ Parallelization strategies and experiments we tried for each step
+ Insights into the strengths and weaknesses of each strategy we tried, and 
  an evaluation/comparison.
+ Speedup graphs over the sequential strategy with increasing mesh sizes. The graphs will also break down the speedup by step
+ Post-processed visualization of the calculated displacement/strains in the mesh

## 5. Preliminary results

We have only timed the code for the serial, CPU-based implementation using 
a dense representation.

| Nodes | Elements | Assemble (sec) | Solve (sec) | Convergence |
|-------|----------|----------------|-------------|-------------|
|    8  |    6     | 0.000132       | 0.2562      |   2700      |
|   14  |   24     | 0.000514       | 2.5381      |  11200      |
|   45  |  100     | 0.002091       | \>120       |  \>200000   |

Amdahl's law suggests that we prioritize optimizing the speedup of the 
solve stage. 

Since dense matrix-vector arithmetic has complexity $O(n^2)$ (where $n$ is the 
number of nodes), we expect to see a speedup once we switch to using the sparse 
ELLPACK format which is $O(n)$, assuming that the number of iterations to 
converge holds constant.

