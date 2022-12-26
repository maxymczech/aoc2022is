Class dc.aoc2022.Day20 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day20.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Solve(repeat As %Integer, k As %Integer) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    
    kill xs
    kill indices
    
    set count = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set xs(count) = line * k
		set indices(count) = count
		set count = count + 1
	}
	
	for i = 1:1:repeat {
		for xi = 0:1:count-1 {
			set x = xs(xi)
			for tj = 0:1:count-1 {
				if indices(tj) = xi {
					set j = tj
				}
			}
			set insert = (j + x) # (count - 1)
			for tj = j+1:1:count-1 {
				set indices(tj-1) = indices(tj)
			}
			if insert = 0 {
				set indices(count - 1) = xi
			} else {
				for tj = count-1:-1:insert+1 {
					set indices(tj) = indices(tj-1)
				}
				set indices(insert) = xi
			}
		}
	}
	
	for i = 0:1:count - 1 {
		if xs(i) = 0 {
			set xi = i
		}
	}
	for i = 0:1:count - 1 {
		if indices(i) = xi {
			set zero = i
		}
	}
	set a = xs(indices((zero + 1000) # count))
	set b = xs(indices((zero + 2000) # count))
	set c = xs(indices((zero + 3000) # count))
	
	return a+b+c
}

ClassMethod Part1() As %Integer
{
	return ..Solve(1, 1)
}

ClassMethod Part2() As %Integer
{
    return ..Solve(10, 811589153)
    return 0
}

}
