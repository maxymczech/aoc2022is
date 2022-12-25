Class dc.aoc2022.Day3 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day3.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Priority(c As %String) As %Integer
{
	set code = $ascii(c)
	if (code >= 97) && (code <= 122) {
		return code - 96
	} else {
		return code - 38
	}
}

ClassMethod Part1() As %Integer
{
    set stream = ..GetInput(..#InputFile)

	set total = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set hl = $length(line)/2
		set strLeft = $EXTRACT(line, 1, hl)
		set strRight = $EXTRACT(line, hl+1, $length(line))
		set br = 0
		for i = 1:1:hl {
			set c = $extract(strLeft,i)
			if $find(strRight, c) {
				set p = ..Priority(c)
				set:'br total = total + p
				set br = 1
			}
		}
	}

	return total
}

ClassMethod Part2() As %Integer
{
    set stream = ..GetInput(..#InputFile)

	set total = 0
	while 'stream.AtEnd {
		set line1 = $zstrip(stream.ReadLine(), "*C")
		set line2 = $zstrip(stream.ReadLine(), "*C")
		set line3 = $zstrip(stream.ReadLine(), "*C")
		set br = 0
		for i = 1:1:$length(line1) {
			set c = $extract(line1,i)
			if $find(line2, c) && $find(line3, c) {
				set p = ..Priority(c)
				set:'br total = total + p
				set br = 1
			}
		}
	}

	return total
}

}
