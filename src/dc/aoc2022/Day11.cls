Class dc.aoc2022.Day11 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day11.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod GetMonkeys(ByRef monkeys) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    
    set mi = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if $find(line, "Starting items") {
			set lst = $piece(line, ": ", 2)
			set monkeys(mi, "itemCount") = $length(lst,",")
			for i = 1:1:monkeys(mi, "itemCount") {
				set monkeys(mi, "items", i) = $piece(lst, ", ", i)
			}
		}
		if $find(line, "Operation") {
			set monkeys(mi, "operation") = $piece(line, ": new = ", 2)
		}
		if $find(line, "Test:") {
			set monkeys(mi, "test") = $piece(line, "divisible by ", 2)
		}
		if $find(line, "If true") {
			set monkeys(mi, "ifTrue") = $piece(line, "throw to monkey ", 2)
		}
		if $find(line, "If false") {
			set monkeys(mi, "ifFalse") = $piece(line, "throw to monkey ", 2)
		}
		if (line = "") || stream.AtEnd {
			set monkeys(mi, "inspected") = 0
			set mi = mi + 1
		}
	}

	return mi
}

ClassMethod Part1() As %Integer
{
    kill monkeys
	set monkeyCount = ..GetMonkeys(.monkeys)
	
	for i = 1:1:20 {
		for j = 0:1:monkeyCount-1 {
			for k = 1:1:monkeys(j, "itemCount") {
				set old = monkeys(j, "items", k)
				set a = $piece(monkeys(j, "operation"), " ", 1)
				set op = $piece(monkeys(j, "operation"), " ", 2)
				set b = $piece(monkeys(j, "operation"), " ", 3)
				set:(a="old") a = old
				set:(b="old") b = old
				set:(op="+") n = (a + b) \ 3
				set:(op="*") n = (a * b) \ 3
				if (n # monkeys(j, "test"))=0 {
					set index = monkeys(j, "ifTrue")
				} else {
					set index = monkeys(j, "ifFalse")
				}
				set monkeys(index, "itemCount") = monkeys(index, "itemCount") + 1
				set monkeys(index, "items", monkeys(index, "itemCount")) = n
			}
			set monkeys(j, "inspected") = monkeys(j, "inspected") + monkeys(j, "itemCount")
			set monkeys(j, "itemCount") = 0
		}
	}
	
	set a = 0
	set b = 0
	for j = 0:1:monkeyCount-1 {
		if monkeys(j, "inspected") >= a {
			set b = a
			set a = monkeys(j, "inspected")
		} elseif monkeys(j, "inspected") >= b {
			set b = monkeys(j, "inspected")
		}
	}
	
	return a * b
}

ClassMethod Part2() As %Integer
{
    kill monkeys
	set monkeyCount = ..GetMonkeys(.monkeys)
	
	set d = 1
	for j = 0:1:monkeyCount-1 {
		set d = d * monkeys(j, "test")
	}
	
	for i = 1:1:10000 {
		for j = 0:1:monkeyCount-1 {
			for k = 1:1:monkeys(j, "itemCount") {
				set old = monkeys(j, "items", k)
				set a = $piece(monkeys(j, "operation"), " ", 1)
				set op = $piece(monkeys(j, "operation"), " ", 2)
				set b = $piece(monkeys(j, "operation"), " ", 3)
				set:(a="old") a = old
				set:(b="old") b = old
				set:(op="+") n = (a + b) # d
				set:(op="*") n = (a * b) # d
				if (n # monkeys(j, "test"))=0 {
					set index = monkeys(j, "ifTrue")
				} else {
					set index = monkeys(j, "ifFalse")
				}
				set monkeys(index, "itemCount") = monkeys(index, "itemCount") + 1
				set monkeys(index, "items", monkeys(index, "itemCount")) = n
			}
			set monkeys(j, "inspected") = monkeys(j, "inspected") + monkeys(j, "itemCount")
			set monkeys(j, "itemCount") = 0
		}
	}
	
	set a = 0
	set b = 0
	for j = 0:1:monkeyCount-1 {
		if monkeys(j, "inspected") >= a {
			set b = a
			set a = monkeys(j, "inspected")
		} elseif monkeys(j, "inspected") >= b {
			set b = monkeys(j, "inspected")
		}
	}
	
	return a * b
}

}
