# Proposal: Simulating Deformation Using a Parallelized Finite Element Method

Ryan Lau (rwlau), Hong Lin (honglin)

Project Website: [Simulating Deformation Using a Parallelized Finite Element
Method]()

## 1. Summary

This project aims to implement the direct stiffness method of the Finite Element
Method (FEM) in CUDA to simulate material deformation under pressure or impact.
We will leverage GPU parallelism to accelerate the computation of element
stiffness matrices, assembly of the global stiffness matrix, and solution of the
resulting linear system.

## 2. Background

The Finite Element Method (FEM) is a commonly used method in engineering and
physics to solve complex partial differential equations numerically by
splitting the input domain into smaller, discrete finite elements. It can be
used to simulate physical phenomena such as heat transfer, fluid dynamics
and Maxwell's Equations.

However, most modern FEM solvers like OpenEMS and Autodesk FEA do not
support GPU acceleration. In this project, we will focus on the Direct
Stiffness Method, an application of FEM for calculating the stresses and
deformation of a materials. Our program will take in a pre-generated mesh
with material properties for an object and calculate its deformation under
load or impact.

The main steps of the algorithm are as follows:

1. **Compute the local stiffness matrices for each element:** The elastic
   modulus of a material captures the linear relationship between how much an
   object deforms, to the stress that it experiences. When considered in terms
   of a mesh, it expresses a linear relationship between the displacement of
   each mesh element's vertices, the forces and moments exerted on the
   element by neighboring elements, and external forces (such as gravity or
   impact). This step therefore involves capturing geometric data such as
   distances and angles into a matrix, and is inherently highly parallelizable
   over elements. The dimensions of the local stiffness matrix is related to the
   degrees of freedom.
2. **Assemble the global stiffness matrix:** When considering neighboring
   elements, the common vertices must be displaced equally. The forces
   between two neighboring elements should also be equal and opposite by
   Newton's third law. Summing over the forces and factorizing out the
   common displacements leaves us another system of linear equations which
   relate the displacement of each vertex, the neighborhood of each element,
   and the external forces on the system, known as the global stiffness
   matrix. The global stiffness matrix is sparse as contributions are only
   made when a pair of elements are neighbors.
3. **Solving the global stiffness matrix:** This allows us to obtain the
   displacement of each vertex, showing how the material deforms.

## 3. The Challenge

We intend to apply the direct stiffness method to various non-uniform meshes.
Due to the lack of symmetry, this results in a non-trivial amount of
computation, which poses the following challenges when parallelizing:

1. **Data dependencies:** As the global stiffness matrix is sparse, we should
   be using sparse representations to reduce the complexity of the memory
   footprint with a large mesh. This makes it nontrivial to parallellize the
   assembly of the global stiffness matrix as shared memory writes and the
   potential for data races dictate a need for synchronization.
2. **Memory access patterns:** Sparse matrix representations are typically
   non-contiguous. Furthermore, non-uniform mesh geometries will introduce
   irregular memory access patterns that have to be carefully considered
   during implementation, to ensure high performance. We would also have to
   consider how the mesh geometry affects the locality of memory accesses.
3. **Scaling:** With large meshes, there could be significant memory
   pressure. We would have to carefully consider how we can store, transform,
   and move data while keeping all the data on the device memory.
4. **Solving:** Solving a sparse linear system of equations may be
   nontrivial depending on the representation. There may be some sequential
   bottlenecks.
5. **Assigning elements to kernels:** With a non-uniform mesh, it is
   nontrivial to assign elements to kernels if we want to ensure a balanced
   workload.

## 4. Resources

Initial generation of the finite element mesh for input into our
program will be done through open source programs
like [Gmsh](https://gmsh.info/).

For the initial serial implementation of the Direct Stiffness Method, we
will reference
[existing online implementations](https://github.com/rvcristiand/pymas) and
[articles](https://vtechworks.lib.vt.edu/server/api/core/bitstreams/cbd052db-a6c1-41f6-9f3e-b3b38ccd0a33/content).

For linear algebra operations we will use matrix libraries such as cuBLAS
and cuSOLVER.

The final output of our program should be visualizable through software like
ParaView.

The GHC RTX 2080 clusters should be sufficient for the development and
testing of our parallelized CUDA code.

## 5. Goals and Deliverables

### 5.1 Plan to achieve

1. Parallel procedure to generate local stiffness matrices
2. Parallel procedure to assemble global stiffness matrix
3. Use linear algebra libraries to solve the global stiffness matrix with
   GPU acceleration
4. Visualize output of program

### 5.2 Stretch goals

1. Extend the solver to 3 dimensions from 2. This will result in more
   degrees of freedom, larger stiffness matrices and more computation.
2. Implement an integrator that runs the program every $\Delta t$ timestep
   to produce an animation of the deformation over time following an impact.

## 5.3 Platform Choice

We will implement our algorithm in C++ and CUDA. CUDA is ideal for the
direct stiffness method due to the many identical computations that have to be
done on thousands of mesh elements, which should benefit the most from the
large number of concurrent threads available in a GPU. Since data must be
read from a mesh and reduced to a single global stiffness matrix, optimizing
the high-bandwidth memory of a GPU will also be key for performance.

## Schedule

+ March 31 - Apr 6
    - Code to read in and process mesh
    - Implementation of initial serial algorithm
+ Apr 7 - Apr 13
    - Initial parallelization of local stiffness matrix generation
    - Profiling and optimization
+ Apr 14 - Apr 20
    - Initial parallelization of global stiffness matrix reduction and solving
    - Profiling and optimization
    - Milestone report due
+ Apr 21 - Apr 27
    - Code output of program for visualization in ParaView
    - Write final report, prepare poster
    - Stretch goals
+ Apr 28
    - Final report due
+ Apr 29
    - Poster session

