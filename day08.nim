import std/[sequtils, strutils, tables,sugar, enumerate, math]

type Node = object #name of node will be stored as key of a map
    le: string
    ri: string

proc parse(filename:string):(Table[string,Node],string) = 
    var mapa : Table[string,Node]
    var instrucciones : string
    for i,linea in enumerate(readFile(filename).splitLines):
        if(i==0): #fuck efficiency on parsing xD
            instrucciones = linea
            continue
        if(linea==""):
            continue
        let key_vals = linea.multiReplace(("(",""),(")","")).split("=").map(x=>x.strip)
        mapa[key_vals[0]] = Node(le:key_vals[1].split(",")[0].strip,ri:key_vals[1].split(",")[1].strip) #lamentable
    return (mapa,instrucciones)

proc part01(filename:string):int =
    let (mapa,instrucciones) = parse(filename) 
    var current_pos = "AAA"
    while(current_pos!="ZZZ"):
        if instrucciones[result mod instrucciones.len] == 'R':
            current_pos = mapa[current_pos].ri
        else:
            current_pos = mapa[current_pos].le
        result = result + 1

proc part02_iterative(filename:string):int = #does not work on input, takes too long >5h
    let (mapa,instrucciones) = parse(filename) 
    var current_possses = toSeq(mapa.keys).filter(x => x[x.len-1]=='A')
    while(current_possses.filter(x => x[x.len-1]=='Z').len!=current_possses.len):
        if instrucciones[result mod instrucciones.len] == 'R':
            current_possses = current_possses.mapIt(mapa[it].ri)
        else:
            current_possses = current_possses.mapIt(mapa[it].le)
        result = result + 1

proc part(mapa: Table[string,Node],instrucciones: string, initial_pos:string):int =
    var current_pos = initial_pos
    while(not current_pos.endsWith('Z')):
        if instrucciones[result mod instrucciones.len] == 'R':
            current_pos = mapa[current_pos].ri
        else:
            current_pos = mapa[current_pos].le
        result = result + 1

proc part02(filename:string):int =
    let (mapa,instrucciones) = parse(filename) 
    let init_possses = toSeq(mapa.keys).filter(x => x.endsWith('A'))
    var cycles: seq[int]
    for pos in init_possses:
        cycles.add(part(mapa,instrucciones,pos))
    #echo cycles
    #failed tries: #69260879921 #69260879966 #69260879968low #69260880000
    #not needed to find cycle length + remainder, but full lcm of part1 starting in "ends with A" works... ok
    return lcm(cycles)

proc main() =
    doAssert(part01("inputs/example_1_day08.txt")==2)
    doAssert(part01("inputs/example_2_day08.txt")==6)
    echo "Parte 1: " & $part01("inputs/day08.txt")

    doAssert(part02_iterative("inputs/example_3_day08.txt")==6)
    doAssert(part02("inputs/example_3_day08.txt")==6)
    echo "Parte 2: " & $part02("inputs/day08.txt")
when isMainModule:
  main()