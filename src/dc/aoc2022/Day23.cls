Class dc.aoc2022.Day23 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day23.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod ReadElves(ByRef elves, ByRef elvesCount) As %Integer
{
    set stream = ..GetInput(..#InputFile)

	set elvesCount = 0
	set li = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set l = $length(line)
		for i=1:1:l {
			set c = $extract(line, i)
			if c = "#" {
				set elvesCount = elvesCount + 1
				set elves(elvesCount, "x") = i - 1
				set elves(elvesCount, "y") = li
			}
		}
		set li = li + 1
	}
	return 0
}

ClassMethod Step(ByRef elves, elvesCount As %Integer, step As %Integer) As %Integer
{
	kill occupied
	for i = 1:1:elvesCount {
		set x = elves(i, "x")
		set y = elves(i, "y")
		set occupied(x, y) = 1
		set elves(i, "targetX") = x
		set elves(i, "targetY") = y
	}

	for i = 1:1:elvesCount {
		set x = elves(i, "x")
		set y = elves(i, "y")
		set hasNeighbor = 0
		
		for dx = -1:1:1 {
			for dy = -1:1:1 {
				if (dx'=0) || (dy'=0) {
					if $data(occupied(x+dx, y+dy)) {
						set hasNeighbor = 1
					}
				}
			}
		}
		if hasNeighbor {
			set hasTarget = 0
			for j = 0:1:3 {
				set d = (j + step) # 4
				if ('hasTarget) && (d=0) && ('$data(occupied(x-1, y-1))) && ('$data(occupied(x, y-1))) && ('$data(occupied(x+1, y-1))) {
					set elves(i, "targetX") = x
					set elves(i, "targetY") = y - 1
					set hasTarget = 1
				}
				if ('hasTarget) && (d=1) && ('$data(occupied(x-1, y+1))) && ('$data(occupied(x, y+1))) && ('$data(occupied(x+1, y+1))) {
					set elves(i, "targetX") = x
					set elves(i, "targetY") = y + 1
					set hasTarget = 1
				}
				if ('hasTarget) && (d=2) && ('$data(occupied(x-1, y-1))) && ('$data(occupied(x-1, y))) && ('$data(occupied(x-1, y+1))) {
					set elves(i, "targetX") = x - 1
					set elves(i, "targetY") = y
					set hasTarget = 1
				}
				if ('hasTarget) && (d=3) && ('$data(occupied(x+1, y-1))) && ('$data(occupied(x+1, y))) && ('$data(occupied(x+1, y+1))) {
					set elves(i, "targetX") = x + 1
					set elves(i, "targetY") = y
					set hasTarget = 1
				}
			}
		}
	}
	
	kill targets
	for i = 1:1:elvesCount {
		set tx = elves(i, "targetX")
		set ty = elves(i, "targetY")
		if $data(targets(tx, ty)) {
			set targets(tx, ty) = targets(tx, ty) + 1
		} else {
			set targets(tx, ty) = 1
		}
	}

	set changed = 0
	for i = 1:1:elvesCount {
		set tx = elves(i, "targetX")
		set ty = elves(i, "targetY")
		if targets(tx, ty) = 1 {
			if (tx '= elves(i, "x")) || (ty '= elves(i, "y")) {
				set changed = 1
			}
			set elves(i, "x") = tx
			set elves(i, "y") = ty
		}
	}
	return changed
}

ClassMethod Part1() As %Integer
{
	do ..ReadElves(.elves, .elvesCount)

	for i = 0:1:10-1 {
		do ..Step(.elves, elvesCount, i)
	}
	
	set xMin = elves(1, "x")
	set xMax = elves(1, "x")
	set yMin = elves(1, "y")
	set yMax = elves(1, "y")
	for i=1:1:elvesCount {
		set x = elves(i, "x")
		set y = elves(i, "y")
		set:(x<xMin) xMin = x
		set:(x>xMax) xMax = x
		set:(y<yMin) yMin = y
		set:(y>yMax) yMax = y
	}
	set w = xMax - xMin + 1
	set h = yMax - yMin + 1
	set result = (w * h) - elvesCount

	return result
}

ClassMethod Part2() As %Integer
{
	do ..ReadElves(.elves, .elvesCount)

	set round = 0
	while 1 {
		set changed = ..Step(.elves, elvesCount, round)
		set round = round + 1
		if 'changed {
			return round
		}
	}
}

}
