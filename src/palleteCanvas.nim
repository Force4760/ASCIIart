import canvas
import illwill
import cells
import json
import os

#[var palleteList = ["!","\"","#","$","%","&","'","(",")","*",
"+",",","-",".","/","0","1","2","3","4","5","6","7","8","9",
":",";","<","=",">","?","@","A","B","C","D","E","F","G","H",
"I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W",
"X","Y","Z","[","\\","]","^","_","`","a","b","c","d","e","f",
"g","h","i","j","k","l","m","n","o","p","q","r","s","t","u",
"v","w","x","y","z","{","|","}","~","Ø","ø","×","ƒ","£","ª",
"º","¿","®","¬","¡","«","»","░","▒","▓","│","┤","©","╣","║",
"╗","╝","¢","¥","┐","└","┴","┬","├","─","┼","╚","╔","╩","╦",
"╠","═","╬","¤","ð","Ð","┘","┌","█","▄","¦","▀","ß","µ","þ",
"¯","´","≡","±","‗","¶","§","÷","°","¨","·","¹","²","³","⁴",
"⁵","⁶","⁷","⁸","⁹","⁰","■","‾"]
]#

proc loadPalleteList(): seq[string] =
  var palleteList = @[" "]
  let pathToConfig = expandTilde("~/.config/nimASCII/pallete.json")
  try:
    let toLoad = parseJson(readFile(pathToConfig))

    palleteList = @[]

    for character in toLoad["pallete"]:
      palleteList.add(character.getStr())

  except:
    palleteList = @["!","\"","#","$","%","&","'","(",")","*",
"+",",","-",".","/","0","1","2","3","4","5","6","7","8","9",
":",";","<","=",">","?","@","A","B","C","D","E","F","G","H",
"I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W",
"X","Y","Z","[","\\","]","^","_","`","a","b","c","d","e","f",
"g","h","i","j","k","l","m","n","o","p","q","r","s","t","u",
"v","w","x","y","z","{","|","}","~","Ø","ø","×","ƒ","£","ª",
"º","¿","®","¬","¡","«","»","░","▒","▓","│","┤","©","╣","║",
"╗","╝","¢","¥","┐","└","┴","┬","├","─","┼","╚","╔","╩","╦",
"╠","═","╬","¤","ð","Ð","┘","┌","█","▄","¦","▀","ß","µ","þ",
"¯","´","≡","±","‗","¶","§","÷","°","¨","·","¹","²","³","⁴",
"⁵","⁶","⁷","⁸","⁹","⁰","■","‾"]
  result = palleteList


proc makePallete*(size: int): Canvas =
  var pallete = Canvas(cursorX: 0, cursorY: 0, startX:0,startY:0,width:0,height:size, cells: @[])
  var row = 0
  var column = 0

  pallete.cells.add(@[])

  let palleteList = loadPalleteList()

  for ch in palleteList:
    pallete.cells[column].add(Cell(fgColor: fgWhite, bgColor: bgNone, character: ch))
    if row == size-1:
      pallete.cells.add(@[])
      inc(column)
      row = 0
    else:
      inc(row)
  pallete.width = column + 1
  let realLength = len(palleteList)
  let targetLength = pallete.height * pallete.width
  let lengthDiference = targetLength - realLength
  for _ in 0 ..< lengthDiference:
    pallete.cells[^1].add(Cell(bgColor: bgNone, fgColor: fgWhite, character: " "))
  result = pallete
