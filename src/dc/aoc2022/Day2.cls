Class dc.aoc2022.Day2 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day2.txt";

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

	kill scoreMap
	set scoreMap("A", "X") = 4
	set scoreMap("A", "Y") = 8
	set scoreMap("A", "Z") = 3
	set scoreMap("B", "X") = 1
	set scoreMap("B", "Y") = 5
	set scoreMap("B", "Z") = 9
	set scoreMap("C", "X") = 7
	set scoreMap("C", "Y") = 2
	set scoreMap("C", "Z") = 6

    set sum = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if line '= "" {
			set i = $PIECE(line," ",1)
			set j = $PIECE(line," ",2)
			set sum = sum + scoreMap(i, j)
		}
    }

	return sum
}

ClassMethod Part2() As %Integer
{
    set stream = ..GetInput(..#InputFile)

	kill scoreMap
	set scoreMap("A", "X") = 3
	set scoreMap("A", "Y") = 4
	set scoreMap("A", "Z") = 8
	set scoreMap("B", "X") = 1
	set scoreMap("B", "Y") = 5
	set scoreMap("B", "Z") = 9
	set scoreMap("C", "X") = 2
	set scoreMap("C", "Y") = 6
	set scoreMap("C", "Z") = 7

    set sum = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if line '= "" {
			set i = $PIECE(line," ",1)
			set j = $PIECE(line," ",2)
			set sum = sum + scoreMap(i, j)
		}
    }

	return sum
}

}
