Class dc.aoc2022.Day8 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day8.txt";

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
    
    kill data
    kill vis
    set li = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set w = $length(line)
		for j = 0:1:w-1 {
			set data(li,j) = $extract(line, j+1) + 0
			set vis(li,j) = 0
			set:(li=0) vis(li,j) = 1
			set:(j=0) vis(li,j) = 1
			set:(j=(w-1)) vis(li,j) = 1
		}
		set li = li + 1
	}
	set h = li
	for j = 0:1:w-1 {
		set vis(h-1, j) = 1
	}
	
	for i = 1:1:h-2 {
		set mh = data(i, 0)
		for j = 1:1:w-2 {
			if data(i,j) > mh {
				set vis(i,j) = 1
				set mh = data(i,j)
			}
		}
		
		set mh = data(i, w-1)
		for j = w-2:-1:1 {
			if data(i,j) > mh {
				set vis(i,j) = 1
				set mh = data(i,j)
			}
		}
	}

	for j = 1:1:w-2 {
		set mh = data(0, j)
		for i = 1:1:h-2 {
			if data(i,j) > mh {
				set vis(i,j) = 1
				set mh = data(i,j)
			}
		}
		
		set mh = data(h-1, j)
		for i = h-2:-1:1 {
			if data(i,j) > mh {
				set vis(i,j) = 1
				set mh = data(i,j)
			}
		}
	}

	set total = 0
	for i = 0:1:h-1 {
		for j = 0:1:w-1 {
			set:vis(i,j) total = total + 1
		}
	}
	
	return total
}

ClassMethod Part2() As %Integer
{
    set stream = ..GetInput(..#InputFile)
    
    kill data
    set li = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set w = $length(line)
		for j = 0:1:w-1 {
			set data(li,j) = $extract(line, j+1) + 0
		}
		set li = li + 1
	}

	set h = li
	set bestDistance = 1
	
	for x = 1:1:w-1 {
		for y = 1:1:h-1 {
			set distance = 1
			
			set s = 1
			set br = 0
			for i = x-1:-1:1 {
				if 'br && (data(i,y) < data(x,y)) {
					set s = s + 1
				} else {
					set br = 1
				}
			}
			
			set t = 1
			set br = 0
			for i = x+1:1:w-2 {
				if 'br && (data(i,y) < data(x,y)) {
					set t = t + 1
				} else {
					set br = 1
				}
			}

			set u = 1
			set br = 0
			for j = y+1:1:h-2 {
				if 'br && (data(x,j) < data(x,y)) {
					set u = u + 1
				} else {
					set br = 1
				}
			}
			
			set v = 1
			set br = 0
			for j = y-1:-1:1 {
				if 'br && (data(x,j) < data(x,y)) {
					set v = v + 1
				} else {
					set br = 1
				}
			}

			set distance = distance * s * t * u * v
			set:(distance > bestDistance) bestDistance = distance
		}
	}

	return bestDistance
}

}
