Class dc.aoc2022.Day13 Extends dc.aoc2022.Base
{

Parameter InputFile = "Day13.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Compare(left, right) As %Integer
{
	set arrayLeft = $find($classname(left), "DynamicArray")
	set arrayRight = $find($classname(right), "DynamicArray")
	
	if (arrayLeft) && (arrayRight) {
		set leftCount = 0
		set iterLeft = left.%GetIterator()
		while iterLeft.%GetNext(.key, .value, .type ) {
			set leftCount = leftCount + 1
			set leftValues(leftCount) = value
			set leftTypes(leftCount) = type
		}	

		set rightCount = 0
		set iterRight = right.%GetIterator()
		while iterRight.%GetNext(.key, .value, .type ) {
			set rightCount = rightCount + 1
			set rightValues(rightCount) = value
			set rightTypes(rightCount) = type
		}
		
		set count = leftCount
		set:(rightCount<leftCount) count = rightCount

		for i = 1:1:count {
			set result = ..Compare(leftValues(i), rightValues(i))
			if (result < 0) return -1
			if (result > 0) return 1
		}
		return leftCount - rightCount
	} elseif (arrayRight) {
		set nextLeft = [].%Push(left)
		return ..Compare(nextLeft, right)
	} elseif (arrayLeft) {
		set nextRight = [].%Push(right)
		return ..Compare(left, nextRight)
	} else {
		return left - right
	}
}

ClassMethod Part1() As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set li = 0
    set i = 0
    set sum = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if line'="" {
			if (li # 2) {
				set right = [].%FromJSON(line)
			} else {
				set left = [].%FromJSON(line)
			}
			set li = li + 1
			if '(li # 2) {
				set c = ..Compare(left, right)
				set i = i + 1
				if c < 0 {
					set sum = sum + i
				}
			}
		}
	}

	return sum
}

ClassMethod Part2() As %Integer
{
    set stream = ..GetInput(..#InputFile)

	kill data
	set data(1) = [].%FromJSON("[[2]]")
	set data(2) = [].%FromJSON("[[6]]")
	set li = 2
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if line'="" {
			set li = li + 1
			set data(li) = [].%FromJSON(line)
		}
	}
	
	// Bubble sort :)
	for i = 1:1:li {
		for j = 1:1:li-i {
			set cmp = ..Compare(data(j), data(j + 1))
			if cmp > 0 {
				set t = data(j)
				set data(j) = data(j + 1)
				set data(j + 1) = t
			}
		}
	}
	
	for i = 1:1:li {
		set str = data(i).%ToJSON()
		set:(str = "[[2]]") n1 = i
		set:(str = "[[6]]") n2 = i
	}

	return n1 * n2
}

}
