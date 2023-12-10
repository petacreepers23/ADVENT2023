import std/[sequtils, strutils, enumerate]

func allEqual(s: openArray[int]): bool =
  allIt(s, it == s[0])

type Position = object
    i:int
    j:int

type Direccion = enum
    norte=0,sur=1,este=2,oeste=3

proc getInitialPos(mapa:seq[string]):Position =
    for i,linea in enumerate(mapa):
        for j,letra in enumerate(linea):
            if(letra=='S'):
                return Position(i:i,j:j)

#devuelve norte sur este oeste
proc getSurroundingPipes(posicion_inicial:Position,mapa:seq[string]) : seq[char] =
    if(posicion_inicial.i>0):
        result.add(mapa[posicion_inicial.i-1][posicion_inicial.j])
    else:
        result.add('.')
    if(posicion_inicial.i<mapa.len-1):
        result.add(mapa[posicion_inicial.i+1][posicion_inicial.j])
    else:
        result.add('.')
    if(posicion_inicial.j>0):
        result.add(mapa[posicion_inicial.i][posicion_inicial.j-1])
    else:
        result.add('.')
    if(posicion_inicial.j<mapa[posicion_inicial.i].len-1):
        result.add(mapa[posicion_inicial.i][posicion_inicial.j+1])
    else:
        result.add('.')

proc getIfPipesPointsAtCenter(tuberias:seq[char]):seq[bool] =
    result.add(tuberias[0] in "|7F")
    result.add(tuberias[1] in "|JL")
    result.add(tuberias[2] in "-LF")
    result.add(tuberias[3] in "-7J")
    return result

proc getInitialPipeShape(posicion_inicial:Position,mapa:seq[string]) : char =
    let pointing_directions = getSurroundingPipes(posicion_inicial,mapa).getIfPipesPointsAtCenter
    if(pointing_directions[0] and pointing_directions[1]):#norte y sur
        return '|'
    if(pointing_directions[2] and pointing_directions[3]):#este con oeste
        return '-'
    if(pointing_directions[0] and pointing_directions[2]):#norte con este
        return 'J'
    if(pointing_directions[0] and pointing_directions[3]):#norte con oeste
        return 'L'
    if(pointing_directions[2] and pointing_directions[1]):#este con sur
        return '7'
    if(pointing_directions[3] and pointing_directions[1]):#oeste con sur
        return 'F'
    return '.'

proc getInitialDir(tubo:char):Direccion =
    case tubo:
        of '|':
            return norte
        of '-':
            return oeste
        of 'L':
            return sur
        of 'J':
            return sur
        of '7':
            return norte
        of 'F':
            return norte 
        else:
            doAssert(false) 

proc avancen(pos:Position,dir:Direccion,tipo:char,mapa:seq[string]):(Position,Direccion,char) =
    #echo "Estoy en " & $pos & " mirando a " & $dir & " y el tubo es: " & tipo
    case tipo:
        of '|':
            if(dir==norte):
                let new_pos = Position(i:pos.i-1,j:pos.j)
                return (new_pos,norte,mapa[new_pos.i][new_pos.j])
            if(dir==sur):
                let new_pos = Position(i:pos.i+1,j:pos.j)
                return (new_pos,sur,mapa[new_pos.i][new_pos.j])
        of '-':
            if(dir==este):
                let new_pos = Position(i:pos.i,j:pos.j-1)
                return (new_pos,este,mapa[new_pos.i][new_pos.j])
            if(dir==oeste):
                let new_pos = Position(i:pos.i,j:pos.j+1)
                return (new_pos,oeste,mapa[new_pos.i][new_pos.j])
        of 'L':
            if(dir==sur):
                let new_pos = Position(i:pos.i,j:pos.j+1)
                return (new_pos,oeste,mapa[new_pos.i][new_pos.j])
            if(dir==este):
                let new_pos = Position(i:pos.i-1,j:pos.j)
                return (new_pos,norte,mapa[new_pos.i][new_pos.j])
        of 'J':
            if(dir==sur):
                let new_pos = Position(i:pos.i,j:pos.j-1)
                return (new_pos,este,mapa[new_pos.i][new_pos.j])
            if(dir==oeste):
                let new_pos = Position(i:pos.i-1,j:pos.j)
                return (new_pos,norte,mapa[new_pos.i][new_pos.j])
        of '7':
            if(dir==norte):
                let new_pos = Position(i:pos.i,j:pos.j-1)
                return (new_pos,este,mapa[new_pos.i][new_pos.j])
            if(dir==oeste):
                let new_pos = Position(i:pos.i+1,j:pos.j)
                return (new_pos,sur,mapa[new_pos.i][new_pos.j])
        of 'F':
            if(dir==norte):
                let new_pos = Position(i:pos.i,j:pos.j+1)
                return (new_pos,oeste,mapa[new_pos.i][new_pos.j])
            if(dir==este):
                let new_pos = Position(i:pos.i+1,j:pos.j)
                return (new_pos,sur,mapa[new_pos.i][new_pos.j])
        else:
            doAssert(false)     

proc part01(filename:string):int =
    let mapa = readFile(filename).splitLines.filterIt(it!="")
    let posicion_inicial = getInitialPos(mapa)
    let tuberia_inicial = getInitialPipeShape(posicion_inicial,mapa)
    let direccion_inicial = getInitialDir(tuberia_inicial)
    doAssert(tuberia_inicial!='.')
    var (cur_pos,cur_dir,cur_tuberia) = avancen(posicion_inicial,direccion_inicial,tuberia_inicial,mapa)
    result = 2
    while(cur_pos!=posicion_inicial):
        (cur_pos,cur_dir,cur_tuberia) = avancen(cur_pos,cur_dir,cur_tuberia,mapa)
        result = result + 1
    return int(result/2)


proc main() =
    doAssert(part01("inputs/example_1_day10.txt")==4)
    doAssert(part01("inputs/example_2_day10.txt")==4)
    doAssert(part01("inputs/example_3_day10.txt")==8)
    doAssert(part01("inputs/example_4_day10.txt")==8)
    echo "Parte 1: " & $part01("inputs/day10.txt")
    #doAssert(part02("inputs/example_1_day10.txt")==2)
    #echo "Parte 2: " & $part02("inputs/day10.txt")
when isMainModule:
  main()