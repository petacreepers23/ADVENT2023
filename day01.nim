import strutils
import unicode

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
    for line in open(filename).lines:
        result = result + getCurrentNumber(line)

proc part02(filename:string):int =
    for line in open(filename).lines:
        #envuelvo la conversión en numero-digito-numero para 
        #no obfuscar otros numeros que se compongan de el que estoy sustituyendo, ejemplo eightwo
        result = result + getCurrentNumber(
            line.replace("one","one1one")
                .replace("two","two2two")
                .replace("three","three3three")
                .replace("four","four4four")
                .replace("five","five5five")
                .replace("six","six6six")
                .replace("seven","seven7seven")
                .replace("eight","eight8eight")
                .replace("nine","nine9nine")
            )

proc main() =
    doAssert(part01("inputs/example_1_day01.txt")==142)
    doAssert(part02("inputs/example_2_day01.txt")==281)
    echo "Parte 1: " & $part01("inputs/day01.txt")
    echo "Parte 2: " & $part02("inputs/day01.txt")
when isMainModule:
  main()