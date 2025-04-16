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
- [ ] Apr 16 - Apr 20
  - [ ] Timing of initial GPU algorithm
  - [ ] Experiment with blocking in ELLPACK format
  - [ ] Experiment with graph-coloring 
- [ ] Apr 21 - Apr 23
  - [ ] Experiment with collocating elements with common vertices
  - [ ] Output post-processing, stress visualization in ParaView
- [ ] Apr 24 - Apr 27
  - [ ] Time-integrator loop
  - [ ] Write final report, prepare poster
- [ ] Apr 28
  - [ ] Final report due
- [ ] Apr 29
  - [ ] Poster session
