import std/[sequtils, strutils, sugar, tables, enumerate,algorithm]

type Mano = object
    cartas : string
    apuesta: int

const score = "23456789TJQKA"
const score_part2 = "J23456789TQKA"

type Manos = enum
    nada=0,pareja=1,doblepareja=2,trio=3,full=4,poker=5,repoker=6

proc getHandType(hand:string): Manos =
    var table_of_equals: Table[char,int]
    for letra in hand:
        table_of_equals[letra] = hand.countIt(it==letra)
    case table_of_equals.len:
        of 1:
            return repoker
        of 2:
            if(max(toSeq(table_of_equals.values))==4):
                return poker
            else:
                return full
        of 3:
            if(max(toSeq(table_of_equals.values))==3):
                return trio
            else:
                return doblepareja
        of 4:
            return pareja
        else:
            return nada

proc cmpManos(x, y: Mano): int =
    result = getHandType(x.cartas).int-getHandType(y.cartas).int
    if(result==0):
        for i in 0..4:
            result = score.find(x.cartas[i])-score.find(y.cartas[i])
            if(result != 0):
                break;

proc part01(filename:string):int =
    var manos : seq[Mano]
    for linea in readFile(filename).splitLines:
        let mano_apuesta=linea.split(" ")
        manos.add(Mano(cartas:mano_apuesta[0],apuesta:mano_apuesta[1].parseInt))
    manos.sort(cmpManos,Ascending)
    for i,mano in enumerate(manos):
        result = result + (i+1) * mano.apuesta

proc getHandTypeWithJoker(hand:string): Manos =
    result = getHandType(hand)
    for posible_sustitution in score_part2[1..^1]:
        let temp_hand = hand.replace('J',posible_sustitution).getHandType
        if(temp_hand.int>result.int):
            result = temp_hand

proc cmpManos2(x, y: Mano): int = #couldn't find a better idea to fir the function inside manos.sort()
    result = getHandTypeWithJoker(x.cartas).int-getHandTypeWithJoker(y.cartas).int
    if(result==0):
        for i in 0..4:
            result = score_part2.find(x.cartas[i])-score_part2.find(y.cartas[i])
            if(result != 0):
                break;

proc part02(filename:string):int =
    var manos : seq[Mano]
    for linea in readFile(filename).splitLines:
        let mano_apuesta=linea.split(" ")
        manos.add(Mano(cartas:mano_apuesta[0],apuesta:mano_apuesta[1].parseInt))
    manos.sort(cmpManos2,Ascending)
    for i,mano in enumerate(manos):
        result = result + (i+1) * mano.apuesta  

proc main() =
    doAssert(getHandType("AAAAA")==repoker)
    doAssert(getHandType("AAAAJ")==poker)
    doAssert(getHandType("AAA11")==full)
    doAssert(getHandType("AAA12")==trio)
    doAssert(getHandType("A11A4")==doblepareja)
    doAssert(getHandType("1AA23")==pareja)
    doAssert(getHandType("12345")==nada)

    doAssert(getHandTypeWithJoker("AAJAA")==repoker)
    doAssert(getHandTypeWithJoker("AAAJK")==poker)
    doAssert(getHandTypeWithJoker("AA1J1")==full)
    doAssert(getHandTypeWithJoker("AJA12")==trio)
    doAssert(getHandTypeWithJoker("1234J")==pareja)
    doAssert(getHandTypeWithJoker("12345")==nada)

    doAssert(part01("inputs/example_1_day07.txt")==6440)
    doAssert(part02("inputs/example_1_day07.txt")==5905)
    echo "Parte 1: " & $part01("inputs/day07.txt")
    echo "Parte 2: " & $part02("inputs/day07.txt")
when isMainModule:
  main()