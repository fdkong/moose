[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 20
    ny = 20
    xmin = 0.05
    xmax = 1.2
    ymin = 0.05
    ymax = 1.1
  []
  [./subdomain]
    input = gmg
    type = SubdomainBoundingBoxGenerator
    bottom_left = '0.3 0.3 0'
    top_right = '0.7 0.7 0'
    block_id = 2
  [../]

  [Partitioner]
    type = PetscExternalPartitioner
    part_package = ptscotch
  []
[]

[Variables]
  [./u]
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]

  [./coupledforce]
    type = CoupledForce
    variable = u
    v = aux_u
    block = 2
  [../]
[]

[AuxKernels]
  [pid_aux]
    type = ProcessorIDAux
    variable = pid
    execute_on = 'INITIAL'
  []
[]

[AuxVariables]
  [./aux_u]
    block = 2
  [../]

  [pid]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0
  [../]
  [./right]
    type = DirichletBC
    variable = u
    boundary = right
    value = 1
  [../]
[]

[Postprocessors]
  [./to_postprocessor]
    type = ElementIntegralVariablePostprocessor
    variable = aux_u
    execute_on = 'transfer'
    block = 2
  [../]
[]

[Problem]
  type = FEProblem
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  nl_abs_tol = 1e-12
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true
[]
