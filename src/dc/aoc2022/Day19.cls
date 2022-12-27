Class dc.aoc2022.Day19 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day19.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod ReadBlueprints(ByRef blueprints, ByRef blueprintCount)
{
    set stream = ..GetInput(..#InputFile)
    set m = ##class(%Regex.Matcher).%New("Blueprint (\d+): Each ore robot costs (\d+) ore\. Each clay robot costs (\d+) ore\. Each obsidian robot costs (\d+) ore and (\d+) clay\. Each geode robot costs (\d+) ore and (\d+) obsidian\.")

	set blueprintCount = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if m.Match(line) {
			set blueprintCount = blueprintCount + 1
			set blueprints(blueprintCount, "id") = m.Group(1)
			set blueprints(blueprintCount, "oreOre") = m.Group(2)
			set blueprints(blueprintCount, "clayOre") = m.Group(3)
			set blueprints(blueprintCount, "obsOre") = m.Group(4)
			set blueprints(blueprintCount, "obsClay") = m.Group(5)
			set blueprints(blueprintCount, "geoOre") = m.Group(6)
			set blueprints(blueprintCount, "geoObs") = m.Group(7)
		}

	}
	
	return 1
}

ClassMethod CanBuildBot(ByRef q, qi As %Integer, botType As %String) As %Integer
{
	if botType = "ore" {
		return (q(qi, "botsOre") > 0)
	}
	if botType = "clay" {
		return (q(qi, "botsOre") > 0)
	}
	if botType = "obs" {
		return (q(qi, "botsOre") > 0) && (q(qi, "botsClay") > 0)
	}
	if botType = "geo" {
		return (q(qi, "botsOre") > 0) && (q(qi, "botsObs") > 0)
	}
}

ClassMethod BuildBot(ByRef blueprints, bi As %Integer, ByRef q, qi As %Integer, botType As %String) As %Integer
{
	if botType = "ore" {
		set q(qi, "resOre") = q(qi, "resOre") - blueprints(bi, "oreOre")
	}
	if botType = "clay" {
		set q(qi, "resOre") = q(qi, "resOre") - blueprints(bi, "clayOre")
	}
	if botType = "obs" {
		set q(qi, "resOre") = q(qi, "resOre") - blueprints(bi, "obsOre")
		set q(qi, "resClay") = q(qi, "resClay") - blueprints(bi, "obsClay")
	}
	if botType = "geo" {
		set q(qi, "resOre") = q(qi, "resOre") - blueprints(bi, "geoOre")
		set q(qi, "resObs") = q(qi, "resObs") - blueprints(bi, "geoObs")
	}
	return 1
}

ClassMethod PushQ(ByRef q, qi As %Integer, ByRef qLength) As %Integer
{
	set qLength = qLength + 1
	set q(qLength, "botsOre") = q(qi, "botsOre")
	set q(qLength, "botsClay") = q(qi, "botsClay")
	set q(qLength, "botsObs") = q(qi, "botsObs")
	set q(qLength, "botsGeo") = q(qi, "botsGeo")
	set q(qLength, "timeLeft") = q(qi, "timeLeft")
	set q(qLength, "resOre") = q(qi, "resOre")
	set q(qLength, "resClay") = q(qi, "resClay")
	set q(qLength, "resObs") = q(qi, "resObs")
	set q(qLength, "resGeo") = q(qi, "resGeo")
	return 1
}

ClassMethod AdvanceResources(ByRef q, qi As %Integer, time As %Integer) As %Integer
{
	set q(qi, "resOre") = q(qi, "resOre") + (q(qi, "botsOre") * time)
	set q(qi, "resClay") = q(qi, "resClay") + (q(qi, "botsClay") * time)
	set q(qi, "resObs") = q(qi, "resObs") + (q(qi, "botsObs") * time)
	set q(qi, "resGeo") = q(qi, "resGeo") + (q(qi, "botsGeo") * time)
	return 1
}

ClassMethod Schedule(ByRef blueprints, bi As %Integer, ByRef q, qi As %Integer, ByRef qLength, botType As %String, minTime As %Integer) As %Integer
{
	set t = ..CanBuildBot(.q, qi, botType)
	if 't {
		return 0
	}
	
	set t = 0
	if botType = "ore" {
		set u = (blueprints(bi, "oreOre") - q(qi, "resOre")) / q(qi, "botsOre")
		if u > 0 {
			set ud = u \ 1
			set:(ud'=u) u = ud + 1
			set:(u>t) t = u
		}
	}
	if botType = "clay" {
		set u = (blueprints(bi, "clayOre") - q(qi, "resOre")) / q(qi, "botsOre")
		if u > 0 {
			set ud = u \ 1
			set:(ud'=u) u = ud + 1
			set:(u>t) t = u
		}
	}
	if botType = "obs" {
		set u = (blueprints(bi, "obsOre") - q(qi, "resOre")) / q(qi, "botsOre")
		if u > 0 {
			set ud = u \ 1
			set:(ud'=u) u = ud + 1
			set:(u>t) t = u
		}
		
		set v = (blueprints(bi, "obsClay") - q(qi, "resClay")) / q(qi, "botsClay")
		if v > 0 {
			set vd = v \ 1
			set:(vd'=v) v = vd + 1
			set:(v>t) t = v
		}
	}
	if botType = "geo" {
		set u = (blueprints(bi, "geoOre") - q(qi, "resOre")) / q(qi, "botsOre")
		if u > 0 {
			set ud = u \ 1
			set:(ud'=u) u = ud + 1
			set:(u>t) t = u
		}
		
		set v = (blueprints(bi, "geoObs") - q(qi, "resObs")) / q(qi, "botsObs")
		if v > 0 {
			set vd = v \ 1
			set:(vd'=v) v = vd + 1
			set:(v>t) t = v
		}
	}
	

	if (q(qi, "timeLeft") - t) < minTime {
		return 0
	}
	
	do ..PushQ(.q, qi, .qLength)
	set q(qLength, "timeLeft") = q(qi, "timeLeft") - t - 1
	do ..AdvanceResources(.q, qLength, t + 1)
	do ..BuildBot(.blueprints, bi, .q, qLength, botType)
	if botType = "ore" { set q(qLength, "botsOre") = q(qLength, "botsOre") + 1 }
	if botType = "clay" { set q(qLength, "botsClay") = q(qLength, "botsClay") + 1 }
	if botType = "obs" { set q(qLength, "botsObs") = q(qLength, "botsObs") + 1 }
	if botType = "geo" { set q(qLength, "botsGeo") = q(qLength, "botsGeo") + 1 }
	return 1
}

ClassMethod Solve(ByRef blueprints, bi As %Integer, timeLeft As %Integer) As %Integer
{
	set qLength = 1
	set bestResult = 0
	set earliestGeo = 0
	set q(qLength, "botsOre") = 1
	set q(qLength, "botsClay") = 0
	set q(qLength, "botsObs") = 0
	set q(qLength, "botsGeo") = 0
	set q(qLength, "timeLeft") = timeLeft
	set q(qLength, "resOre") = 0
	set q(qLength, "resClay") = 0
	set q(qLength, "resObs") = 0
	set q(qLength, "resGeo") = 0

	while qLength > 0 {
		set qi = -1
		do ..PushQ(.q, qLength, .qi)
		set qi = 0
		set qLength = qLength - 1
		
		if (q(qi, "resGeo") > 0) && (q(qi, "timeLeft") > earliestGeo) {
			set earliestGeo = q(qi, "timeLeft")
		}
		
		if (q(qi, "timeLeft") < earliestGeo) && (q(qi, "resGeo") = 0) {
		} else {
			if q(qi, "timeLeft") <= 0 {
				set:(q(qi, "resGeo")>bestResult) bestResult = q(qi, "resGeo")
			} else {
				set newPaths = 0

				set t = ..Schedule(.blueprints, bi, .q, qi, .qLength, "geo", 1)
				set:(t'=0) newPaths = 1
				
				set t = ..Schedule(.blueprints, bi, .q, qi, .qLength, "obs", 4)
				set:(t'=0) newPaths = 1
				
				if q(qi, "botsClay") < (blueprints(bi, "obsClay") - 1) {
					set t = ..Schedule(.blueprints, bi, .q, qi, .qLength, "clay", 7)
					set:(t'=0) newPaths = 1
				}
				
				if q(qi, "botsOre") < 4 {
					set t = ..Schedule(.blueprints, bi, .q, qi, .qLength, "ore", 16)
					set:(t'=0) newPaths = 1
				}
				
				if newPaths=0 {
					set t = ..PushQ(.q, qi, .qLength)
					set t = ..AdvanceResources(.q, qLength, q(qi, "timeLeft"))
					set q(qLength, "timeLeft") = 0
				}
			}
		}
	}
	
	return bestResult
}

ClassMethod Part1() As %Integer
{
	do ..ReadBlueprints(.blueprints, .blueprintCount)

	set sum = 0
	for i = 1:1:blueprintCount {
		set s = ..Solve(.blueprints, i, 24)
		set sum = sum + (s * blueprints(i, "id"))
	}

	return sum
}

ClassMethod Part2() As %Integer
{
	do ..ReadBlueprints(.blueprints, .blueprintCount)

	set mul = 1
	for i = 1:1:3 {
		set s = ..Solve(.blueprints, i, 32)
		set mul = mul * s
	}

	return mul
}

}
