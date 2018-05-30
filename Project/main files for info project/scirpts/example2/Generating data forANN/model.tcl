set Pi [expr 4*atan(1)]
set dt 0.001
set Endtime 32.
set NODES {3 4}
set MODENUMBER 3
set DOF {1 2 3}


set fp [open "data/factor.txt" r]
set a [read $fp]
close $fp
set factor $a

	wipe
	model basic -ndm 2 -ndf 3
	node 1 0. 0.
	node 2 3. 0.
	node 3 0. 3.
	node 4 3. 3.
	fix 1 1 1 1
	fix 2 1 1 1
      fix 3 0 0 1
      fix 4 0 0 1
	mass 3 20000. 0.1 0.1
	mass 4 20000. 0.1 0.1

	geomTransf Corotational 1

	uniaxialMaterial Steel01 1 2.4e8 2.e11 0.5

	section fiberSec 1 {patch quad 1 20 20  -0.1 -0.1 0.1 -0.1 0.1 0.1 -0.1 0.1}

	element nonlinearBeamColumn 1 1 3 10 1 1
	element nonlinearBeamColumn 2 2 4 10 1 1 
	element nonlinearBeamColumn 3 3 4 10 1 1


	recorder Node -file data/node1acce.out -time -node 1 -dof 1 2 3 accel
	recorder Node -file data/node3acce.out -time -node 3 -dof 1 2 3 accel
	recorder Node -file data/node3disp.out -time -node 3 -dof 1 2 3 disp
	recorder Node -file data/node1reac.out -time -node 1 -dof 1 2 3 reaction
      recorder Element -file data/stiffness11.out  -time -ele 1 section 1 stiffness
      recorder Element -file data/stiffness19.out  -time -ele 1 section 10 stiffness

source eigenvalue.tcl


	set accel "Series -dt $dt -filePath RSN143TABAS.AT2(dt=$dt).txt -factor [expr 9.81*$factor]"
	pattern UniformExcitation 3 1 -accel $accel
	rayleigh 1.1938628480692413 0.0 0.0 0.0020940428827675574;

	puts "Start Time: [getTime]"
	set T1 [clock microseconds];
	constraints Plain
	numberer Plain
	system BandGeneral
	test NormDispIncr 1.e-10 20
	algorithm ModifiedNewton
      integrator HHT 0.7
	analysis Transient
	analyze [expr int($Endtime/$dt)] $dt
	set currentTime [getTime]
	set T2 [clock microseconds]
	puts "Calculation Time (micro sec)=[expr $T2-$T1]"
puts ""
puts "Run completed"
