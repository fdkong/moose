[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 20
    ny = 20
  []
  [./subdomain]
    input = gmg
    type = SubdomainBoundingBoxGenerator
    bottom_left = '0.3 0.3 0'
    top_right = '0.7 0.7 0'
    block_id = 2
  [../]
[]

[Variables]
  [./u]
  [../]
[]

[AuxVariables]
  [./us]
   block = 2
  [../]
  [pid]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [./us]
    type = ParsedAux
    variable = us
    args = 'u'
    function = 'u'
    block = 2
  [../]

  [pid_aux]
    type = ProcessorIDAux
    variable = pid
    execute_on = 'INITIAL'
  []
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
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

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[MultiApps]
  [./sub]
    type = FullSolveMultiApp
    input_files = sub_subdomain_conservative_transfer.i
    execute_on = timestep_end
  [../]
[]

[Postprocessors]
  [./from_postprocessor]
    type = ElementIntegralVariablePostprocessor
    variable = u
    block = 2
  [../]
[]

[Transfers]
  [./to_sub]
    type = MultiAppMeshFunctionTransfer
    direction = to_multiapp
    source_variable = u
    variable = aux_u
    multi_app = sub
    from_postprocessors_to_be_preserved  = 'from_postprocessor'
    to_postprocessors_to_be_preserved  = 'to_postprocessor'
  [../]
[]

[Outputs]
  exodus = true
  [./console]
    type = Console
#    execute_postprocessors_on = 'INITIAL nonlinear TIMESTEP_END'
  [../]
[]
