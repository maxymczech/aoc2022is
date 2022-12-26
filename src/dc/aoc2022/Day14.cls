Class dc.aoc2022.Day14 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day14.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod BuildCave(ByRef cave, ByRef height)
{
    set stream = ..GetInput(..#InputFile)

	set height = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set n = $length(line, " -> ")
		set lineStart = $piece(line, " -> ", 1)
		for i = 2:1:n {
			set lineEnd = $piece(line, " -> ", i)
			set si = $piece(lineStart, ",", 1)
			set sj = $piece(lineStart, ",", 2)
			set ei = $piece(lineEnd, ",", 1)
			set ej = $piece(lineEnd, ",", 2)
			
			set:(sj>height) height = sj
			set:(ej>height) height = ej
			
			set cave(sj,si) = 1
			
			while (si'=ei) || (sj'=ej) {
				if (si'=ei) {
					set si = si + ((ei - si) / $zabs(ei - si))
				}
				if (sj'=ej) {
					set sj = sj + ((ej - sj) / $zabs(ej - sj))
				}
				set cave(sj,si) = 1
			}

			set lineStart = lineEnd
		}
	}
	set height = height + 1

	return 0
}

ClassMethod Part1() As %Integer
{
	set t = ..BuildCave(.cave, .height)

	set count = 0
	set hasSettled = 1
	while hasSettled {
		set si = 500
		set sj = 0
		set count = count + 1
		set hasSettled = 0
		
		while ('hasSettled) && (sj < height) {
			if '$data(cave(sj + 1, si)) {
				set sj = sj + 1
			} else {
				if '$data(cave(sj + 1, si - 1)) {
					set sj = sj + 1
					set si = si - 1
				} elseif '$data(cave(sj + 1, si + 1)) {
					set sj = sj + 1
					set si = si + 1
				} else {
					set cave(sj, si) = 1
					set hasSettled = 1
				}
			}
		}
	}

	return count - 1
}

ClassMethod Part2() As %Integer
{
	set t = ..BuildCave(.cave, .height)

	set height = height + 2
	for i = 1:1:1000 {
		set cave(height - 1, i) = 1
	}

	set count = 0
	set si = 0
	set sj = 0
	while (si '= 500)|| (sj '= 0) {
		set si = 500
		set sj = 0
		set count = count + 1
		set hasSettled = 0
		
		while ('hasSettled) && (sj < height) {
			if '$data(cave(sj + 1, si)) {
				set sj = sj + 1
			} else {
				if '$data(cave(sj + 1, si - 1)) {
					set sj = sj + 1
					set si = si - 1
				} elseif '$data(cave(sj + 1, si + 1)) {
					set sj = sj + 1
					set si = si + 1
				} else {
					set cave(sj, si) = 1
					set hasSettled = 1
				}
			}
		}
	}

	return count
}

}
