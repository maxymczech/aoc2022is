Class dc.aoc2022.Day24 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day24.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod ReadData(ByRef data, ByRef height, ByRef width, ByRef jFrom, ByRef jTo)
{
	set stream = ..GetInput(..#InputFile)

	set height = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set width = $length(line)
		set c2 = $extract(line, 2)
		set c3 = $extract(line, 3)
		for j = 1:1:width {
			set c = $extract(line, j)
			if c = "#" {
				set data(height, j - 1, "type") = "wall"
			} else {
				set data(height, j - 1, "type") = "field"
				set data(height, j - 1, ">") = 0
				set data(height, j - 1, "<") = 0
				set data(height, j - 1, "^") = 0
				set data(height, j - 1, "v") = 0
				if c '= "." {
					set data(height, j - 1, c) = 1
				}
				if height = 0 {
					set jFrom = j - 1
				}
				if (c2 = "#") || (c3 = "#") {
					set jTo = j - 1
				}
			}
		}
		set height = height + 1
	}
	
	set ^dirs(".", "i") = 0
	set ^dirs(".", "j") = 0
	set ^dirs(">", "i") = 0
	set ^dirs(">", "j") = 1
	set ^dirs("<", "i") = 0
	set ^dirs("<", "j") = -1
	set ^dirs("v", "i") = 1
	set ^dirs("v", "j") = 0
	set ^dirs("^", "i") = -1
	set ^dirs("^", "j") = 0
	set ^moves(1) = "."
	set ^moves(2) = ">"
	set ^moves(3) = "<"
	set ^moves(4) = "v"
	set ^moves(5) = "^"

	return 0
}

ClassMethod Simulate(ByRef data, height As %Integer, width As %Integer)
{
	for i = 0:1:height-1 {
		for j = 0:1:width-1 {
			set next(i, j, "type") = data(i, j, "type")
			if data(i, j, "type") = "field" {
				set next(i, j, ">") = 0
				set next(i, j, "<") = 0
				set next(i, j, "^") = 0
				set next(i, j, "v") = 0
			}
		}
	}

	for i = 1:1:height-2 {
		for j = 1:1:width-2 {
			if data(i, j, "type") = "field" {
				for mi = 2:1:5 {
					set c = ^moves(mi)
					set ni = i
					set nj = j
					if (c = ">") {
						if next(ni, nj + 1, "type") = "field" {
							set nj = nj + 1
						} else {
							set nj = 1
						}
					} elseif (c = "<") {
						if next(ni, nj - 1, "type") = "field" {
							set nj = nj - 1
						} else {
							set nj = width - 2
						}
					} elseif (c = "v") {
						if next(ni + 1, nj, "type") = "field" {
							set ni = ni + 1
						} else {
							set ni = 1
						}
					} elseif (c = "^") {
						if next(ni - 1, nj, "type") = "field" {
							set ni = ni - 1
						} else {
							set ni = height - 2
						}
					}
					set next(ni, nj, c) = next(ni, nj, c) + data(i, j, c)
				}
			}
		}
	}
	
	for i = 0:1:height-1 {
		for j = 0:1:width-1 {
			set data(i, j, "type") = next(i, j, "type")
			if data(i, j, "type") = "field" {
				set data(i, j, ">") = next(i, j, ">")
				set data(i, j, "<") = next(i, j, "<")
				set data(i, j, "^") = next(i, j, "^")
				set data(i, j, "v") = next(i, j, "v")
			}
		}
	}

	return 0
}

ClassMethod PathLength(ByRef data, height As %Integer, width As %Integer, iFrom As %Integer, jFrom As %Integer, iTo As %Integer, jTo As %Integer)
{
	set possibleLength = 1
	set possible(0, "i") = iFrom
	set possible(0, "j") = jFrom
	set step = 1
	
	while 1 {
		set t = ..Simulate(.data, height, width)
		set nextPossibleLength = 0
		for pi = 0:1:possibleLength-1 {
			for mi = 1:1:5 {
				set ni = possible(pi, "i") + ^dirs(^moves(mi), "i")
				set nj = possible(pi, "j") + ^dirs(^moves(mi), "j")
				if (ni >= 0) && (nj >= 0) && (ni < height) && (nj < width) {
					if data(ni, nj, "type") = "field" {
						set isFull = data(ni, nj, ">") + data(ni, nj, "<") + data(ni, nj, "v") + data(ni, nj, "^")
						if 'isFull {
							set alreadyPossible = 0
							for k = 0:1:nextPossibleLength-1 {
								if (nextPossible(k, "i") = ni) && (nextPossible(k, "j") = nj) {
									set alreadyPossible = 1
								}
							}
							if ('alreadyPossible) {
								set nextPossible(nextPossibleLength, "i") = ni
								set nextPossible(nextPossibleLength, "j") = nj
								set nextPossibleLength = nextPossibleLength + 1
							}
						}
					}
				}
			}
		}
		set possibleLength = nextPossibleLength
		// write step
		for k = 0:1:possibleLength-1 {
			set possible(k, "i") = nextPossible(k, "i")
			set possible(k, "j") = nextPossible(k, "j")
			// write " [",nextPossible(k, "i")," ",nextPossible(k, "j"),"]"
			if (nextPossible(k, "i") = iTo) && (nextPossible(k, "j") = jTo) {
				return step
			}
		}
		// write !
		if step > 500 {
			return 0
		}
		set step = step + 1
	}
}

ClassMethod Print(ByRef data, height As %Integer, width As %Integer)
{
	for i = 0:1:height-1 {
		for j = 0:1:width-1 {
			if data(i, j, "type") = "field" {
				set c = data(i, j, ">") + data(i, j, "<") + data(i, j, "^") + data(i, j, "v")
				if c = 0 {
					write "."
				} elseif c = 1 {
					for mi=2:1:5 {
						set m = ^moves(mi)
						if data(i, j, m){
							write m
						}
					}
				} else {
					write c
				}
			} else {
				write "#"
			}
		}
		write !
	}
}

ClassMethod Part1() As %Integer
{
    set t = ..ReadData(.data, .height, .width, .jFrom, .jTo)
    
    set a = ..PathLength(.data, height, width, 0, jFrom, height - 1, jTo)

	return a
}

ClassMethod Part2() As %Integer
{
    set t = ..ReadData(.data, .height, .width, .jFrom, .jTo)
    
    set a = ..PathLength(.data, height, width, 0, jFrom, height - 1, jTo)
    set b = ..PathLength(.data, height, width, height - 1, jTo, 0, jFrom)
    set c = ..PathLength(.data, height, width, 0, jFrom, height - 1, jTo)

	return a + b + c
}

}
