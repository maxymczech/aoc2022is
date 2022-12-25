Class dc.aoc2022.Day4 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day4.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Part1() As %Integer
{
    set stream = ..GetInput(..#InputFile)

	set count = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set intLeft = $piece(line, ",", 1)
		set a = $piece(intLeft, "-", 1)
		set b = $piece(intLeft, "-", 2)
		set intRight = $piece(line, ",", 2)
		set c = $piece(intRight, "-", 1)
		set d = $piece(intRight, "-", 2)
		
		if ((a <= c) && (b >= d)) || ((c <= a) && (d >= b)) {
			set count = count + 1
		}
	}

	return count
}

ClassMethod Part2() As %Integer
{
    set stream = ..GetInput(..#InputFile)

	set count = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set intLeft = $piece(line, ",", 1)
		set a = $piece(intLeft, "-", 1)
		set b = $piece(intLeft, "-", 2)
		set intRight = $piece(line, ",", 2)
		set c = $piece(intRight, "-", 1)
		set d = $piece(intRight, "-", 2)
		
		if ((a >= c) && (a <= d)) || ((c >= a) && (c <= b)) {
			set count = count + 1
		}
	}

	return count
}

}
