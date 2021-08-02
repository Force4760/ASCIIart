import illwill
import appState



# Cell object
#   -> fgColor
#       -> Foreground Color of the cell
#   -> bgColor
#       -> Background Color of the cell
#   -> character
type Cell* = object
  fgColor*: ForegroundColor
  bgColor*: BackgroundColor
  character*: string


# Generate a default cell
proc makeCell*(): Cell =
  var c = Cell(fgColor: fgWhite, bgColor: bgNone, character: " ")
  result = c


# Generate a cell based on the state of the app
proc makeCellFromState*(app: var AppState): Cell =
  var c = Cell(
    fgColor: app.selectedFgColor,
    bgColor: app.selectedBgColor,
    character: app.selectedCharacter)
  result = c


# Draw the cell at the x,y position
proc drawCell*(cell: Cell, tb: var TerminalBuffer, x: int, y: int) =
  tb.write(x,y, cell.bgColor,cell.fgColor, cell.character)


# Draw the selected cell at the x,y position
proc drawSelectedCell*(cell: Cell, tb: var TerminalBuffer, x: int, y: int) =
  # selected cells have a red background
  # so that it stands out
  # but if the bgColor of the cell is already red
  # it will be displayed blue instead of red
  if cell.bgColor == bgRed:
    tb.write(x,y, bgBlue,cell.fgColor, cell.character)
  else:
    tb.write(x,y, bgRed,cell.fgColor, cell.character)



proc cellFromStrings*(character: string, bgC: string, fgC: string): Cell =
  var background: BackgroundColor
  case bgC:
    of "bgBlack":
      background = bgBlack
    of "bgRed":
      background = bgRed
    of "bgGreen":
      background = bgGreen
    of "bgYellow":
      background = bgYellow
    of "bgBlue":
      background = bgBlue
    of "bgMagenta":
      background = bgMagenta
    of "bgCyan":
      background = bgCyan
    of "bgWhite":
      background = bgWhite
    else:
      background = bgNone

  var foreground: ForegroundColor
  case fgC:
    of "fgBlack":
      foreground = fgBlack
    of "fgRed":
      foreground = fgRed
    of "fgGreen":
      foreground = fgGreen
    of "fgYellow":
      foreground = fgYellow
    of "fgBlue":
      foreground = fgBlue
    of "fgMagenta":
      foreground = fgMagenta
    of "fgCyan":
      foreground = fgCyan
    of "fgWhite":
      foreground = fgWhite
    else:
      foreground = fgNone

  result = Cell(fgColor: foreground, bgColor: background, character: character)




