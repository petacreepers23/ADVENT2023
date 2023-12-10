import sequtils
import std/[sequtils, strutils, sugar, tables, enumerate]
#day09.nim ok i am drunk as fucgjhhjk and i cannot selleep
#nice the storm led me ibto ab oasis.
#yes like and island made of meytal is ther same as a favbric of parts of smting
#oh mfg a hand glider
# a You pull out your handy Oasis And Sand Instability Sensor  very convinient who doesn't have oine
#wtf is smoking the people
#wtff extrapolation
#wtff extrapolation#wtff extrapolation#wtff extrapolation#wtff extrapolation#wtff extrapolation
#ok just saved the input
#ok ok i have to substract wach pair until the vlues of the list is all 0
#pffffffffff its 3am come on

func allEqual(s: openArray[int]): bool =
  allIt(s, it == s[0])

#If you find the next value for each history in this example and add them together, you get 114 ok so for each sum, accumulate
proc substract_pais_until_all_zero_and_extrapolate_next_value(values:seq[int]):int =
    var new_list:seq[int]
    #for pair in values.distribute(2):#dont know how to use this shit, see you tomorrow xd
    #ok i had to take a shit and got time to think
    var i:int = 0
    while(i<values.len-1):
        new_list.add(values[i+1]-values[i])
        i = i + 1
    #echo "newlist: " & $new_list
    if(allEqual(new_list) and new_list[0]==0):
        return values[values.len-1]
    else:
        let val_of_new_list = substract_pais_until_all_zero_and_extrapolate_next_value(new_list)
        #echo "val_of_new_list: " & $val_of_new_list
        #echo "sit: " & $(values[values.len-1] + new_list[new_list.len-1])
        return values[values.len-1] + val_of_new_list#this is going to fail like fuck
    #fuck this shit is not returning ok its 3:30 time to sleep

proc part01(filename:string):int =
    for line in readFile(filename).splitLines:
        result = result + substract_pais_until_all_zero_and_extrapolate_next_value(line.split(" ").mapIt(it.parseInt))

proc main() =
    #echo part01("inputs/example_1_day09.txt")
    doAssert(part01("inputs/example_1_day09.txt")==114)
    echo "Parte 1: " & $part01("inputs/day09.txt")
    #doAssert(part02("inputs/example_3_day08.txt")==6)
    #echo "Parte 2: " & $part02("inputs/day08.txt")
when isMainModule:
  main()