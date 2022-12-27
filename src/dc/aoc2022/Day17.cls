Class dc.aoc2022.Day17 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day17.txt";

ClassMethod Signature(ByRef cave, highest As %Integer) As %String
{
	set width = 7
	set result = ""
	set lim = highest - 30
	set:(lim < 0) lim = 0
	for i = (highest-1):-1:lim {
		for j = 0:1:width-1 {
			set result = result _ cave(i, j)
		}
	}
	return result
}

ClassMethod PrintCave(ByRef cave, h As %Integer)
{
	set width = 7
	for i = h-1:-1:0 {
		write "|"
		for j = 0:1:width - 1{
			write cave(i, j)
		}
		write "|",!
	}
	write "|||||||||",!!
	return 0
}

ClassMethod Run()
{
    set stream = ..GetInput(..#InputFile)
    set data = $zstrip(stream.ReadLine(), "*C")

	set part1 = 0
	set part2 = 0
	
	set height = 20000
	set width = 7
	for i = 0:1:height-1 {
		for j = 0:1:width-1 {
			set cave(i, j) = "."
		}
	}
	
	set rocks(0, "length") = 1
	set rocks(0, "width") = 4
	set rocks(0, 0) = "####"
	
	set rocks(1, "length") = 3
	set rocks(1, "width") = 3
	set rocks(1, 0) = " # "
	set rocks(1, 1) = "###"
	set rocks(1, 2) = " # "

	set rocks(2, "length") = 3
	set rocks(2, "width") = 3
	set rocks(2, 0) = "  #"
	set rocks(2, 1) = "  #"
	set rocks(2, 2) = "###"

	set rocks(3, "length") = 4
	set rocks(3, "width") = 1
	set rocks(3, 0) = "#"
	set rocks(3, 1) = "#"
	set rocks(3, 2) = "#"
	set rocks(3, 3) = "#"

	set rocks(4, "length") = 2
	set rocks(4, "width") = 2
	set rocks(4, 0) = "##"
	set rocks(4, 1) = "##"

	kill seen
	set L = 1000000000000
	set wind = 0
	set highest = 0
	set added = 0
	set rock = 0

	while (rock < L){
		// set t = ..PrintCave(.cave, highest)
		set ri = rock # 5
		set bottomLine = highest + 3
		set rockOffset = 2

		set done = 0
		while (bottomLine >= 0) && ('done) {
			set wi = wind # $length(data)
			set wind = wind + 1
			if ($extract(data, wi + 1) = "<") && (rockOffset > 0) {
				set canMove = 1
				if (ri = 0) || (ri = 3) || (ri = 4) {
					for i = 0:1:rocks(ri, "length")-1 {
						if cave(bottomLine + i, rockOffset - 1) = "#" {
							set canMove = 0
						}
					}
				}
				if (ri = 1) {
					if (cave(bottomLine, rockOffset) = "#") || (cave(bottomLine+1,rockOffset-1) = "#") || (cave(bottomLine+2, rockOffset) = "#") {
						set canMove = 0
					}
				}
				if (ri = 2) {
					if (cave(bottomLine, rockOffset-1) = "#") {
						set canMove = 0
					}
				}
				
        		if (canMove) {
	        		set rockOffset = rockOffset - 1
        		}
			}

			if ($extract(data, wi + 1) = ">") && (rockOffset < (width - rocks(ri, "width"))) {
				set canMove = 1

				if (ri = 0) || (ri = 2) || (ri = 3) || (ri = 4) {
					for i = 0:1:rocks(ri, "length")-1 {
						if cave(bottomLine + i, rockOffset + rocks(ri, "width")) = "#" {
							set canMove = 0
						}
					}
				}
				if (ri = 1) {
					if (cave(bottomLine, rockOffset + 2) = "#") || (cave(bottomLine+1, rockOffset + 3) = "#") || (cave(bottomLine+2, rockOffset + 2) = "#") {
						set canMove = 0
					}

				}

        		if (canMove) {
	        		set rockOffset = rockOffset + 1
        		}
			}
			
			if bottomLine = 0 {
				set done = 1
			} else {
				set done = 0
				for i = 0:1:rocks(ri, "width")-1 {
					set c1 = $extract(rocks(ri, rocks(ri, "length") - 1), i + 1)
					set c2 = cave(bottomLine-1, i+rockOffset)
					if (c1 = "#") && (c2 = "#") {
						set done = 1
					}
				}
				if ri = 1 {
					if (cave(bottomLine, rockOffset) = "#") || (cave(bottomLine, rockOffset + 2) = "#") {
						set done = 1
					}
				}

				if 'done {
					set bottomLine = bottomLine - 1
				}
			}
		}

		set t = bottomLine + rocks(ri, "length")
		set:(t>highest) highest = t
		for i=0:1:(rocks(ri,"length")-1) {
			for j=0:1:(rocks(ri,"width")-1) {
				if ($extract(rocks(ri,i), j + 1) = "#") {
					set cave(bottomLine + rocks(ri, "length") - 1 - i, rockOffset + j) = "#"
				}
			}
		}

		set sig = ..Signature(.cave, highest)
		if (rock > 2022) && $data(seen(wind#$length(data), rock#5, sig, "present")) {
			set oldt = seen(wind#$length(data), rock#5, sig, "oldt")
			set oldy = seen(wind#$length(data), rock#5, sig, "oldy")
			set dy = highest - oldy
			set dt = rock - oldt
			set amt = (L - rock) \ dt
			set added = added + (amt * dy)
			set rock = rock + (amt * dt)
		}
		set seen(wind#$length(data), rock#5, sig, "present") = 1
		set seen(wind#$length(data), rock#5, sig, "oldt") = rock
		set seen(wind#$length(data), rock#5, sig, "oldy") = highest

		if rock=2021 {
			set part1 = highest
		}
		set rock = rock + 1
	}

	set part2 = highest + added

	write part1,!
	write part2,!
}

}
