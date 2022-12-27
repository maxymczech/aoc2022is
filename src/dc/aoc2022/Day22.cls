Class dc.aoc2022.Day22 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day22.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod ReadData(ByRef map, ByRef height, ByRef width, ByRef jStart, ByRef path, ByRef pathLength)
{
	set stream = ..GetInput(..#InputFile)
    set m = ##class(%Regex.Matcher).%New("(\d+|R|L)")

	set height = 0
	set width = 0
	set pathLength = 0
	set jStart = -1
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		
		if $length(line) {
			set:($length(line)>width) width = $length(line)
			for j = 1:1:$length(line) {
				set c = $extract(line, j)
				set map(height, j - 1) = c
				if (c=".") && (height=0) && (jStart=-1) {
					set jStart = j - 1
				}
			}
			set height = height + 1
		} else {
			set pathStr = $zstrip(stream.ReadLine(), "*C")
			set m.Text = pathStr
			while m.Locate() {
				set pathLength = pathLength + 1
				set path(pathLength) = m.Group(1)
			}
		}
	}
	
	for i = 0:1:height-1 {
		for j = 0:1:width-1 {
			if '$data(map(i, j)) {
				set map(i, j) = " "
			}
		}
	}

	set ^stepDirs(0, 0) = 1
	set ^stepDirs(0, 1) = 0
	set ^stepDirs(1, 0) = 0
	set ^stepDirs(1, 1) = 1
	set ^stepDirs(2, 0) = -1
	set ^stepDirs(2, 1) = 0
	set ^stepDirs(3, 0) = 0
	set ^stepDirs(3, 1) = -1

	return 0
}

ClassMethod Part1() As %Integer
{
    set t = ..ReadData(.map, .height, .width, .jStart, .path, .pathLength)

	set x = jStart
	set y = 0
	set dir = 0

	for pi = 1:1:pathLength {
		set p = path(pi)
		if p="R" {
			set dir = (dir + 1) # 4
		} elseif p="L" {
			set dir = (dir + 4 - 1) # 4
		} else {
			set steps = p
			for i = 1:1:steps {
				if dir=0 {
					if map(y, (x + 1) # width) = "." {
						set x = (x + 1) # width
					} elseif map(y, (x + 1) # width) = " " {
						set j = 1
						while map(y, (x + j) # width) = " " {
							set j = j + 1
						}
						if map(y, (x + j) # width) '= "#" {
							set x = (x + j) # width
						}
					}
				} elseif dir=1 {
					if map((y + 1) # height, x) = "." {
						set y = (y + 1) # height
					} elseif map((y + 1) # height, x) = " " {
						set j = 1
						while map((y + j) # height, x) = " " {
							set j = j + 1
						}
						if map((y + j) # height, x) '= "#" {
							set y = (y + j) # height
						}
					}
				} elseif dir=2 {
					if map(y, (x + width - 1) # width) = "." {
						set x = (x + width - 1) # width
					} elseif map(y, (x + width - 1) # width) = " " {
						set j = 1
						while map(y, (x + width - j) # width) = " " {
							set j = j + 1
						}
						if map(y, (x + width - j) # width) '= "#" {
							set x = (x + width - j) # width
						}
					}
				} elseif dir=3 {
					if map((y + height - 1) # height, x) = "." {
						set y = (y + height - 1) # height
					} elseif map((y + height - 1) # height, x) = " " {
						set j = 1
						while map((y + height - j) # height, x) = " " {
							set j = j + 1
						}
						if map((y + height - j) # height, x) '= "#" {
							set y = (y + height - j) # height
						}
					}
				}
			}
		}
	}

	set result = ((y + 1) * 1000) + ((x + 1) * 4) + dir

	return result
}

ClassMethod Part2() As %Integer
{
    set t = ..ReadData(.map, .height, .width, .jStart, .path, .pathLength)
    
    set t = ..ReadData(.map, .height, .width, .jStart, .path, .pathLength)

	set x = jStart
	set y = 0
	set dir = 0
	set cubeSize = 50

	for pi = 1:1:pathLength {
		set p = path(pi)
		if p="R" {
			set dir = (dir + 1) # 4
		} elseif p="L" {
			set dir = (dir + 4 - 1) # 4
		} else {
			set steps = p
			for i = 1:1:steps {
				set faceNow = ((y \ cubeSize) * 4) + (x \ cubeSize)
				set xNext = x + ^stepDirs(dir, 0)
				set yNext = y + ^stepDirs(dir, 1)
				set dirNext = dir
				set faceNext = ((yNext \ cubeSize) * 4) + (xNext \ cubeSize)

				if (faceNow '= faceNext) || (xNext < 0) || (yNext < 0) {
					if faceNow = 1 {
						if dir = 2 {
							set dirNext = 0
							set xNext = 0
							set yNext = 149 - y
						} elseif dir = 3 {
							set dirNext = 0
							set xNext = 0
							set yNext = 100 + x
						}
					} elseif faceNow = 2 {
						if dir = 0 {
							set dirNext = 2
							set xNext = 99
							set yNext = 149 - y
						} elseif dir = 1 {
							set dirNext = 2
							set xNext = 99
							set yNext = x - 50
						} elseif dir = 3 {
							set dirNext = 3
							set xNext = x - 100
							set yNext = 199
						}
					} elseif faceNow = 5 {
						if dir = 0 {
							set dirNext = 3
							set xNext = 50 + y
							set yNext = 49
						} elseif dir = 2 {
							set dirNext = 1
							set xNext = y - 50
							set yNext = 100
						}
					} elseif faceNow = 8 {
						if dir = 2 {
							set dirNext = 0
							set xNext = 50
							set yNext = 149 - y
						} elseif dir = 3 {
							set dirNext = 0
							set xNext = 50
							set yNext = 50 + x
						}
					} elseif faceNow = 9 {
						if dir = 0 {
							set dirNext = 2
							set xNext = 149
							set yNext = 149 - y
						} elseif dir = 1 {
							set dirNext = 2
							set xNext = 49
							set yNext = x + 100
						}
					} elseif faceNow = 12 {
						if dir = 0 {
							set dirNext = 3
							set xNext = y - 100
							set yNext = 149
						} elseif dir = 1 {
							set dirNext = 1
							set xNext = 100 + x
							set yNext = 0
						} elseif dir = 2 {
							set dirNext = 1
							set xNext = y - 100
							set yNext = 0
						}
					}
				}

				if map(yNext,xNext) = "." {
					set x = xNext
					set y = yNext
					set dir = dirNext
				}
			}
		}
	}

	set result = ((y + 1) * 1000) + ((x + 1) * 4) + dir

	return result
}

}
