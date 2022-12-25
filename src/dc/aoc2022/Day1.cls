Class dc.aoc2022.Day1 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day1.txt";

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

    set sum = 0
    set max = -9999999
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set sum = sum + line
		set:(sum>max) max = sum
		set:(line="") sum = 0
    }
    return max
}

ClassMethod Part2() As %Integer
{
    set stream = ..GetInput(..#InputFile)

    set sum = 0
    set (a,b,c) = -9999999
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set sum = sum + line
		if line = "" || stream.AtEnd{
			if sum >= a {
				set c = b
				set b = a
				set a = sum
			} else {
				if sum >= b {
					set c = b
					set b = sum
				} else {
					set:(sum>=c) c = sum
				}
			}
			set sum = 0
		}
    }
    set result = a + b + c
    return result
}

}
