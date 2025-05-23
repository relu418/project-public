# Project Schedule

- [x] March 31 - Apr 6
  - [x] Script for generation of mesh from `.stl` file to `.msh` files at
    varying granularity
  - [x] Code to read in and process mesh
  - [x] Implementation of initial serial algorithm
- [x] Apr 7 - Apr 15
  - [x] Initial parallelization of local stiffness matrix generation
  - [x] Initial parallelization of global stiffness matrix reduction and
    solving
    - Experiment with EllPack matrix format and conjugate gradient method
  - [x] Timing of serial CPU algorithm
  - [x] Milestone report due
- [x] Apr 16 - Apr 20
  - [x] Timing of initial GPU algorithm
  - [x] Experiment with blocking in ELLPACK format
  - [x] Experiment with graph-coloring 
- [x] Apr 21 - Apr 23
  - [x] Experiment with collocating elements with common vertices
  - [x] Output post-processing, stress visualization in ParaView
- [x] Apr 24 - Apr 27
  - [x] Experiment with ELLWARP format and optimizations
  - [x] Application of boundary forces
  - [x] Write final report, prepare poster
- [x] Apr 28
  - [x] Final report due
- [ ] Apr 29
  - [ ] Poster session
