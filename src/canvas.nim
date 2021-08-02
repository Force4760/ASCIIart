import illwill
import appState
import cells
import json


# Canvas object where characters will be drawn
#   -> cursorX
#       -> x position of the cursor
#   -> cursorY
#       -> y position of the cursor
#   -> startX
#       -> x coordinate of the canvas' start position
#   -> startY
#       -> y coordinate of the canvas' start position
#   -> width
#       -> width of the canvas
#   -> height
#       -> height of the canvas
#   -> cells
#       -> sequence of cells
type Canvas* = object
  cursorX*: int
  cursorY*: int
  startX*: int
  startY*: int
  width*: int
  height*: int
  cells*: seq[seq[Cell]]


# Generate a new default canvas with a certain width and height
proc makeCanvas*(width: int, height: int): Canvas =
  var canvas = Canvas(cursorX: 0, cursorY: 0, startX:0,startY:0,width:width,height:height, cells: @[])

  # add the necessary number of cells
  for i in 0..<width:
    canvas.cells.add(@[])
    for j in 0..<height:
      canvas.cells[i].add(makeCell())

  result = canvas


# Draw canvas border
proc drawBorder*(c: var Canvas, tb: var TerminalBuffer, x: int, y: int, spacing:int) =
  # set color
  tb.setForegroundColor(fgWhite, true)

  # X and Y positions
  # based on the width and height of the canvas
  # the starting positions of the canvas
  # the spacing to render the canvas
  let finalX = c.width*spacing+x+1 - c.startX*spacing
  let finalY = c.height*spacing+y+1 - c.startY*spacing

  # draw at x,y position
  tb.drawRect(x, y, finalX, finalY)


# write cell number so that it is easier to know in what cell you are in
proc drawCoordinates*(c: var Canvas, tb: var TerminalBuffer, maxX: int, y: int) =
  let coordinates = "x: " & $c.cursorX & "  |  y: " & $c.cursorY
  let x = maxX - len(coordinates)
  tb.write(x, y, coordinates)


# Draw canvas at X,Y position with a certain spacing
proc draw*(c: var Canvas, tb: var TerminalBuffer, x: int, y: int, spacing:int) =
  let cells = c.cells
  let sX = c.startX
  let sY = c.startY

  c.drawBorder(tb, x, y, spacing)

  # draw each cell
  for i in 0..<len(cells)-sX:
    for j in 0..<len(cells[i])-sY:
      # special case where the cell is selected
      if i == c.cursorX-sX and j == c.cursorY-sY:
        cells[i+sX][j+sY].drawSelectedCell(tb, x+1+i*spacing, y+1+j*spacing)
      else:
        cells[i+sX][j+sY].drawCell(tb, x+1+i*spacing, y+1+j*spacing)


# Move the cell cursor
proc moveCursor*(c: var Canvas, changeX: int, changeY: int) =
  let newX = c.cursorX + changeX
  let newY = c.cursorY + changeY

  # set the new cursor in the x direction
  if newX >= 0 and newX < c.width:
    c.cursorX = newX
  elif newX < 0:
    c.cursorX = 0
  else:
    c.cursorX = c.width - 1

  # set the new cursor in the y direction
  if newY >= 0 and newY < c.height:
    c.cursorY = newY
  elif newY < 0:
    c.cursorY = 0
  else:
    c.cursorY = c.height - 1


# Move the canvas
proc moveCanvas*(c: var Canvas, changeX: int, changeY: int) =
  let newX = c.startX + changeX
  let newY = c.startY + changeY

  # set the new start in the x direction
  if newX >= 0 and newX < c.width:
    c.startX = newX

  # set the new start in the y direction
  if newY >= 0 and newY < c.height:
    c.startY = newY


# get the current cell character
proc getCell*(c: var Canvas): string =
  try:
    result = c.cells[c.cursorX][c.cursorY].character
  except:
    result = " "


# set a certain cell
proc setCell*(c: var Cell, app: var AppState) =
  try:
    # update the cell based on the app state selected values
    c = app.makeCellFromState()
  except:
    # make a default cell on error
    c = makeCell()


# set the current cell
proc setCell*(c: var Canvas, app: var AppState) =
  try:
    # update the cell based on the app state selected values
    c.cells[c.cursorX][c.cursorY] = app.makeCellFromState()
  except:
    # make a default cell on error
    c.cells[c.cursorX][c.cursorY] = makeCell()


# set the character os the current cell
proc setCellChar*(c: var Canvas, app: var AppState, character: string) =
  # set the current cell from state
  c.setCell(app)
  # set the current cell character
  c.cells[c.cursorX][c.cursorY].character = character


# set the character of a certain cell
proc setCellChar*(c: var Cell, app: var AppState, character: string) =
  # set the cell from state
  c.setCell(app)
  # set the cell character
  c.character = character


# set the character of the current cell
proc setCell*(c: var Canvas, character: string) =
  c.cells[c.cursorX][c.cursorY].character = character


# reset the selected cell
proc resetCell*(c: var Canvas) =
  c.cells[c.cursorX][c.cursorY] = makeCell()


proc makeFromJson*(name: string): Canvas =
  let toLoad = parseJson(readFile(name & ".json"))

  var canvas = Canvas(
    cursorX: 0,
    cursorY: 0,
    startX:0,
    startY:0,
    width: toLoad["width"].getInt(),
    height: toLoad["height"].getInt(),
    cells: @[])

  # add the necessary number of cells
  for i in 0 ..< len(toLoad["cells"]):
    canvas.cells.add(@[])

    for j in 0 ..< len(toLoad["cells"][i]):
      let f = toLoad["cells"][i][j]["fgColor"].getStr()
      let b = toLoad["cells"][i][j]["bgColor"].getStr()
      let c = toLoad["cells"][i][j]["character"].getStr()

      canvas.cells[i].add(cellFromStrings(c, b, f))

  result = canvas
