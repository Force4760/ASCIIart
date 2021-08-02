import canvas
import cells
import json
import appState
import illwill



const finalizeEscape = "\u001b0"
const escape = "\u001b"

proc exportJson*(c: var Canvas, name: string, app:var AppState) =
  var jsonObject = %* {
    "width": c.width,
    "height": c.height,
    "cells": c.cells
  }
  try:
    writeFile(name & ".json", $jsonObject)
  except:
    app.appError()



proc bgToAnsi(bgC: BackgroundColor): int =
  case bgC:
    of bgBlack:
      result = 40
    of bgRed:
      result = 41
    of bgGreen:
      result = 42
    of bgYellow:
      result = 43
    of bgBlue:
      result = 44
    of bgMagenta:
      result = 45
    of bgCyan:
      result = 46
    of bgWhite:
      result = 47
    else:
      result = 0

proc bgToAnsi(fgC: ForegroundColor): int =
  case fgC:
    of fgBlack:
      result = 30
    of fgRed:
      result = 31
    of fgGreen:
      result = 32
    of fgYellow:
      result = 33
    of fgBlue:
      result = 34
    of fgMagenta:
      result = 35
    of fgCyan:
      result = 36
    of fgWhite:
      result = 37
    else:
      result = 0

proc escapeChar(first: int, last: int): string =
  return "[" & $first & ";" & $last & "m"


proc cellToAnsi(c: Cell): string =
  let bgInt = bgToAnsi(c.bgColor)
  let fgInt = bgToAnsi(c.fgColor)
  let ch = c.character

  var ans = escape

  if bgInt > fgInt:
    ans &= escapeChar(fgInt, bgInt)
  else:
    ans &= escapeChar(bgInt, fgInt)

  ans &= ch

  result = ans



proc exportAnsi*(c: var Canvas, name: string, app:var AppState) =
  var ans = ""
  let cells = c.cells

  # draw each cell
  for i in 0..<len(cells):
    for j in 0..<len(cells[i]):
      ans &= cells[j][i].cellToAnsi()

    ans &= "\n"

  ans &= finalizeEscape

  try:
    writeFile(name & ".ans", ans)
  except:
    app.appError()

