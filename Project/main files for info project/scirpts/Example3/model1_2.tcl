# PP, one story, hystersis, hinge faghat dar sotunha
wipe

model basic -ndm 2 -ndf 3



file mkdir mohsen
#C:/Users/smvaz/Deskto/INFO Project/Opensees+ANN/

set fp [open "C:/Users/smvaz/Desktop/main files for info project/scirpts/Example4/data1/n.txt" r]
set a [read $fp]
close $fp
set nnn [expr $a]

set fp [open "data/damagec.txt" r]
set a [read $fp]
close $fp
set damageparamc [expr 1.*$a]

set fp [open "data/damageb.txt" r]
set a [read $fp]
close $fp
set damageparamb [expr 1.*$a]


set fp [open "data/mass.txt" r]
set a [read $fp]
close $fp
set mass $a

set fp [open "data/E.txt" r]
set a [read $fp] 
close $fp
set E $a

set Pi [expr 4*atan(1)]
#set E 2.0000000000001e11
#set fy 2.4e8

#set E2 .02
set poisson .2
set G [expr $E/2./(1.+$poisson)]


set L 4.
set B 3.


set fp [open "data/factor.txt" r]
set a [read $fp]
close $fp
set factor $a

set fp [open "data/lasttry.txt" r]
set a [read $fp]
close $fp
set Tend $a

set fp [open "data/step.txt" r]
set a [read $fp]
close $fp
set step $a


for {set n 1} {$n<=$nnn} {incr n 1} { 



set fp [open "data/fyc$n.txt" r]
set a [read $fp]
close $fp
set fyc$n $a
set epyc$n [expr $a/$E]

set fp [open "data/fyb$n.txt" r]
set a [read $fp]
close $fp
set epyb$n [expr $a/$E]


set fp [open "data/coldim$n.txt" r]
set a [read $fp]
close $fp
set c$n [expr .5*$a]

set fp [open "data/beamdim$n.txt" r]
set a [read $fp]
close $fp
set b$n [expr .5*$a]


set a c$n
set Ac$n [expr 4.*$$a *$$a ]
set Ic$n [expr 16.*$$a*$$a*$$a*$$a/12.]

set a b$n
set Ab$n [expr 4.*$$a *$$a ]
set Ib$n [expr 16.*$$a*$$a*$$a*$$a/12.]


node [expr $n+1] 0. [expr $B*$n.]
node [expr $n+1+$nnn+1] $L [expr $B*$n.]
#fix [expr $n+1] 0 0 1
#fix [expr $n+1+$nnn+1] 0 0 1
mass [expr $n+1] $mass 1.e-5 1.e-5
mass [expr $n+1+$nnn+1] $mass 1.e-5 1.e-5
}

node 1 0. 0.
node [expr $nnn+1+1] $L 0.
fix 1 1 1 1
fix [expr $nnn+1+1] 1 1 1


geomTransf Corotational 1


for {set n 1} {$n<=$nnn} {incr n 1} { 
#uniaxialMaterial Steel01 1 $fyc1 $E $E2
set a epyc$n
set b epyb$n
uniaxialMaterial ElasticPP $n $E [expr $$a*1.]
uniaxialMaterial ElasticPP [expr $n+100] $E [expr $$b*1.]

#uniaxialMaterial Fatigue 1 10 -E0 0.005 -m -0.5
#defining section
set a c$n
section Fiber $n {patch quad $n 20 20 -[expr 1.*$$a] -[expr 1.*$$a] [expr 1.*$$a] -[expr 1.*$$a] [expr 1.*$$a] [expr 1.*$$a] -[expr 1.*$$a] [expr 1.*$$a]}
set a b$n
section Fiber [expr $n+100] {patch quad [expr $n+100] 20 20 -[expr 1.*$$a] -[expr 1.*$$a] [expr 1.*$$a] -[expr 1.*$$a] [expr 1.*$$a] [expr 1.*$$a] -[expr 1.*$$a] [expr 1.*$$a]}
#defining column
set a Ac$n                      
set b Ic$n 
element beamWithHinges $n $n [expr $n+1] $n 1.45 $n 1.45 $E [expr 1.*$$a] [expr 1.*$$b] 1
element beamWithHinges [expr $n+$nnn] [expr $n+$nnn+1] [expr $n+1+$nnn+1] $n 1.45 $n 1.45 $E [expr 1.*$$a] [expr 1.*$$b] 1
#defining beam
set a Ab$n                      
set b Ib$n 
element beamWithHinges [expr $n+100] [expr $n+1] [expr $n+1+$nnn+1] [expr $n+100] 1.45 [expr $n+100] 1.45 $E [expr 1.*$$a] [expr 1.*$$b] 1
##element elasticBeamColumn [expr $n+100] [expr $n+1] [expr $n+1+$nnn+1] [expr 1.*$$a] $E [expr 1.*$$b] 1
}




for {set n 1} {$n<=$nnn} {incr n 1} { 
recorder Node -file data/node[expr $n+1]disp.out -time -node [expr $n+1] -dof 1 disp
recorder Node -file data/node[expr $n+1]acc.out -time -node [expr $n+1] -dof 1 accel
}

recorder Node -file data/node1disp.out -time -node 1 -dof 1 disp
recorder Node -file data/node1acc.out -time -node 1 -dof 1 accel
recorder Node -file data/node1reac.out -time -node 1 -dof 1 2 3 reaction
#recorder Element -file "Data/Damage1.out" -time -ele 1 section 1 fiber $c1 $c1 damage



#recorder Element -file strain/StressStrain11.out  -time -ele 1 section 1 fiber $c1 0. stressStrain
#recorder Element -file strain/StressStrain16.out  -time -ele 1 section 6 fiber -$c1 0. stressStrain
#recorder Element -file strain/StressStrain21.out  -time -ele 2 section 1 fiber $c1 0. stressStrain
#recorder Element -file strain/StressStrain26.out  -time -ele 2 section 6 fiber -$c1 0. stressStrain
#recorder Element -file strain/StressStrain31.out  -time -ele 3 section 1 fiber $c1 0. stressStrain
#recorder Element -file strain/StressStrain36.out  -time -ele 3 section 6 fiber -$c1 0. stressStrain
#recorder Element -file strain/stiffness11.out  -time -ele 1 section 1 stiffness
#recorder Element -file strain/stiffness16.out  -time -ele 1 section 6 stiffness
#recorder Element -file strain/stiffness21.out  -time -ele 2 section 1 stiffness
#recorder Element -file strain/stiffness26.out  -time -ele 2 section 6 stiffness
#recorder Element -file strain/stiffness31.out  -time -ele 3 section 1 stiffness
#recorder Element -file strain/stiffness36.out  -time -ele 3 section 6 stiffness

print information.out







set eig [eigen $nnn]
set filename "data/modeTIMEelementry.txt"
set fileId [open $filename "w+"]
for {set n 1} {$n<=$nnn} {incr n 1} { 
set T$n [expr 2.*$Pi/pow([lindex $eig [expr $n-1]],0.5)]
set a T$n
set data [expr 1.*$$a]
puts $fileId $data
}
close $fileId


#recorder Node -file eigen/eeigenvector.out -node 3 -dof 1 eigen 0

for {set number2 1} {$number2<=$nnn} {incr number2 1} { 
set filename "eigen/eigenvector2-$number2.txt"
set fileId [open $filename "w+"]
for {set number 1} {$number<=$nnn} {incr number 1} { 
set eigenValue$number [nodeEigenvector [expr $number+1] $number2 1] 
set "eigenValue1"
set a eigenValue$number
set data [expr 1.*$$a]
puts $fileId $data
}
close $fileId
}






set accel "Series -dt $step -filePath record/recacc.txt -factor [expr 9.81*$factor]"
puts "$accel"
pattern UniformExcitation 3 1 -accel $accel



 constraints Transformation
 numberer Plain
 system BandGeneral
 test NormDispIncr 1.0e-8 10
 algorithm Newton
# integrator Newmark 0.5 0.25
 integrator HHT 0.7
 analysis Transient
#analyze [expr int($Tend)] $step 


for {set n 1} {$n<=$nnn} {incr n 1} { 
puts "[sectionStiffness $n 1]"
puts "[sectionStiffness [expr $n+100] 1]"
}
puts ""


for {set n 1} {$n<=$nnn} {incr n 1} {
 set EprimeC$n [expr 1.*$E]
 set EprimeB$n [expr 1.*$E]
}
 

for {set n 1} {$n<=$nnn} {incr n 1} { 
set ssd$n [sectionStiffness $n 1]
set ssu$n [sectionStiffness $n 6]
set ssb$n [sectionStiffness [expr $n+100] 1]
set ssp$n [sectionStiffness [expr $n+100] 6]
}

set j 1000


for {set i 1} {$i<$Tend+1} {incr i 1} {


for {set n 1} {$n<=$nnn} {incr n 1} { 
set sssd$n [sectionStiffness $n 1]
set sssu$n [sectionStiffness $n 6]
set sssb$n [sectionStiffness [expr $n+100] 1]
set sssp$n [sectionStiffness [expr $n+100] 6]
}


analyze 1 $step

for {set n 1} {$n<=$nnn} {incr n 1} { 
set ssssd$n [sectionStiffness $n 1]
set ssssu$n [sectionStiffness $n 6]
set ssssb$n [sectionStiffness [expr $n+100] 1]
set ssssp$n [sectionStiffness [expr $n+100] 6]
}


foreach n {1} {
set ad0 ssd$n
set au0 ssu$n
set au1 sssu$n
set au2 ssssu$n
set EEE EprimeC$n
set epy epyc$n
#puts [expr $$a]
		if {[lindex [expr $$au1] 3] <[lindex [expr $$au2] 3]  } {
             puts "Column$n $i [getTime] [lindex [expr $$au2] 3] [expr $$EEE]"
		 if {[lindex [expr $$au2] 3]>[expr $damageparamc*[lindex [expr $$au0] 3] ]} {
		     set j [expr $j+1]
		     set $EEE [expr $damageparamc*[expr $$EEE]]
	         remove element $n
             remove element [expr $nnn+$n]
		     uniaxialMaterial ElasticPP $j [expr $$EEE] [expr $$epy]
             set ac c$n
		     section Fiber $j {patch quad $j 20 20 -[expr $$ac] -[expr $$ac] [expr $$ac] -[expr $$ac] [expr $$ac] [expr $$ac] -[expr $$ac] [expr $$ac]}
             set ac Ac$n
             set bc Ic$n
             element beamWithHinges $n $n [expr 1+$n] $j 1.45 $j 1.45 [expr $$EEE] [expr $$ac] [expr $$bc] 1
             element beamWithHinges [expr $nnn+$n] [expr $n+$nnn+1] [expr $n+1+$nnn+1] $j 1.45 $j 1.45 [expr $$EEE] [expr $$ac] [expr $$bc] 1
		     set moh0 [expr $damageparamc*[lindex [expr $$au0] 0]]
		     set moh1 [expr $damageparamc*[lindex [expr $$au0] 1]]
		     set moh2 [expr $damageparamc*[lindex [expr $$au0] 2]]
		     set moh3 [expr $damageparamc*[lindex [expr $$au0] 3]]
		     set $ad0 [list $moh0 $moh1 $moh2 $moh3]
		     set $au0 [list $moh0 $moh1 $moh2 $moh3]
		 }
        }

}

foreach n {1} {
set ad0 ssp$n
set au0 ssb$n
set au1 sssb$n
set au2 ssssb$n
set EEE EprimeB$n
set epy epyb$n
#puts [expr $$a]
		if {[lindex [expr $$au1] 3] <[lindex [expr $$au2] 3]  } {
             puts "Beam$n $i [getTime] [lindex [expr $$au2] 3] [expr $$EEE]"
		 if {[lindex [expr $$au2] 3]>[expr $damageparamb*[lindex [expr $$au0] 3] ]} {
		     set j [expr $j+1]
		     set $EEE [expr $damageparamb*[expr $$EEE]]
	         remove element [expr 100+$n]
		     uniaxialMaterial ElasticPP $j [expr $$EEE] [expr $$epy]
             set ac b$n
		     section Fiber $j {patch quad $j 20 20 -[expr $$ac] -[expr $$ac] [expr $$ac] -[expr $$ac] [expr $$ac] [expr $$ac] -[expr $$ac] [expr $$ac]}
             set ac Ab$n
             set bc Ib$n
             element beamWithHinges [expr 100+$n] [expr $n+1] [expr $n+1+$nnn+1] $j 1.45 $j 1.45 [expr $$EEE] [expr $$ac] [expr $$bc] 1
		     set moh0 [expr $damageparamc*[lindex [expr $$au0] 0]]
		     set moh1 [expr $damageparamc*[lindex [expr $$au0] 1]]
		     set moh2 [expr $damageparamc*[lindex [expr $$au0] 2]]
		     set moh3 [expr $damageparamc*[lindex [expr $$au0] 3]]
		     set $ad0 [list $moh0 $moh1 $moh2 $moh3]
		     set $au0 [list $moh0 $moh1 $moh2 $moh3]
		 }
        }
}










for {set n 1} {$n<=$nnn} {incr n 1} { 
set filename "strain/stiffnessd$n.txt"
set fileId [open $filename "a"]
set a ssssd$n
puts $fileId "[getTime] [expr $$a]"
close $fileId
set filename "strain/stiffnessu$n.txt"
set fileId [open $filename "a"]
set a ssssu$n
puts $fileId "[getTime] [expr $$a]"
close $fileId

set filename "strain/stiffnessb$n.txt"
set fileId [open $filename "a"]
set a ssssb$n
puts $fileId "[getTime] [expr $$a]"
close $fileId
set filename "strain/stiffnessp$n.txt"
set fileId [open $filename "a"]
set a ssssp$n
puts $fileId "[getTime] [expr $$a]"
close $fileId
}





 set xDamp 0.05;					# damping ratio
 set MpropSwitch 1.0;
 set KcurrSwitch 0.0;
 set KcommSwitch 1.0;
 set KinitSwitch 0.0;
 set nEigenI 1;		# mode 1
 set nEigenJ 3;		# mode 3
 set lambdaN [eigen [expr $nEigenJ]];			# eigenvalue analysis for nEigenJ modes
 set lambdaI [lindex $lambdaN [expr $nEigenI-1]]; 		# eigenvalue mode i
 set lambdaJ [lindex $lambdaN [expr $nEigenJ-1]]; 	# eigenvalue mode j
 set omegaI [expr pow($lambdaI,0.5)];
 set omegaJ [expr pow($lambdaJ,0.5)];
 set alphaM [expr $MpropSwitch*$xDamp*(2*$omegaI*$omegaJ)/($omegaI+$omegaJ)];	# M-prop. damping; D = alphaM*M
 set betaKcurr [expr $KcurrSwitch*2.*$xDamp/($omegaI+$omegaJ)];         		# current-K;      +beatKcurr*KCurrent
 set betaKcomm [expr $KcommSwitch*2.*$xDamp/($omegaI+$omegaJ)];   		# last-committed K;   +betaKcomm*KlastCommitt
 set betaKinit [expr $KinitSwitch*2.*$xDamp/($omegaI+$omegaJ)];         			# initial-K;     +beatKinit*Kini
 

rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm; 				# RAYLEIGH damping




}
 
puts ""

set eig [eigen $nnn]
set filename "data/modeTIME.txt"
set fileId [open $filename "w+"]
for {set n 1} {$n<=$nnn} {incr n 1} { 
set T$n [expr 2.*$Pi/pow([lindex $eig [expr $n-1]],0.5)]
set a T$n
set data [expr 1.*$$a]
puts $fileId $data
}
close $fileId



for {set number2 1} {$number2<=$nnn} {incr number2 1} { 
set filename "eigen/eigenvector1-$number2.txt"
set fileId [open $filename "w+"]
for {set number 1} {$number<=$nnn} {incr number 1} { 
set eigenValue$number [nodeEigenvector [expr $number+1] $number2 1] 
set "eigenValue1"
set a eigenValue$number
set data [expr 1.*$$a]
puts $fileId $data
}
close $fileId
}


for {set n 1} {$n<=$nnn} {incr n 1} { 
set ssd$n [sectionStiffness $n 1]
set ssu$n [sectionStiffness $n 6]
set ssb$n [sectionStiffness [expr $n+100] 1]
set ssp$n [sectionStiffness [expr $n+100] 6]
}


