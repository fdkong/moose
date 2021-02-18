[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 160
    ymin = 0
    ymax = 160
    nx = 8
    ny = 8
  []
  uniform_refine = 0
[]

[Variables]
  [sflux_g0]
    family = L2_LAGRANGE
    order = FIRST
  []
[]

[Kernels]
  [diff]
    type = CoefDiffusion
    variable = sflux_g0
    coef = 0.333333333333333333
  []
  [rem]
    type = CoefReaction
    variable = sflux_g0
    coefficient = 0.01
  []
  [fiss]
    type = CoefReaction
    variable = sflux_g0
    extra_vector_tags = eigen
    coefficient = -0.01
  []
[]

[DGKernels]
  [dg]
    type = DGDiffusion
    diff = 0.333333333333333333
    sigma = 4
    epsilon = 1
    variable = sflux_g0
  []
[]

[BCs]
  [vacuum]
    type = VacuumBC
    variable = sflux_g0
    boundary = 'left bottom'
  []
[]

[Executioner]
  type = Eigenvalue
  free_power_iterations = 4
  nl_abs_tol = 1e-50
  nl_rel_tol = 1e-8
#  line_search = none
[]

[Outputs]
  exodus = true
[]
