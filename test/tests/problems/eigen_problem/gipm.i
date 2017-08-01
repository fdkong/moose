[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = 0
  xmax = 100
  ymin = 0
  ymax = 100
  elem_type = QUAD4
  nx = 8
  ny = 8

  displacements = 'x_disp y_disp'
[]

#The minimum eigenvalue for this problem is 2*(pi/a)^2 + 2 with a = 100.
#Its inverse will be 0.49950700634518.

[Variables]
  [./u]
    order = first
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./x_disp]
  [../]
  [./y_disp]
  [../]
[]

[AuxKernels]
  [./x_disp]
    type = FunctionAux
    variable = x_disp
    function = x_disp_func
  [../]
  [./y_disp]
    type = FunctionAux
    variable = y_disp
    function = y_disp_func
  [../]
[]

[Functions]
  [./x_disp_func]
    type = ParsedFunction
    value = 0
  [../]
  [./y_disp_func]
    type = ParsedFunction
    value = 0
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
    use_displaced_mesh = true
  [../]

  [./rea]
    type = CoefReaction
    variable = u
    coefficient = 2.0
    use_displaced_mesh = true
  [../]

  [./rhs]
    type = Reaction
    variable = u
    use_displaced_mesh = true
    eigen_kernel = true
  [../]
[]

[BCs]
  [./homogeneous]
    type = DirichletBC
    variable = u
    boundary = '0 1 2 3'
    value = 0
    use_displaced_mesh = true
  [../]
[]

[Problem]
  type = EigenProblem
  eigen_problem_type = gen_non_hermitian
  n_eigen_pairs = 1
  n_basis_vectors = 18
  which_eigen_pairs = TARGET_MAGNITUDE
[]

[Executioner]
  type = Steady
  eigen_solve_type = MF_NONLINEAR_POWER
  petsc_options = '-eps_view -eps_power_snes_monitor -eps_power_ksp_monitor'
  petsc_options_iname = '-eps_max_it -eps_power_snes_max_it
  -eps_power_snes_rtol  -eps_power_ksp_rtol -eps_power_ksp_pc_side -eps_power_snes_linesearch_type'
  petsc_options_value = '2 1 1.0 1e-02 right basic'
[]

[VectorPostprocessors]
  [./eigenvalues]
    type = Eigenvalues
    execute_on = 'timestep_end'
  [../]
[]

[Outputs]
  csv = true
  execute_on = 'timestep_end'
  [./console]
    type = Console
    outlier_variable_norms = false
  [../]
  print_perf_log = true
[]
