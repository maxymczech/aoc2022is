Class dc.aoc2022.Day7 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day7.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod BuildTree(ByRef tree)
{
    set stream = ..GetInput(..#InputFile)
    set current = "/"
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if $extract(line, 1) = "$" {
			if $extract(line, 3, 4) = "cd" {
				set folder = $extract(line, 6, $length(line))
				if folder = "/" {
					set current = "/"
				} elseif folder = ".." {
					set current = tree(current, "parent")
				} else {
					set k = current _ folder _ "/"
					set tree(k, "parent") = current
					set current = k
				}
			}
		} else {
			if $extract(line, 1, 3) = "dir" {
				set folder = $extract(line, 5, $length(line))
				if $data(tree(current, "childrenCount")) {
					set tree(current, "children", tree(current, "childrenCount") + 1) = folder
					set tree(current, "childrenCount") = tree(current, "childrenCount") + 1
				} else {
					set tree(current, "children", 1) = folder
					set tree(current, "childrenCount") = 1
				}
				set k = current _ folder _ "/"
				set tree(k, "parent") = current
			} else {
				set size = $piece(line, " ", 1)
				set fileName = $piece(line, " ", 2)
				if $data(tree(current, "childrenCount")) {
					set tree(current, "children", tree(current, "childrenCount") + 1) = fileName
					set tree(current, "childrenCount") = tree(current, "childrenCount") + 1
				} else {
					set tree(current, "children", 1) = fileName
					set tree(current, "childrenCount") = 1
				}
				set k = current _ fileName _ "/"
				set tree(k, "size") = size
			}
		}
	}

    return 1
}

ClassMethod Walk1(ByRef tree, node As %String, ByRef sum) As %Integer
{
	if '$data(tree(node, "size")) {
		set size = 0
		if $data(tree(node, "childrenCount")) {
			for i = 1:1:tree(node, "childrenCount") {
				set k = node _ tree(node, "children", i) _ "/"
				set size = size + ..Walk1(.tree, k, .sum)
			}
		}
		set tree(node, "size") = size
	}
	if $data(tree(node, "childrenCount")) && (tree(node, "size") <= 100000) {
		set sum = sum + tree(node, "size")
	}
	return tree(node, "size")
}

ClassMethod Walk2(ByRef tree, node As %String, ByRef best, target As %Integer) As %Integer
{
  if $data(tree(node, "childrenCount")) {
	set s = tree(node, "size")
	if (s >= target) && (s < best) {
	  set best = s
	}
	for i = 1:1:tree(node, "childrenCount") {
	  set k = node _ tree(node, "children", i) _ "/"
	  do ..Walk2(.tree, k, .best, target)
	}
  }
  return 1
}

ClassMethod Part1() As %Integer
{
	kill tree
	do ..BuildTree(.tree)
	
	set sum = 0
    do ..Walk1(.tree, "/", .sum)

	return sum
}

ClassMethod Part2() As %Integer
{
	kill tree
	do ..BuildTree(.tree)
	
	set sum = 0
	do ..Walk1(.tree, "/", .sum)
	
    set best = 9999999999
    set target = 30000000 - (70000000 - tree("/", "size"))
    do ..Walk2(.tree, "/", .best, target)

	return best
}

}
