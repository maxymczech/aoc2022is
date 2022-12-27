Class dc.aoc2022.Day15 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day15.txt";

Parameter MaxCoord = 4000000;

Parameter MinChunkSize = 4;

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod GetDistance(a As %Integer, b As %Integer, c As %Integer, d As %Integer) As %Integer
{
	return $zabs(a - c) + $zabs(b - d)
}

ClassMethod Intersects(a1 As %Integer, a2 As %Integer, b1 As %Integer, b2 As %Integer) As %Integer
{
	return (a1 >= b1) && (a1 <= b2) || (b1 >= a1) && (b1 <= a2)
}

ClassMethod GetBeacons(ByRef beacons, ByRef beaconCount)
{
    set stream = ..GetInput(..#InputFile)
    set m = ##class(%Regex.Matcher).%New("Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)")

	set beaconCount = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if m.Match(line) {
			set beaconCount = beaconCount + 1
			set beacons(beaconCount, "sx") = m.Group(1)
			set beacons(beaconCount, "sy") = m.Group(2)
			set beacons(beaconCount, "bx") = m.Group(3)
			set beacons(beaconCount, "by") = m.Group(4)
		}
	}

	return 0
}

ClassMethod Part1() As %Integer
{
	do ..GetBeacons(.beacons, .beaconCount)
	
	set targetY = 2000000
	set xBeaconCount = 0
	for i = 1:1:beaconCount {
		if beacons(i, "by") = targetY {
			set isUnique = 1
			for j = 1:1:i-1 {
				if (beacons(j, "by") = targetY) && (beacons(i, "bx") = beacons(j, "bx")) {
					set isUnique = 0
				}
			}
			if isUnique {
				set xBeaconCount = xBeaconCount + 1
			}
		}
	}
	
	set xTargetsCount = 0
	for i = 1:1:beaconCount {
		set d = ..GetDistance(beacons(i, "sx"), beacons(i, "sy"), beacons(i, "bx"), beacons(i, "by"))
		set dy = ..GetDistance(0, targetY, 0, beacons(i, "sy"))
		set xInt = $zabs(d - dy)
		if dy < d {
			set xTargetsCount = xTargetsCount + 1
			set xTargets(xTargetsCount, "from") = beacons(i, "sx") - xInt
			set xTargets(xTargetsCount, "to") = beacons(i, "sx") + xInt
		}
	}
	
	set change = 1
	while change {
		set nextCount = 0
		set change = 0
		kill next
		
		for i = 1:1:xTargetsCount {
			for j = 1:1:i - 1 {
				if 'change {
					set intersects = ..Intersects(xTargets(i, "from"), xTargets(i, "to"), xTargets(j, "from"), xTargets(j, "to"))
					if intersects {
						set change = 1
						for k = 1:1:xTargetsCount {
							if (k'=i) && (k'=j) {
								set nextCount = nextCount + 1
								set next(nextCount, "from") = xTargets(k, "from")
								set next(nextCount, "to") = xTargets(k, "to")
							}
						}
						set nfrom = xTargets(i, "from")
						set:(xTargets(j, "from") < nfrom) nfrom = xTargets(j, "from")
						set nto = xTargets(i, "to")
						set:(xTargets(j, "to") > nto) nto = xTargets(j, "to")
						set nextCount = nextCount + 1
						set next(nextCount, "from") = nfrom
						set next(nextCount, "to") = nto
					}
				}
			}
		}
		
		if change {
			set xTargetsCount = nextCount
			for i = 1:1:nextCount {
				set xTargets(i, "from") = next(i, "from")
				set xTargets(i, "to") = next(i, "to")
			}
		}
	}
	
	set totalLength = 0
	for i = 1:1:xTargetsCount {
		set totalLength = totalLength + xTargets(i, "to") - xTargets(i, "from") + 1
	}

	return totalLength - xBeaconCount
}

ClassMethod IsCoveredByOne(x As %Integer, y As %Integer, chunkSize As %Integer, ByRef beacons, beaconCount As %Integer) As %Integer
{
	for i=1:1:beaconCount {
		set sx = beacons(i, "sx")
		set sy = beacons(i, "sy")
		set d = ..GetDistance(sx, sy, beacons(i, "bx"), beacons(i, "by"))
		set d1 = ..GetDistance(x, y, sx, sy)
		if d1 <= d {
			set m1 = x + chunkSize
			set:(m1>..#MaxCoord) m1 = ..#MaxCoord
			set d2 = ..GetDistance(m1, y, sx, sy)
			if d2 <= d {
				set m2 = y + chunkSize
				set:(m2>..#MaxCoord) m2 = ..#MaxCoord
				set d3 = ..GetDistance(x, m2, sx, sy)
				if d3 <= d {
					set d4 = ..GetDistance(m1, m2, sx, sy)
					if d4 <= d {
						return 1
					}
				}
			}
		}
	}
	return 0
}

ClassMethod Find(x As %Integer, y As %Integer, chunkSize As %Integer, ByRef beacons, beaconCount As %Integer, ByRef notCovered, ByRef notCoveredCount) As %Integer
{
	set covered = ..IsCoveredByOne(x, y, chunkSize, .beacons, beaconCount)
	if 'covered {
		if chunkSize <= ..#MinChunkSize {
			set notCoveredCount = notCoveredCount + 1
			set notCovered(notCoveredCount, "x") = x
			set notCovered(notCoveredCount, "y") = y
			set notCovered(notCoveredCount, "chunkSize") = chunkSize
		} else {
			set rup = chunkSize \ 2
			set ds = (chunkSize / 2)
			set:(ds'=rup) ds = rup + 1
			do ..Find(x, y, ds, .beacons, beaconCount, .notCovered, .notCoveredCount)
			do ..Find(x + ds, y, ds, .beacons, beaconCount, .notCovered, .notCoveredCount)
			do ..Find(x, y + ds, ds, .beacons, beaconCount, .notCovered, .notCoveredCount)
			do ..Find(x + ds, y + ds, ds, .beacons, beaconCount, .notCovered, .notCoveredCount)
		}
	}
	return 1
}

ClassMethod Part2() As %Integer
{
    do ..GetBeacons(.beacons, .beaconCount)
    set notCoveredCount = 0
    
	do ..Find(0, 0, ..#MaxCoord, .beacons, beaconCount, .notCovered, .notCoveredCount)
	write "[DEBUG] Non Covered Regions: ",notCoveredCount,!
	for k = 1:1:notCoveredCount {
		set x = notCovered(k, "x")
		set y = notCovered(k, "y")
		set chunkSize = notCovered(k, "chunkSize")
		for i = x:1:x+chunkSize {
			for j = y:1:y+chunkSize {
				set covered = ..IsCoveredByOne(i, j, 0, .beacons, beaconCount)
				if 'covered {
					set frequency = i * 4000000 + j
					return frequency
				}
			}
		}
	}
	
	return 0
}

}
