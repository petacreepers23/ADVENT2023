import std/[sequtils, strutils, sugar, tables, enumerate]

proc parse(filename:string):seq[seq[seq[string]]] =
    for line in open(filename).lines: #seq[0]->result; seq[1]->numbers
        let result_numbers = line.split(":")[1]
                                 .split("|")
                                 .map(x => x.strip
                                    .split(" ")
                                    .filter(x => x != ""))
        result.add(result_numbers)

proc getPointsOfCard(result_numbers:seq[seq[string]]):int64 =
    for possible_number in result_numbers[1]:
        if(possible_number in result_numbers[0]):
            if(result == 0):
                result = 1
            else:
                result = result * 2

proc part01(filename:string):int64 =
    for result_numbers in parse(filename):
        result = result + getPointsOfCard(result_numbers)

proc getMatchingNumbers(result_numbers:seq[seq[string]]):int =
    for possible_number in result_numbers[1]:
        if(possible_number in result_numbers[0]):
                result = result + 1

type CardValue = object
    ammount_winners:int
    instances:int

proc part02(filename:string):int64 =
    var table = initOrderedTable[int,CardValue]()#card_number, values
    for (i,result_numbers) in enumerate(parse(filename)):
        let winning_numbers = getMatchingNumbers(result_numbers)
        table[i+1] = CardValue(
            ammount_winners:winning_numbers,
            instances:1
        )
    for i in table.keys:   
        for extra in countup(i+1,i+table[i].ammount_winners):
            table[extra].instances = table[extra].instances+table[i].instances

    for card in table.values:
        result = result + card.instances

proc main() =
    doAssert(part01("inputs/example_1_day04.txt")==13)
    doAssert(part02("inputs/example_1_day04.txt")==30)
    echo "Parte 1: " & $part01("inputs/day04.txt")
    echo "Parte 2: " & $part02("inputs/day04.txt")
when isMainModule:
  main()