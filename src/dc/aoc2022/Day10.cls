Class dc.aoc2022.Day10 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day10.txt";

ClassMethod Run()
{
	set part1 = ..Part1()

    write part1,!
}

ClassMethod Check(ByRef accumulator, x As %Integer, cycle As %Integer) As %Integer
{
	if (cycle=20) || (cycle=60) || (cycle=100) || (cycle=140) || (cycle=180) || (cycle=220) {
		set accumulator = accumulator + (x * cycle)
	}
	return 1
}

ClassMethod Print(ByRef buffer, cycle As %Integer, x As %Integer, width As %Integer, height As %Integer) As %Integer
{
	set col = (cycle - 1) # width
	set row = (cycle - 1) \ width
	if row < height {
		if $zabs(col - x) <= 1 {
			set buffer(row,col) = "#"
		}
	}
	return 1
}

ClassMethod Part1() As %Integer
{
    set stream = ..GetInput(..#InputFile)

	set x = 1
	set cycle = 1
	set result = 0
	
	kill buffer
	set width = 40
	set height = 6
	for i=0:1:height-1 {
		for j=0:1:width-1 {
			set buffer(i,j) = " "
		}
	}

	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		
		set op = $piece(line, " ", 1)
		
		if op = "noop" {
			set cycle = cycle + 1
			set t = ..Check(.result, x, cycle)
			set t = ..Print(.buffer, cycle, x, width, height)
		} else {
			set arg = $piece(line, " ", 2)
			
			set cycle = cycle + 1
			set t = ..Check(.result, x, cycle)
			set t = ..Print(.buffer, cycle, x, width, height)

			set x = x + arg
			set cycle = cycle + 1
			set t = ..Check(.result, x, cycle)
			set t = ..Print(.buffer, cycle, x, width, height)
		}
	}
	
	for i=0:1:height-1 {
		for j=0:1:width-1 {
			write buffer(i,j)
		}
		write !
	}
	
	return result
}

}
