import sequtils
import std/[sequtils, strutils, sugar, tables, enumerate]

func allEqual(s: openArray[int]): bool =
  allIt(s, it == s[0])

proc substract_pais_until_all_zero_and_extrapolate_next_value(values:seq[int]):int =
    var new_list:seq[int]
    var i:int = 0
    while(i<values.len-1):
        new_list.add(values[i+1]-values[i])
        i = i + 1
    if(allEqual(new_list) and new_list[0]==0):
        return values[values.len-1]
    else:
        return values[values.len-1] + substract_pais_until_all_zero_and_extrapolate_next_value(new_list)

proc part01(filename:string):int =
    for line in readFile(filename).splitLines:
        result = result + substract_pais_until_all_zero_and_extrapolate_next_value(line.split(" ").mapIt(it.parseInt))


proc substract_pais_until_all_zero_and_extrapolate_prev_value(values:seq[int]):int =
    var new_list:seq[int]
    var i:int = 0
    while(i<values.len-1):
        new_list.add(values[i+1]-values[i])
        i = i + 1
    if(allEqual(new_list) and new_list[0]==0):
        return values[0]
    else:
        return values[0] - substract_pais_until_all_zero_and_extrapolate_prev_value(new_list)

proc part02(filename:string):int =
    for line in readFile(filename).splitLines:
        result = result + substract_pais_until_all_zero_and_extrapolate_prev_value(line.split(" ").mapIt(it.parseInt))

proc main() =
    doAssert(part01("inputs/example_1_day09.txt")==114)
    echo "Parte 1: " & $part01("inputs/day09.txt")
    doAssert(part02("inputs/example_1_day09.txt")==2)
    echo "Parte 2: " & $part02("inputs/day09.txt")
when isMainModule:
  main()