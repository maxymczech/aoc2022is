Class dc.aoc2022.Day16 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day16.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod GetDistance(ByRef graph, nodeFrom As %String, nodeTo As %String) As %Integer
{
	if nodeFrom = nodeTo {
		return 0
	}

	set qLength = 1
	set q(1, "node") = nodeFrom
	set q(1, "length") = 0
	set visited(nodeFrom) = 1

	set qi = 0
    while (qi < qLength) {
	    set qi = qi + 1
	    set node = q(qi, "node")
	    set length = q(qi, "length")
	    
	    for i = 1:1:graph(node, "count") {
		    set neighbor = graph(node, i)
		    if '$data(visited(neighbor)) {
			    if neighbor = nodeTo {
				    return length + 1
			    }
			    set visited(neighbor) = 1
			    set qLength = qLength + 1
				set q(qLength, "node") = neighbor
				set q(qLength, "length") = length + 1

		    }
        }
    }
    return -1
}

ClassMethod PrepareInput(ByRef graph, ByRef rates, ByRef distances, ByRef valves, ByRef valvesCount, ByRef nonZeroValves, ByRef nonZeroCount)
{
    set stream = ..GetInput(..#InputFile)
    set m = ##class(%Regex.Matcher).%New("Valve (..) has flow rate=(\d+); tunnels? leads? to valves? (.+)")

    set valvesCount = 0
    set nonZeroCount = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if m.Match(line) {
			set valve = m.Group(1)
			set rate = m.Group(2)
			set nodes = m.Group(3)
			set nodeCount = $length(nodes, ", ")

			set valvesCount = valvesCount + 1
			set valves(valvesCount) = valve

			set rates(valve) = rate
			if rate '= 0 {
				set nonZeroCount = nonZeroCount + 1
				set nonZeroValves(nonZeroCount) = valve
			}

			set graph(valve, "count") = nodeCount
			for i = 1:1:nodeCount {
				set graph(valve, i) = $piece(nodes, ", ", i)
			}
		}
	}
	
	for i = 1:1:valvesCount {
		for j = 1:1:valvesCount {
			set distances(valves(i), valves(j)) = ..GetDistance(.graph, valves(i), valves(j))
		}
	}

	return 1
}

ClassMethod GetKey(ByRef nodes, count As %Integer)
{
	for i = 1:1:count{
		set key(i) = nodes(i, "valve")
	}
	for i = 1:1:count {
		for j = 1:1:count - 1 {
			set c1 = ($ascii($extract(key(j),1)) * 300) + $ascii($extract(key(j),2))
			set c2 = ($ascii($extract(key(j + 1),1)) * 300) + $ascii($extract(key(j + 1),2))
			if (c1 > c2) {
				set t = key(j)
				set key(j) = key(j + 1)
				set key(j + 1) = t
			}
		}
	}
	set result = key(1)
	for i = 2:1:count{
		set result = result _ "," _ key(i)
	}
	return result
}

ClassMethod GetRates(ByRef distances, ByRef rates, valve As %String, minutes As %Integer, ByRef left, leftCount As %Integer, ByRef opened, openedCount As %Integer)
{
	set sum = 0
	for i=1:1:openedCount {
		set valve = opened(i, "valve")
		set minutes = opened(i, "minutes")
		set sum = sum + (rates(valve) * minutes)
	}
	if sum > 0 {
		set ^allRatesCount = ^allRatesCount + 1
		set ^allRates(^allRatesCount, "total") = sum
		set ^allRates(^allRatesCount, "key") = ..GetKey(.opened, openedCount)
		set ^allRates(^allRatesCount, "keyLength") = openedCount
	}
	
	for i=1:1:leftCount {
		set other = left(i)
		set newMinutes = minutes - distances(valve,other) - 1
		if newMinutes >= 1 {
			for j = 1:1:openedCount {
				set newOpened(j,"valve") = opened(j, "valve")
				set newOpened(j,"minutes") = opened(j, "minutes")
			}
			set newOpenedCount = openedCount + 1
			set newOpened(newOpenedCount, "valve") = other
			set newOpened(newOpenedCount, "minutes") = newMinutes
			
			set newLeftCount = 0
			for j = 1:1:leftCount {
				if j '= i {
					set newLeftCount = newLeftCount + 1
					set newLeft(newLeftCount) = left(j)
				}
			}

			set t = ..GetRates(.distances, .rates, other, newMinutes, .newLeft, newLeftCount, .newOpened, newOpenedCount)
		}
	}
	return 1
}

ClassMethod Part1() As %Integer
{
	set t = ..PrepareInput(.graph, .rates, .distances, .valves, .valvesCount, .nonZeroValves, .nonZeroCount)

	kill ^allRates
	set ^allRatesCount = 0
	set t = ..GetRates(.distances, .rates, "AA", 30, .nonZeroValves, nonZeroCount, .opened, 0)
	
	set bestRate = 0
	for i = 1:1:^allRatesCount {
		set:(^allRates(i, "total") > bestRate) bestRate = ^allRates(i, "total")
	}

	return bestRate
}

ClassMethod Part2() As %Integer
{
	set t = ..PrepareInput(.graph, .rates, .distances, .valves, .valvesCount, .nonZeroValves, .nonZeroCount)

	kill ^allRates
	set ^allRatesCount = 0
	set t = ..GetRates(.distances, .rates, "AA", 26, .nonZeroValves, nonZeroCount, .opened, 0)
	
	set keyCount = 0
	for i = 1:1:^allRatesCount {
		set key = ^allRates(i, "key")
		set keyLength = ^allRates(i, "keyLength")
		set total = ^allRates(i, "total")
		
		if '$data(maxTotals(key)) {
			set maxTotals(key) = 0
			set keyCount = keyCount + 1
			set keys(keyCount) = key
			set keyLength(keyCount) = keyLength
		}
		set:(total>maxTotals(key)) maxTotals(key) = total
	}
	
	set bestRate = 0
	for pi = 1:1:keyCount {
		for ei = 1:1:keyCount {
			kill visitedValves
			set visitedValvesCount = 0
		
			for i = 1:1:keyLength(pi){
				set key = $piece(keys(pi),",",i)
				if '$data(visitedValves(key)) {
					set visitedValves(key) = 1
					set visitedValvesCount = visitedValvesCount + 1
				}
			}
		
			for i = 1:1:keyLength(ei){
				set key = $piece(keys(ei),",",i)
				if '$data(visitedValves(key)) {
					set visitedValves(key) = 1
					set visitedValvesCount = visitedValvesCount + 1
				}
			}

			if visitedValvesCount = (keyLength(pi) + keyLength(ei)) {
				set score = maxTotals(keys(pi)) + maxTotals(keys(ei))
				set:(score > bestRate) bestRate = score
			}
		}

	}

	return bestRate
}

}
