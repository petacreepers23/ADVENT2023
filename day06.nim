import std/[sequtils, strutils, sugar, tables, enumerate]

proc part01(filename:string):int =
    let lineas = readFile(filename).splitLines
    let tiempos = lineas[0]
                .split(':')[1]
                .split(" ")
                .map(x => x.strip())
                .filter(y => y != "")
                .map(x => x.parseUInt())
    let distancias = lineas[1]
                .split(':')[1]
                .split(" ")
                .map(x => x.strip())
                .filter(y => y != "")
                .map(x => x.parseUInt())
    var ways_combination : seq[int]
    for i,_ in enumerate(tiempos):
        var ways: int = 0
        for j in 1..(tiempos[i]-1):
            let time_remaining = tiempos[i]-j
            let distance_travelled = time_remaining*j
            if(distance_travelled>distancias[i]):
                ways = ways+1
        ways_combination.add(ways)
    return ways_combination.foldl(a*b)

proc part02(filename:string):int =
    let lineas = readFile(filename).splitLines
    let tiempos = lineas[0]
                .split(':')[1]
                .replace(" ","")
                .parseUInt()
    let distancias = lineas[1]
                .split(':')[1]
                .replace(" ","")
                .parseUInt()
    var ways_combination : seq[int]
    var ways: int = 0
    for j in 1..(tiempos-1):
        let time_remaining = tiempos-j
        let distance_travelled = time_remaining*j
        if(distance_travelled>distancias):
            ways = ways+1
    ways_combination.add(ways)
    return ways_combination.foldl(a*b)                   

proc main() =
    doAssert(part01("inputs/example_1_day06.txt")==288)
    doAssert(part02("inputs/example_1_day06.txt")==71503)
    echo "Parte 1: " & $part01("inputs/day06.txt")
    echo "Parte 2: " & $part02("inputs/day06.txt")
when isMainModule:
  main()