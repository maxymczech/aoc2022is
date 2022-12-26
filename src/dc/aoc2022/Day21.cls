Class dc.aoc2022.Day21 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day21.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod GetMonkeys(ByRef monkeys)
{
    set stream = ..GetInput(..#InputFile)

	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set name = $piece(line, ": ", 1)
		set rest = $piece(line, ": ", 2)
		if $length(rest) <= 8 {
			set monkeys(name, "type") = "number"
			set monkeys(name, "value") = rest
		} else {
			set a = $piece(rest, " ", 1)
			set op = $piece(rest, " ", 2)
			set b = $piece(rest, " ", 3)
			set monkeys(name, "type") = "op"
			set monkeys(name, "a") = a
			set monkeys(name, "b") = b
			set monkeys(name, "op") = op
		}
	}

	return 0
}

ClassMethod Solve(ByRef monkeys, name As %String) As %Integer
{
	if monkeys(name, "type") = "number" {
		return monkeys(name, "value")
	} else {
		set a = ..Solve(.monkeys, monkeys(name, "a"))
		set b = ..Solve(.monkeys, monkeys(name, "b"))
		set op = monkeys(name, "op")
		if op = "+" {
			return a + b
		} elseif op = "-" {
			return a - b
		} elseif op = "*" {
			return a * b
		} elseif op = "/" {
			return a / b
		}
	}
}

ClassMethod HasHumn(ByRef monkeys, name As %String) As %Integer
{
	if name = "humn" {
		return 1
	}
	if monkeys(name, "type") = "number" {
		return 0
	}
	set a = ..HasHumn(.monkeys, monkeys(name, "a"))
	set b = ..HasHumn(.monkeys, monkeys(name, "b"))
	if a || b {
		return 1
	}
	return 0
}

ClassMethod SolvePart2(ByRef monkeys, name As %String, want As %Integer) As %Integer
{
	if name = "humn" {
		set ^p2Result = want
		return want
	}
	if monkeys(name, "type") = "number" {
		return monkeys(name, "value")
	}
	set ord = ..HasHumn(.monkeys, monkeys(name, "a"))
	if ord {
		set left = monkeys(name, "b")
		set right = monkeys(name, "a")
	} else {
		set left = monkeys(name, "a")
		set right = monkeys(name, "b")
	}
	set a = ..Solve(.monkeys, left)
	set op = monkeys(name, "op")
	
	if op = "+" {
		set val = want - a
	} elseif op = "*" {
		set val = want / a
	} elseif op = "-" {
		set:ord val = want + a
		set:('ord) val = a - want
	} elseif op = "/" {
		set:ord val = want * a
		set:('ord) val = a / want
	}

	set b = ..SolvePart2(.monkeys, right, val)
	if op = "+" {
		return a + b
	} elseif op = "*" {
		return a * b
	} elseif op = "-" {
		if ord {
			return b - a
		} 
		return a - b
	} elseif op = "/" {
		if ord {
			return b / a
		} 
		return a / b

	}
}

ClassMethod Part1() As %Integer
{
	set t = ..GetMonkeys(.monkeys)	
	return ..Solve(.monkeys, "root")
}

ClassMethod Part2() As %Integer
{
	set t = ..GetMonkeys(.monkeys)	
	
	if ..HasHumn(.monkeys, monkeys("root", "a")) {
		set val = ..Solve(.monkeys, monkeys("root", "b"))
		set result = ..SolvePart2(.monkeys, monkeys("root", "a"), val)
	} else {
		set val = ..Solve(.monkeys, monkeys("root", "a"))
		set result = ..SolvePart2(.monkeys, monkeys("root", "b"), val)
	}
	
	return ^p2Result
}

}
