Class dc.aoc2022.Day6 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day6.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Detect(ByRef line, n As %Integer) As %Integer
{
	set s = $length(line) - n + 1
	for i = 1:1:s {
		set isOk = 1
		for j = 1:1:n-1 {
			set c = $extract(line, i + j - 1)
			set slice = $extract(line, i + j, i + n - 1)
			if $find(slice, c) {
				set isOk = 0
			}
		}
		if isOk{
			return i + n - 1
		}
	}
}

ClassMethod Part1() As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set line = $zstrip(stream.ReadLine(), "*C")
    
    set result = ..Detect(.line, 4)

	return result
}

ClassMethod Part2() As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set line = $zstrip(stream.ReadLine(), "*C")

    set result = ..Detect(.line, 14)

	return result
}

}
