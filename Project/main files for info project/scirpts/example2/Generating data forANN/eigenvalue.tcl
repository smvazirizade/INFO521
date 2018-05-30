#proc eigenvalue { {i 1} {nnn 3} } {
 	puts "Eigen Value"
 	set eig [eigen $MODENUMBER]
 	set filename "data/modeTIME.txt"
 	set fileId [open $filename "w+"]
 	for {set ModeNumber 1} {$ModeNumber<=$MODENUMBER } {incr ModeNumber 1} { 
 		set T$ModeNumber [expr 2.*$Pi/pow([lindex $eig [expr $ModeNumber-1]],0.5)]
 		set a T$ModeNumber
 		puts $fileId [expr $$a]
	}
 	close $fileId