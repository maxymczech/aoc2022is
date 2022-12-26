Class dc.aoc2022.Day12 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day12.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Solve(allStarts As %Integer) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set li = 0
    
    kill elevation
    kill pathLength
    kill q
    kill queued
    set qCount = 0
    
    set di(1) = -1
    set di(2) = 1
    set di(3) = 0
    set di(4) = 0
    set dj(1) = 0
    set dj(2) = 0
    set dj(3) = -1
    set dj(4) = 1
    
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set width = $length(line)
		for j = 0:1:width - 1 {
			set c = $extract(line, j + 1)
			set elevation(li, j) = $ascii(c)
			set pathLength(li, j) = 99999999
			set queued(li, j) = 0
			
			if c = "E" {
				set elevation(li, j) = $ascii("z")
				set target(0) = li
				set target(1) = j
			}
			
			if (c = "S") || (allStarts && (c = "a")){
				set elevation(li, j) = $ascii("a")
				set pathLength(li, j) = 0
				set queued(li, j) = 1
				set qCount = qCount + 1
				set q(qCount, 0) = li
				set q(qCount, 1) = j
			}
		}
		set li = li + 1
	}
	set height = li
	
	set qi = 0
	while qi<qCount {
		set qi = qi + 1
		set ci = q(qi, 0)
		set cj = q(qi, 1)

		for j = 1:1:4 {
			set ni = ci + di(j)
			set nj = cj + dj(j)
			if (ni >= 0) && (nj >=0) && (ni < height) && (nj < width) {
				if (elevation(ni, nj) - 1) <= elevation(ci, cj) {
					if pathLength(ni, nj) >= (pathLength(ci, cj) + 1) {
						set pathLength(ni, nj) = pathLength(ci, cj) + 1
					}
					if 'queued(ni, nj) {
						set queued(ni, nj) = 1
						set qCount = qCount + 1
						set q(qCount, 0) = ni
						set q(qCount, 1) = nj
					}
				}
			}
		}
	}

	return pathLength(target(0), target(1))
}

ClassMethod Part1() As %Integer
{
	set result = ..Solve(0)
	return result
}

ClassMethod Part2() As %Integer
{
	set result = ..Solve(1)
	return result
}

}
