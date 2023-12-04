import strutils
import unicode

iterator iterate_file(filename : string) : string =
    let f = open(filename)
    defer:
      f.close()
    var line : string
    while f.read_line(line):
      yield line

proc getCurrentNumber(line:string):int =
    for letter in line:
        if(isDigit(letter)):
            result = parseInt($letter) * 10
            break
    for letter in reversed(line):
        if(isDigit(letter)):
            result = result + parseInt($letter)
            break

proc part01(filename:string):int =
    for line in iterate_file(filename):
        result = result + getCurrentNumber(line)
    return result

proc part02(filename:string):int =
    var line : string
    for ct_line in iterate_file(filename):
        #envuelvo la conversión en numero-digito-numero para 
        #no obfuscar otros numeros que se compongan de el que estoy sustituyendo, ejemplo eightwo
        line = ct_line.replace("one","one1one")
        line = line.replace("two","two2two")
        line = line.replace("three","three3three")
        line = line.replace("four","four4four")
        line = line.replace("five","five5five")
        line = line.replace("six","six6six")
        line = line.replace("seven","seven7seven")
        line = line.replace("eight","eight8eight")
        line = line.replace("nine","nine9nine")
        result = result + getCurrentNumber(line)
    return result


proc main() =
    doAssert(part01("inputs/example_1_day01.txt")==142)
    doAssert(part02("inputs/example_2_day01.txt")==281)
    echo "Parte 1: " & $part01("inputs/day01.txt")
    echo "Parte 2: " & $part02("inputs/day01.txt")
when isMainModule:
  main()