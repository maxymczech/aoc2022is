Class dc.aoc2022.Day5 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day5.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod GetCrates(ByRef lines, lineCount As %Integer, ByRef crates, ByRef crateCounts) As %Integer
{
	for i = lineCount-1:-1:1 {
		for j = 1:1:9 {
			set nj = 4 * j - 2
			set c = $extract(lines(i), nj)
			if c '= " " {
				set crates(j, crateCounts(j) + 1) = c
				set crateCounts(j) = crateCounts(j) + 1
			}
		}
	}
	return 1
}

ClassMethod Part1() As %String
{
    set stream = ..GetInput(..#InputFile)
    
    kill lines
    kill crates
    kill crateCounts
    set li = 1
    set crateLines = 0
    
    for i = 1:1:9 {
	    set crateCounts(i) = 0
    }
    
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if $extract(line, 2) = 1 {
			set t = ..GetCrates(.lines, li, .crates, .crateCounts)
			set crateLines = li
		}
		if $extract(line, 1) = "m" {
			set n = $piece(line, " ", 2)
			set f = $piece(line, " ", 4) + 0
			set t = $piece(line, " ", 6) + 0
			for i = 1:1:n {
				set crates(t, crateCounts(t) + 1) = crates(f, crateCounts(f))
				set crateCounts(t) = crateCounts(t) + 1
				set crateCounts(f) = crateCounts(f) - 1
			}
		}
		set lines(li) = line
		set li = li + 1
	}
	
	set result = ""
	for i = 1:1:9 {
		set result = result _ crates(i, crateCounts(i))
	}
	return result
}

ClassMethod Part2() As %String
{
    set stream = ..GetInput(..#InputFile)

	kill lines
    kill crates
    kill crateCounts
    set li = 1
    set crateLines = 0
    
    for i = 1:1:9 {
	    set crateCounts(i) = 0
    }
    
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if $extract(line, 2) = 1 {
			set t = ..GetCrates(.lines, li, .crates, .crateCounts)
			set crateLines = li
		}
		if $extract(line, 1) = "m" {
			set n = $piece(line, " ", 2)
			set f = $piece(line, " ", 4) + 0
			set t = $piece(line, " ", 6) + 0
			for i = 1:1:n {
				set crates(t, crateCounts(t) + n - i + 1) = crates(f, crateCounts(f))
				set crateCounts(f) = crateCounts(f) - 1
			}
			set crateCounts(t) = crateCounts(t) + n
		}
		set lines(li) = line
		set li = li + 1
	}
	
	set result = ""
	for i = 1:1:9 {
		set result = result _ crates(i, crateCounts(i))
	}
	return result
}

}
