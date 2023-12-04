import strutils

const red_cubes = 12
const green_cubes = 13
const blue_cubes = 14

type Cube* = object
    valid*:bool
    red*: int
    green*: int
    blue*: int

type Game* = object
    id*: int
    content*: seq[Cube]

proc getCubesFromInput(cube_seq:seq[string]):Cube = 
    for str in cube_seq:
        if("red" in str):
            result.red = str.replace("red","").strip.parseInt
            continue
        if("blue" in str):
            result.blue = str.replace("blue","").strip.parseInt
            continue
        if("green" in str):
            result.green = str.replace("green","").strip.parseInt
            continue
    result.valid = result.green <= green_cubes and 
                 result.blue <= blue_cubes and
                 result.red <= red_cubes

proc game_is_valid(game:Game):bool =
    for cube in game.content:
        if(not cube.valid):
            return false
    return true

proc parse(filename:string):seq[Game] =
    for line in open(filename).lines:
        var game : Game
        let id_and_cubes = line.split(':')
        game.id = parseInt(id_and_cubes[0].split(' ')[1])
        let cubes_shown = id_and_cubes[1].split(';')
        for cubes in cubes_shown:
            game.content.add(getCubesFromInput(cubes.split(',')))
        result.add(game)

proc part01(filename:string):int =
    let whole_game = parse(filename)
    for game in whole_game:
        if(game_is_valid(game)):
            result = result + game.id

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
        
proc main() =
    doAssert(part01("inputs/example_1_day02.txt")==8)
    doAssert(part02("inputs/example_2_day02.txt")==2286)
    echo "Parte 1: " & $part01("inputs/day02.txt")
    echo "Parte 2: " & $part02("inputs/day02.txt")
when isMainModule:
  main()