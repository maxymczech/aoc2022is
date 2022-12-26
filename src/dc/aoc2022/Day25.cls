Class dc.aoc2022.Day25 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day25.txt";

ClassMethod Run()
{
	set part1 = ..Part1()

    write part1,!
}

ClassMethod FromSnafu(n As %String) As %Integer
{
	set l = $length(n)
	set e = 1
	set result = 0
	for i = l:-1:1 {
		set d = $extract(n, i)
		set:(d="-") d = -1
		set:(d="=") d = -2
		
		set result = result + (e * d)
		set e = e * 5
	}
	return result
}

ClassMethod ToSnafu(n As %Integer) As %String
{
	if n = 0 {
		return ""
	}
	set m = n # 5
	if m < 3 {
		set str = ..ToSnafu(n \ 5)
		return str _ m
	}
	if m = 3 {
		set str = ..ToSnafu((n + 2) \ 5)
		return str _ "="
	}
	if m = 4 {
		set str = ..ToSnafu((n + 1) \ 5)
		return str _ "-"
	}
}

ClassMethod Part1() As %Integer
{
    set stream = ..GetInput(..#InputFile)

	set sum = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set d = ..FromSnafu(line)
		set sum = sum + d
	}
	
	set str = ..ToSnafu(sum)
	
	return str
}

}
