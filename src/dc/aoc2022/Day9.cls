Class dc.aoc2022.Day9 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day9.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Follow(hx As %Integer, hy As %Integer, ByRef tx, ByRef ty) As %Integer
{
	if (hx'=tx) || (hy'=ty) {
		if hx=tx {
			if hy > ty { set ty = hy - 1 }
			else { set ty = hy + 1 }
		} elseif hy=ty {
			if hx > tx { set tx = hx - 1 }
			else { set tx = hx + 1 }
		} else {
			set ax = $zabs(hx - tx)
			set ay = $zabs(hy - ty)
			if (ax + ay) > 2 {
				set tx = tx + ((hx - tx) / ax)
				set ty = ty + ((hy - ty) / ay)
			}
		}
	}
	return 1
}

ClassMethod Part1() As %Integer
{
    set stream = ..GetInput(..#InputFile)

	set (hx, hy) = 0
	set (tx, ty) = 0
	set visited(tx,ty) = 1
	set visitedCount = 1
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set direction = $extract(line, 1)
		set distance = $piece(line, " ", 2)
		
		set dx = 0
		set:direction="R" dx = 1
		set:direction="L" dx = -1
		set dy = 0
		set:direction="U" dy = 1
		set:direction="D" dy = -1

		for i=1:1:distance {
			set hx = hx + dx
			set hy = hy + dy
			set f = ..Follow(hx, hy, .tx, .ty)
		
			if '$data(visited(tx, ty)) {
				set visited(tx,ty) = 1
				set visitedCount = visitedCount + 1
			}
		}
	}

	return visitedCount
}

ClassMethod Part2() As %Integer
{
    set stream = ..GetInput(..#InputFile)

	set (hx, hy) = 0
	for i = 1:1:9 {
		set tx(i) = 0
		set ty(i) = 0
	}
	set visited(0,0) = 1
	set visitedCount = 1
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set direction = $extract(line, 1)
		set distance = $piece(line, " ", 2)
		
		set dx = 0
		set:direction="R" dx = 1
		set:direction="L" dx = -1
		set dy = 0
		set:direction="U" dy = 1
		set:direction="D" dy = -1

		for i=1:1:distance {
			set hx = hx + dx
			set hy = hy + dy
			
			set chx = hx
			set chy = hy
			for j=1:1:9 {
				set ctx = tx(j)
				set cty = ty(j)
				set f = ..Follow(chx, chy, .ctx, .cty)
				set (chx, tx(j)) = ctx
				set (chy, ty(j)) = cty
			}
			
		
			if '$data(visited(tx(9), ty(9))) {
				set visited(tx(9), ty(9)) = 1
				set visitedCount = visitedCount + 1
			}
		}
	}

	return visitedCount
}

}
