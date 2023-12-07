import std/[sequtils, strutils, sugar]

type Range = object
    dst_range_start:uint
    src_range_start:uint
    length:uint

type Mapa = object
    src_type:string
    dst_type:string
    ranges:seq[Range]

proc obtainDest(semilla:uint,ranges:seq[Range]):uint =
    for rang in ranges:
        #operator .. generates a closed interval, that is why the -1 since problem is [,) and not [,]
        if semilla in rang.src_range_start .. rang.src_range_start + rang.length-1:
            return rang.dst_range_start + (semilla - rang.src_range_start)
    return semilla

proc resolve(lineas:seq[string],semillas:seq[uint]):uint =
    var i: int = 0
    var finish: bool = false
    var maps:seq[Mapa]
    while(not finish):
        i = i + 1
        if(i==len(lineas)):
                finish = true
                break
        if("-to-" in lineas[i]):
            let types = lineas[i]
                            .split("-to-")
                            .map(x => x[0 .. (if x.find(" ") == -1: x.len else:x.find(" "))-1])
            var curr_map: Mapa
            curr_map.src_type=types[0]
            curr_map.dst_type=types[1]
            i = i + 1
            while(i<len(lineas) and lineas[i] != ""):
                let vec = lineas[i].split(" ").map(x => x.parseUInt())
                curr_map.ranges.add(Range(
                    dst_range_start: vec[0],
                    src_range_start: vec[1],
                    length: vec[2]))
                i = i + 1
            maps.add(curr_map)
            if(i==len(lineas)):
                finish = true

    var least_location:uint = uint.high
    for semilla in semillas:
        var temp : uint = semilla
        #we take advantage that maps are in order and the linked list is already formed
        for mapa in maps:
            temp = obtainDest(temp,mapa.ranges)
        if temp < least_location:
            least_location = temp
    maps = @[]
    return least_location
    #Obtener lista de mapas
        #Cada mapa es de un tipo->tipo, dest_range_start, src_range_start y longitud
    #Para cada semilla, calcular su "range" osea semila->soil soil->humedad humedad->range y quedarse con el menor
    #es una puta linked list
    #en el fichero viene en orden asi que un for y a volar

proc part01(filename:string):uint =
    #Obtener lista de semillas
    let lineas = readFile(filename).splitLines
    let semillas = lineas[0]
                    .split(':')[1]
                    .split(" ")
                    .map(x => x.strip())
                    .filter(y => y != "")
                    .map(x => x.parseUInt())
    return resolve(lineas,semillas)

proc part02(filename:string):uint =
    #Obtener lista de semillas
    let lineas = readFile(filename).splitLines
    let semillas = lineas[0]
                    .split(':')[1]
                    .split(" ")
                    .map(x => x.strip())
                    .filter(y => y != "")
                    .map(x => x.parseUInt())
    var nuevas_semillas: seq[uint]#2-5GB aprox
    var least_location:uint = uint.high
    var i:int = 0
    while(i<semillas.len):#Fuck efficiency, I don't want to think
        nuevas_semillas = toSeq(semillas[i]..semillas[i]+semillas[i + 1]-1) #out of memory sometimes
        let mejor_de_la_linea:uint = resolve(lineas,nuevas_semillas)
        nuevas_semillas.setLen(0)#resizes the seq without allocating a new one
        if(mejor_de_la_linea<least_location):
            least_location = mejor_de_la_linea
        i = i + 2
    return least_location

proc main() =
    doAssert(part01("inputs/example_1_day05.txt")==35)
    doAssert(part02("inputs/example_1_day05.txt")==46)
    echo "Parte 1: " & $part01("inputs/day05.txt")
    echo "Parte 2: " & $part02("inputs/day05.txt")
when isMainModule:
  main()