import illwill
import canvas
import appState

# covert a number key word to an int
proc wordToNum*(key: Key): int =
  case key
    of Key.One: result = 1
    of Key.Two: result = 2
    of Key.Three: result = 3
    of Key.Four: result = 4
    of Key.Five: result = 5
    of Key.Six: result = 6
    of Key.Seven: result = 7
    of Key.Eight: result = 8
    of Key.Nine: result = 9
    else: result = 0


# switch the value of two integer variables
proc switchInt(x: var int, y: var int) =
  let tmp = y
  y = x
  x = tmp


# make a negative int become 0
proc removeNegativeInt(x: var int) =
  if x < 0:
    x = 0


# make an int become a provided maximum if it is larger than it
proc upToMaxInt(x: var int, maximum: int) =
  if x > maximum:
    x = maximum


# combine removeNegativeInt and upToMaxInt
proc processInt(x: var int, maximum: int) =
  removeNegativeInt(x)
  upToMaxInt(x, maximum)


# function that draws an horizontal line
# to the canvas
proc horizontalLineDraw*(c: var Canvas, app: var AppState, line: var int, startL: var int, endL: var int) =
  # process inputs
  processInt(line, c.width - 1)
  processInt(startL, c.height - 1)
  processInt(endL, c.height - 1)

  # if the start position is larger
  # than the end position switch them
  if startL > endL:
    switchInt(startL,endL)

  # line drawing at the provided line
  for i in startL..endL:
    c.cells[i][line].setCell(app)


# function that draws a vertical line
# to the canvas
proc vertLineDraw*(c: var Canvas, app: var AppState, line: var int, startL: var int, endL: var int) =
  # process inputs
  processInt(line, c.height - 1)
  processInt(startL, c.width - 1)
  processInt(endL, c.width - 1)

  # if the start position is larger
  # than the end position switch them
  if startL > endL:
    switchInt(startL,endL)

  # line drawing at the provided line
  for i in startL..endL:
    c.cells[line][i].setCell(app)


# function that draws a filled rectangle
# to the canvas
proc fillDraw*(c: var Canvas, app: var AppState, x1, y1, x2, y2: var int) =
  # process inputs
  processInt(x1, c.width - 1)
  processInt(x2, c.width - 1)
  processInt(y1, c.height - 1)
  processInt(y2, c.height - 1)

  # if the start positions are larger
  # than the end positions switch them
  if x1 > x2:
    switchInt(x1,x2)
  if y1 > y2:
    switchInt(y1,y2)

  # fill every cell in the rectangle
  # based on the current app state
  for i in x1..x2:
    for j in y1..y2:
      c.cells[i][j].setCell(app)


# function that draws a single bordered rectangle
# to the canvas
proc singleRectDraw*(c: var Canvas, app: var AppState, x1, y1, x2, y2: var int) =
  # process inputs
  processInt(x1, c.width - 1)
  processInt(x2, c.width - 1)
  processInt(y1, c.height - 1)
  processInt(y2, c.height - 1)

  # if the start positions are larger
  # than the end positions switch them
  if x1 > x2:
    switchInt(x1,x2)
  if y1 > y2:
    switchInt(y1,y2)

  # draw the horizontal borders of the rectangle
  # at the y1 and y2 rows
  for i in (x1 + 1) ..< x2:
    c.cells[i][y1].setCellChar(app, "─")
    c.cells[i][y2].setCellChar(app, "─")

  # draw the vertical borders of the rectangle
  # at the x1 and x2 columns
  for i in (y1 + 1) ..< y2:
    c.cells[x1][i].setCellChar(app, "│")
    c.cells[x2][i].setCellChar(app, "│")

  # draw the corners of the rectangle
  c.cells[x2][y1].setCellChar(app, "┐") # top right
  c.cells[x2][y2].setCellChar(app, "┘") # bottom right
  c.cells[x1][y1].setCellChar(app, "┌") # top left
  c.cells[x1][y2].setCellChar(app, "└") # bottom left


# function that draws a double bordered rectangle
# to the canvas
proc doubleRectDraw*(c: var Canvas, app: var AppState, x1, y1, x2, y2: var int) =
  # process inputs
  processInt(x1, c.width - 1)
  processInt(x2, c.width - 1)
  processInt(y1, c.height - 1)
  processInt(y2, c.height - 1)

  # if the start positions are larger
  # than the end positions switch them
  if x1 > x2:
    switchInt(x1,x2)
  if y1 > y2:
    switchInt(y1,y2)

  # draw the vertical borders of the rectangle
  # at the x1 and x2 columns
  for i in (x1 + 1) ..< x2:
    c.cells[i][y1].setCellChar(app, "═")
    c.cells[i][y2].setCellChar(app, "═")

  # draw the vertical borders of the rectangle
  # at the x1 and x2 columns
  for i in (y1 + 1) ..< y2:
    c.cells[x1][i].setCellChar(app, "║")
    c.cells[x2][i].setCellChar(app, "║")

  # draw the corners of the rectangle
  c.cells[x2][y1].setCellChar(app, "╗") # top right
  c.cells[x2][y2].setCellChar(app, "╝") # bottom right
  c.cells[x1][y1].setCellChar(app, "╔") # top left
  c.cells[x1][y2].setCellChar(app, "╚") # bottom left



# function that draws a rectangle
# to the canvas
proc rectDraw*(c: var Canvas, app: var AppState, x1, y1, x2, y2: var int) =
  # process inputs
  processInt(x1, c.width - 1)
  processInt(x2, c.width - 1)
  processInt(y1, c.height - 1)
  processInt(y2, c.height - 1)

  # if the start positions are larger
  # than the end positions switch them
  if x1 > x2:
    switchInt(x1,x2)
  if y1 > y2:
    switchInt(y1,y2)


  # based on the current app state
  # draw the vertical borders of the rectangle
  # at the x1 and x2 columns
  for i in x1 .. x2:
    c.cells[i][y1].setCell(app)
    c.cells[i][y2].setCell(app)

  # based on the current app state
  # draw the vertical borders of the rectangle
  # at the x1 and x2 columns
  for i in y1 .. y2:
    c.cells[x1][i].setCell(app)
    c.cells[x2][i].setCell(app)
