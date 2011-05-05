[Mesh]
  file = sq-2blk.e
[]

[Variables]
  active = 'u'

  [./u]
    order = FIRST
    family = MONOMIAL
    
    [./InitialCondition]
      type = ConstantIC
      value = 1 
    [../]
  [../]
[]

[Functions]
  active = 'forcing_fn exact_fn'
  
  [./forcing_fn]
    type = ParsedFunction
    value = (x*x*x)-6.0*x
  [../]
  
  [./exact_fn]
    type = ParsedGradFunction

    value = (x*x*x)
    grad_x = 3*x*x
    grad_y = 0
  [../]
[]

[Kernels]
  active = 'diff abs forcing'

  [./diff]
    type = MatDiffusion
    variable = u
    prop_name = matp
  [../]
  
  [./abs]
    type = Reaction
    variable = u
  [../]
  
  [./forcing]
    type = UserForcingFunction
    variable = u
    function = forcing_fn
  [../]
[]

[DGKernels]
  active = 'dgdiff'
  
  [./dgdiff]
    type = DGMatDiffusion
    variable = u
    sigma = 6
    epsilon = -1.0
    prop_name = matp
  [../]
[]

[BCs]
  active = 'all'

  [./all]
    type = DGMDDBC
    variable = u
    boundary = '1 2 3 4'
    function = exact_fn
    prop_name = matp
    sigma = 6
    epsilon = -1.0
  [../]
[]

[Materials]
  active = 'mat_1 mat_2'

  [./mat_1]
    type = MTMaterial
    diff = 1
    block = 1
    value = 1
  [../]

  [./mat_2]
    type = MTMaterial
    diff = 2
    block = 2
    value = 2
  [../]
[]

[Executioner]
  type = Steady
  petsc_options = '-snes_mf_operator'
[]

[Output]
  file_base = out_dg
  output_initial = true
  interval = 1
  exodus = true
  perf_log = true
[]
