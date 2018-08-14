#!/usr/bin/env python2
#pylint: disable=missing-docstring
#* This file is part of the MOOSE framework
#* https://www.mooseframework.org
#*
#* All rights reserved, see COPYRIGHT for full restrictions
#* https://github.com/idaholab/moose/blob/master/COPYRIGHT
#*
#* Licensed under LGPL 2.1, please see LICENSE for details
#* https://www.gnu.org/licenses/lgpl-2.1.html

import vtk
import chigger

# Create a common camera
camera = vtk.vtkCamera()
camera.SetViewUp(-0.0007, 1.0000, 0.0000)
camera.SetPosition(-0.2275, -0.1154, 3.9949)
camera.SetFocalPoint(-0.2169, -0.1153, 0.0039)

reader = chigger.exodus.NemesisReader('petsc_partitioner_out.e.8.*')
# cmap='rainbow'
result = chigger.exodus.ExodusResult(reader, color=[0.5]*3, edges=True, edge_color=[0,0,0], variable='pid', explode=0.1, group=4, camera=camera)

window = chigger.RenderWindow(result, size=[1250,600], background=[1,1,1], smoothing=True, antialiasing=10)
window.write('explode.png')
window.start()
