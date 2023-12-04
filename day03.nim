import strutils
import unicode

template join(a,b:seq[untyped]) =
    for elem in b:
        a.add(elem)

type PartNumber* = object
    number*:int
    length*: int
    line*: int
    position*: int
type Symbol* = object
    symbol*:char
    line*: int
    position*: int

proc getPartNumbers(line:string,linenum:int): seq[PartNumber] = 
    var num: string = ""
    var i: int = 0
    for letra in line:
        if(isDigit(letra)):
            num.add(letra)
            if(i==line.len-1):
                let aux = PartNumber(
                    number: parseInt(num),
                    length: num.len,
                    line: linenum,
                    position: i-num.len)
                result.add(aux)
        elif(num != ""):
            let aux = PartNumber(
                number: parseInt(num),
                length: num.len,
                line: linenum,
                position: i-num.len)
            result.add(aux)
            num = ""
        i = i + 1

proc getSymbols(line:string,linenum:int): seq[Symbol] =
    var i:int = 0
    for letra in line:
        if(not isDigit(letra) and letra != '.'):
            let aux = Symbol(
                symbol: letra,
                line: linenum,
                position: i)
            result.add(aux)
        i = i + 1

proc hasPartAround(symbol:Symbol,part:PartNumber):bool =
    #top right
    if((symbol.line-1 == part.line) and (symbol.position+1==part.position)):
        return true
    #top
    if((symbol.line-1 == part.line) and (symbol.position>=part.position and symbol.position<=part.position+part.length)):
        return true
    #top left
    if((symbol.line-1 == part.line) and (symbol.position==part.position+part.length)):
        return true
    #left
    if((symbol.line == part.line) and (symbol.position==part.position+part.length)):
        return true
    #right
    if((symbol.line == part.line) and (symbol.position+1==part.position)):
        return true
    #bottom right
    if((symbol.line+1 == part.line) and (symbol.position+1==part.position)):
        return true
    #bottom
    if((symbol.line+1 == part.line) and (symbol.position>=part.position and symbol.position<=part.position+part.length)):
        return true
    #bottom left
    if((symbol.line+1 == part.line) and (symbol.position==part.position+part.length)):
        return true
    return false

proc isAroundAnySymbol(part:PartNumber,symbols:seq[Symbol]):bool =
    for symbol in symbols:
        if(hasPartAround(symbol,part)):
            return true
    return false

proc filterInvalidPartNumbers(parts:seq[PartNumber],symbols:seq[Symbol]):seq[PartNumber] =
    for part in parts:
        if isAroundAnySymbol(part,symbols):
            result.add(part)

proc getPartsAndSymbols(filename:string):(seq[PartNumber],seq[Symbol]) =
    var partNumberArray: seq[PartNumber]
    var symbolsNumberArray: seq[Symbol]
    var i:int = 0
    for line in open(filename).lines:
        partNumberArray.join(getPartNumbers(line,i))
        symbolsNumberArray.join(getSymbols(line,i))
        i = i + 1
    (filterInvalidPartNumbers(partNumberArray,symbolsNumberArray),symbolsNumberArray)

proc part01(filename:string):int =
    let (goodParts,_) = getPartsAndSymbols(filename)
    for part in goodParts:
        result = result + part.number

proc getGearRatio(symbol:Symbol,parts:seq[PartNumber]):int =
    var numberOfParts=0
    result=1
    for part in parts:
        if(hasPartAround(symbol,part)):
            #echo part
            numberOfParts = numberOfParts + 1
            result = result * part.number
    if(numberOfParts!=2):
        return 0
    return result

proc part02(filename:string):int =
    let (goodParts,symbolsNumberArray) = getPartsAndSymbols(filename)
    for symbol in symbolsNumberArray:
        if(symbol.symbol=='*'):
            result = result + getGearRatio(symbol,goodParts)

proc main() =
    doAssert(part01("inputs/example_1_day03.txt")==4361)
    doAssert(part01("inputs/example_mine_1_day03.txt")==33371)
    doAssert(part02("inputs/example_1_day03.txt")==467835)
    echo "Parte 1: " & $part01("inputs/day03.txt")
    echo "Parte 2: " & $part02("inputs/day03.txt")
when isMainModule:
  main()