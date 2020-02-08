[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 240
  ny = 240
  nz = 240
  xmin = 0
  xmax = 2400
  ymin = 0
  ymax = 2400
  zmin = 0
  zmax = 2400
  # uniform_refine = 2
[]

[GlobalParams]
  op_num = 4
  grain_num = 4
  var_name_base = etam
  numbub = 222
  bubspac = 110
  radius = 44
  int_width = 30
  numtries = 1000000
[]

[Variables]
  [./wv]
  [../]
  [./wg]
  [../]
  [./etab0]
  [../]
  [./PolycrystalVariables]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalVoronoiVoidIC]
      invalue = 1.0
      outvalue = 0.0
      polycrystal_ic_uo = voronoi
    [../]
  [../]
  [./bubble_IC]
    variable = etab0
    type = PolycrystalVoronoiVoidIC
    structure_type = voids
    invalue = 1.0
    outvalue = 0.0
    polycrystal_ic_uo = voronoi
  [../]
[]

[UserObjects]
  [./voronoi]
    type = PolycrystalVoronoi
    int_width = 0
  [../]
[]

[BCs]
  [./Periodic]
    [./All]
      auto_direction = 'x y z'
    [../]
  [../]
[]

[Kernels]
# Order parameter eta_b0 for bubble phase
  [./ACb0_bulk]
    type = ACGrGrMulti
    variable = etab0
    v =           'etam0 etam1 etam2 etam3'
    gamma_names = 'gmb   gmb   gmb   gmb  '
  [../]
  [./ACb0_sw]
    type = ACSwitching
    variable = etab0
    Fj_names  = 'omegab   omegam'
    hj_names  = 'hb       hm'
    args = 'etam0 etam1 etam2 etam3 wv wg'
  [../]
  [./ACb0_int]
    type = ACInterface
    variable = etab0
    kappa_name = kappa
  [../]
  [./eb0_dot]
    type = TimeDerivative
    variable = etab0
  [../]
# Order parameter eta_m0 for matrix grain 0
  [./ACm0_bulk]
    type = ACGrGrMulti
    variable = etam0
    v =           'etab0 etam1 etam2 etam3'
    gamma_names = 'gmb   gmm   gmm   gmm  '
  [../]
  [./ACm0_sw]
    type = ACSwitching
    variable = etam0
    Fj_names  = 'omegab   omegam'
    hj_names  = 'hb       hm'
    args = 'etab0 etam1 etam2 etam3 wv wg'
  [../]
  [./ACm0_int]
    type = ACInterface
    variable = etam0
    kappa_name = kappa
  [../]
  [./em0_dot]
    type = TimeDerivative
    variable = etam0
  [../]
# Order parameter eta_m1 for matrix grain 1
  [./ACm1_bulk]
    type = ACGrGrMulti
    variable = etam1
    v =           'etab0 etam0 etam2 etam3'
    gamma_names = 'gmb   gmm   gmm   gmm  '
  [../]
  [./ACm1_sw]
    type = ACSwitching
    variable = etam1
    Fj_names  = 'omegab   omegam'
    hj_names  = 'hb       hm'
    args = 'etab0 etam0 etam2 etam3 wv wg'
  [../]
  [./ACm1_int]
    type = ACInterface
    variable = etam1
    kappa_name = kappa
  [../]
  [./em1_dot]
    type = TimeDerivative
    variable = etam1
  [../]
# Order parameter eta_m2 for matrix grain 2
  [./ACm2_bulk]
    type = ACGrGrMulti
    variable = etam2
    v =           'etab0 etam0 etam1 etam3'
    gamma_names = 'gmb   gmm   gmm   gmm  '
  [../]
  [./ACm2_sw]
    type = ACSwitching
    variable = etam2
    Fj_names  = 'omegab   omegam'
    hj_names  = 'hb       hm'
    args = 'etab0 etam0 etam1 etam3 wv wg'
  [../]
  [./ACm2_int]
    type = ACInterface
    variable = etam2
    kappa_name = kappa
  [../]
  [./em2_dot]
    type = TimeDerivative
    variable = etam2
  [../]
# Order parameter eta_m3 for matrix grain 3
  [./ACm3_bulk]
    type = ACGrGrMulti
    variable = etam3
    v =           'etab0 etam0 etam1 etam2'
    gamma_names = 'gmb   gmm   gmm   gmm  '
  [../]
  [./ACm3_sw]
    type = ACSwitching
    variable = etam3
    Fj_names  = 'omegab   omegam'
    hj_names  = 'hb       hm'
    args = 'etab0 etam0 etam1 etam2 wv wg'
  [../]
  [./ACm3_int]
    type = ACInterface
    variable = etam3
    kappa_name = kappa
  [../]
  [./em3_dot]
    type = TimeDerivative
    variable = etam3
  [../]

#Chemical potential for vacancies
  [./wv_dot]
    type = SusceptibilityTimeDerivative
    variable = wv
    f_name = chiv
    args = '' # in this case chi (the susceptibility) is simply a constant
  [../]
  [./Diffusion_v]
    type = MatDiffusion
    variable = wv
    diffusivity = Dchiv
    args = ''
  [../]
  [./Source_v]
    type = MaskedBodyForce
    variable = wv
    value = 2.35e-9
    mask = hm
    args = 'etab0 etam0 etam1 etam2 etam3'
  [../]
  [./coupled_v_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = etab0
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1 etam2 etam3'
  [../]
  [./coupled_v_etam0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = etam0
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1 etam2 etam3'
  [../]
  [./coupled_v_etam1dot]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = etam1
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1 etam2 etam3'
  [../]
  [./coupled_v_etam2dot]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = etam2
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1 etam2 etam3'
  [../]
  [./coupled_v_etam3dot]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = etam3
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1 etam2 etam3'
  [../]

#Chemical potential for gas atoms
  [./wg_dot]
    type = SusceptibilityTimeDerivative
    variable = wg
    f_name = chig
    args = '' # in this case chi (the susceptibility) is simply a constant
  [../]
  [./Diffusion_g]
    type = MatDiffusion
    variable = wg
    diffusivity = Dchig
    args = ''
  [../]
  [./Source_g]
    type = MaskedBodyForce
    variable = wg
    value = 2.35e-10
    mask = hm
    args = 'etab0 etam0 etam1 etam2 etam3'
  [../]
  [./coupled_g_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etab0
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1 etam2 etam3'
  [../]
  [./coupled_g_etam0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etam0
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1 etam2 etam3'
  [../]
  [./coupled_g_etam1dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etam1
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1 etam2 etam3'
  [../]
  [./coupled_g_etam2dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etam2
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1 etam2 etam3'
  [../]
  [./coupled_g_etam3dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etam3
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1 etam2 etam3'
  [../]
[]

[AuxKernels]
  [./BndsCalc]
    type = BndsCalcAux
    variable = bnds
    execute_on = timestep_end
  [../]
[]

[Materials]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etab0 etam0 etam1 etam2 etam3'
    phase_etas = 'etab0'
    #outputs = exodus
  [../]
  [./hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'etab0 etam0 etam1 etam2 etam3'
    phase_etas = 'etam0 etam1 etam2 etam3'
    #outputs = exodus
  [../]
# Chemical contribution to grand potential of bubble
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'wv wg'
    f_name = omegab
    material_property_names = 'Va kvbub cvbubeq kgbub cgbubeq f0'
    function = '-0.5*wv^2/Va^2/kvbub-wv/Va*cvbubeq-0.5*wg^2/Va^2/kgbub-wg/Va*cgbubeq+f0'
    derivative_order = 2
    #outputs = exodus
  [../]

# Chemical contribution to grand potential of matrix
  [./omegam]
    type = DerivativeParsedMaterial
    args = 'wv wg'
    f_name = omegam
    material_property_names = 'Va kvmatrix cvmatrixeq kgmatrix cgmatrixeq'
    function = '-0.5*wv^2/Va^2/kvmatrix-wv/Va*cvmatrixeq-0.5*wg^2/Va^2/kgmatrix-wg/Va*cgmatrixeq'
    derivative_order = 2
    #outputs = exodus
  [../]

# Densities
  [./rhovbub]
    type = DerivativeParsedMaterial
    args = 'wv'
    f_name = rhovbub
    material_property_names = 'Va kvbub cvbubeq'
    function = 'wv/Va^2/kvbub + cvbubeq/Va'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./rhovmatrix]
    type = DerivativeParsedMaterial
    args = 'wv'
    f_name = rhovmatrix
    material_property_names = 'Va kvmatrix cvmatrixeq'
    function = 'wv/Va^2/kvmatrix + cvmatrixeq/Va'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./rhogbub]
    type = DerivativeParsedMaterial
    args = 'wg'
    f_name = rhogbub
    material_property_names = 'Va kgbub cgbubeq'
    function = 'wg/Va^2/kgbub + cgbubeq/Va'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./rhogmatrix]
    type = DerivativeParsedMaterial
    args = 'wg'
    f_name = rhogmatrix
    material_property_names = 'Va kgmatrix cgmatrixeq'
    function = 'wg/Va^2/kgmatrix + cgmatrixeq/Va'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./const]
    type = GenericConstantMaterial
    prop_names =  'kappa   mu       L   D    Va      cvbubeq cgbubeq kgbub  kvbub gmb 	 gmm T    Efvbar    Efgbar    kTbar     f0     tgrad_corr_mult'
    prop_values = '0.5273  0.004688 0.1 0.01 0.04092 0.5459  0.4541  1.41   1.41  0.9218 1.5 1200 7.505e-3  7.505e-3  2.588e-4  0.0    0.0            '
  [../]

  [./cvmatrixeq]    #For values, see Li et al., Nuc. Inst. Methods in Phys. Res. B, 303, 62-27 (2013).
    type = ParsedMaterial
    f_name = cvmatrixeq
    material_property_names = 'T'
    constant_names        = 'kB           Efv'
    constant_expressions  = '8.6173324e-5 3.0'
    function = 'exp(-Efv/(kB*T))'
  [../]
  [./cgmatrixeq]
    type = ParsedMaterial
    f_name = cgmatrixeq
    material_property_names = 'T'
    constant_names        = 'kB           Efg'
    constant_expressions  = '8.6173324e-5 3.0'
    function = 'exp(-Efg/(kB*T))'
  [../]
  [./kvmatrix_parabola]
    type = ParsedMaterial
    f_name = kvmatrix
    material_property_names = 'T  cvmatrixeq'
    constant_names        = 'c0v  c0g  a1                                               a2'
    constant_expressions  = '0.01 0.01 0.178605-0.0030782*log(1-c0v)+0.0030782*log(c0v) 0.178605-0.00923461*log(1-c0v)+0.00923461*log(c0v)'
    function = '((-a2+3*a1)/(4*(c0v-cvmatrixeq))+(a2-a1)/(2400*(c0v-cvmatrixeq))*T)'
    #outputs = exodus
  [../]
  [./kgmatrix_parabola]
    type = ParsedMaterial
    f_name = kgmatrix
    material_property_names = 'kvmatrix'
    function = 'kvmatrix'
  [../]

  [./Mobility_v]
    type = DerivativeParsedMaterial
    f_name = Dchiv
    material_property_names = 'D chiv'
    function = 'D*chiv'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./Mobility_g]
    type = DerivativeParsedMaterial
    f_name = Dchig
    material_property_names = 'D chig'
    function = 'D*chig'
    derivative_order = 2
    #outputs = exodus
  [../]
  [./chiv]
    type = DerivativeParsedMaterial
    f_name = chiv
    args = 'wv'
    material_property_names = 'Va hb kvbub hm kvmatrix '
    function = '(hm/kvmatrix + hb/kvbub) / Va^2'
    derivative_order = 2
    outputs = exodus
  [../]
  [./chig]
    type = DerivativeParsedMaterial
    f_name = chig
    args = 'wg'
    material_property_names = 'Va hb kgbub hm kgmatrix '
    function = '(hm/kgmatrix + hb/kgbub) / Va^2'
    derivative_order = 2
    outputs = exodus
  [../]
[]

# [Adaptivity]
#   marker = errorfrac
#   max_h_level = 2
#   [./Indicators]
#     [./error]
#       type = GradientJumpIndicator
#       variable = bnds
#     [../]
#   [../]
#   [./Markers]
#     [./bound_adapt]
#       type = ValueThresholdMarker
#       third_state = DO_NOTHING
#       coarsen = 1.0
#       refine = 0.99
#       variable = bnds
#       invert = true
#     [../]
#     [./errorfrac]
#       type = ErrorFractionMarker
#       coarsen = 0.1
#       indicator = error
#       refine = 0.7
#     [../]
#   [../]
# []

[Postprocessors]
  [./number_DOFs]
    type = NumDOFs
  [../]
  [./dt]
    type = TimestepSize
  [../]
  [./area]
    type = GrainBoundaryArea
    grains_per_side = 2
  [../]
  [./area_bubble]
    type = GrainBoundaryArea
    grains_per_side = 1
    var_name_base = etab
    op_num = 1
  [../]
  [./feature_counter]
    type = FeatureFloodCount
    variable = etab0
    threshold = 0.5
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_end'
  [../]
  [./Volume]
    type = VolumePostprocessor
    execute_on = 'initial'
  [../]
  [./volume_fraction]
    type = FeatureVolumeFraction
    mesh_volume = Volume
    feature_volumes = feature_volumes
    execute_on = 'initial timestep_end'
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  nl_max_its = 15
  scheme = bdf2
  #solve_type = NEWTON
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type'
  petsc_options_value = 'asm      1               lu'
  l_max_its = 45
  l_tol = 1.0e-4
  nl_rel_tol = 1.0e-8
  start_time = 0.0
  num_steps = 100
  # end_time = 1.0e9
  nl_abs_tol = 1e-9
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.5
    optimal_iterations = 8
    iteration_window = 2
  [../]
[]

[Outputs]
  [./exodus]
    type = Exodus
    interval = 1
  [../]
  checkpoint = true
  csv = true
[]
