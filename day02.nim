import strutils

######## Cosas que he necesitado de otros dias ########

iterator iterate_file(filename : string) : string =
    let f = open(filename)
    defer:
      f.close()
    var line : string
    while f.read_line(line):
      yield line

######## ##################################### ########

const red_cubes = 12
const green_cubes = 13
const blue_cubes = 14

type Cubes* = object
    valid*:bool
    red*: int
    green*: int
    blue*: int

type Game* = object
    id*: int
    content*: seq[Cubes]

proc removeSurroundingSpacesAndGetANumber(x:string):int =
    x.replace(" ","").parseInt()

proc cube_is_valid(game: Cubes):bool =
    if(game.red>red_cubes):
        return false
    if(game.blue>blue_cubes):
        return false
    if(game.green>green_cubes):
        return false
    return true

proc getCubesFromInput(cube_seq:seq[string]):Cubes = 
    var cube : Cubes
    for str in cube_seq:
        if("red" in str):
            cube.red = removeSurroundingSpacesAndGetANumber(str.replace("red",""))
            continue
        if("blue" in str):
            cube.blue = removeSurroundingSpacesAndGetANumber(str.replace("blue",""))
            continue
        if("green" in str):
            cube.green = removeSurroundingSpacesAndGetANumber(str.replace("green",""))
            continue
    cube.valid = cube_is_valid(cube)
    return cube

proc game_is_valid(game:Game):bool =
    for cube in game.content:
        if(not cube.valid):
            return false
    return true

proc parse(filename:string):seq[Game] =
    for line in iterate_file(filename):
        var game : Game
        let id_and_cubes = line.split(':')
        game.id = parseInt(id_and_cubes[0].split(' ')[1])
        let cubes_shown = id_and_cubes[1].split(';')
        for cubes in cubes_shown:
            game.content.add(getCubesFromInput(cubes.split(',')))
        result.add(game)
    return result

proc part01(filename:string):int =
    let whole_game = parse(filename)
    for game in whole_game:
        if(game_is_valid(game)):
            result = result + game.id
    return result

proc get_powerset_of_game(game:Game):int =
    var min_blue = 0
    var min_red = 0
    var min_green = 0
    for cubes in game.content:
        if(cubes.red>min_red):
            min_red=cubes.red
        if(cubes.blue>min_blue):
            min_blue=cubes.blue
        if(cubes.green>min_green):
            min_green=cubes.green
    return min_blue * min_red * min_green

proc part02(filename:string):int =
    let whole_game = parse(filename)
    for game in whole_game:
            result = result + get_powerset_of_game(game)
    return result
        
proc main() =
    doAssert(part01("inputs/example_1_day02.txt")==8)
    doAssert(part02("inputs/example_2_day02.txt")==2286)
    echo "Parte 1: " & $part01("inputs/day02.txt")
    echo "Parte 2: " & $part02("inputs/day02.txt")
when isMainModule:
  main()