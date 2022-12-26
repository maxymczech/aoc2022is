Class dc.aoc2022.Day18 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day18.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod ReadCubes(ByRef cubes, ByRef cubeCount, ByRef d, ByRef map)
{
    set stream = ..GetInput(..#InputFile)

	set d = 0
	set cubeCount = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set x = $piece(line, ",", 1) + 1
		set y = $piece(line, ",", 2) + 1
		set z = $piece(line, ",", 3) + 1
		
		set cubes(x, y, z) = 1
		set cubeCount = cubeCount + 1
		
		set:(x>d) d = x
		set:(y>d) d = y
		set:(z>d) d = z
	}
	set d = d + 2
	
	set map(1, "x") = 0
	set map(1, "y") = 0
	set map(1, "z") = -1
	set map(2, "x") = 0
	set map(2, "y") = 0
	set map(2, "z") = 1
	set map(3, "x") = 0
	set map(3, "y") = -1
	set map(3, "z") = 0
	set map(4, "x") = 0
	set map(4, "y") = 1
	set map(4, "z") = 0
	set map(5, "x") = -1
	set map(5, "y") = 0
	set map(5, "z") = 0
	set map(6, "x") = 1
	set map(6, "y") = 0
	set map(6, "z") = 0
	
	return 0
}

ClassMethod Part1() As %Integer
{
	set t = ..ReadCubes(.cubes, .cubeCount, .d, .map)
	
	set neighbors = 0
	for i = 0:1:d {
		for j = 0:1:d {
			for k = 0:1:d {
				if $data(cubes(i, j, k)) {
					set n = 0
					for l = 1:1:6 {
						set ni = map(l, "x")
						set nj = map(l, "y")
						set nk = map(l, "z")
						if $data(cubes(i + ni, j + nj, k + nk)) {
							set n = n + 1
						}
					}
					set neighbors = neighbors + n
				}
			}
		}
	}

	return (cubeCount * 6) - neighbors
}

ClassMethod Part2() As %Integer
{
    set t = ..ReadCubes(.cubes, .cubeCount, .d, .map)
	
	set visited(0, 0, 0) = 1
	
	set qLength = 1
	set q(1, "x") = 0
	set q(1, "y") = 0
	set q(1, "z") = 0
	set outsideArea = 0
	set qi = 0
	
	while qi < qLength {
		set qi = qi + 1
		set i = q(qi, "x")
		set j = q(qi, "y")
		set k = q(qi, "z")
		
		
		for l = 1:1:6 {
			set ni = map(l, "x")
			set nj = map(l, "y")
			set nk = map(l, "z")
			if '$data(visited(i + ni, j + nj, k + nk)) {
				if (i + ni >= 0) && (j + nj >= 0) && (k + nk >= 0) && (i + ni < d) && (j + nj < d) && (k + nk < d) {
					if $data(cubes(i + ni, j + nj, k + nk)) {
						set outsideArea = outsideArea + 1
					} else {
						set visited(i + ni, j + nj, k + nk) = 1
						set qLength = qLength + 1
						set q(qLength, "x") = i + ni
						set q(qLength, "y") = j + nj
						set q(qLength, "z") = k + nk
					}
				}
			}
		}

	}

	return outsideArea
}

}
