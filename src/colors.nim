import illwill



# TermColors object
#   -> cursor
#       -> cursor position on the color list
#   -> length
#       -> length of the color list
#   -> title
#       -> title of the object
#   -> active
#       -> if this object is active or not
type TermColors* = ref object of RootObj
  cursor*: int
  length*: int
  title*: string
  active*: bool


# BgColors that inherits from TermColors
#   -> colors
#     -> sequence of BackgroundColors
type BgColors* = ref object of TermColors
  colors*: seq[BackgroundColor]


# FgColors that inherits from TermColors
#   -> colors
#     -> sequence of ForegroundColors
type FgColors* = ref object of TermColors
  colors*: seq[ForegroundColor]


# object that holds foreground colors
var fg* = FgColors(
    colors: @[fgNone, fgBlack, fgRed, fgGreen, fgYellow, fgBlue, fgMagenta, fgCyan, fgWhite],
    cursor: 0,
    length: 9,
    title: "Foreground",
    active: true
  )

# object that holds background colors
var bg* = BgColors(
    colors: @[bgNone, bgBlack, bgRed, bgGreen, bgYellow, bgBlue, bgMagenta, bgCyan, bgWhite],
    cursor: 0,
    length: 9,
    title: "Background",
    active: false
  )


# Move the cursor of a TermColors object
proc moveColorCursor*(c: var TermColors, delta: int)=
  var newCursor = c.cursor + delta

  # if can't be neither negative nor larger than the length
  if newCursor >= 0 and newCursor < c.length:
    c.cursor = newCursor


# Draw the selection arrow at the determined position
proc drawSelectionArrow(tb: var TerminalBuffer, x: int, y:int, isActive: bool) =
  # if active the arrow is white
  if isActive:
    tb.write(x, y, fgWhite, "▶")
  # if not active the arrow is black
  else:
    tb.write(x, y, fgBlack, "▶")


# Draw BG and FG color lists at a certain position
proc drawColor*(c: var FgColors, tb: var TerminalBuffer,x:int,y:int) =
  var yPos = y

  tb.setBackgroundColor(bgNone)

  tb.drawSelectionArrow(x, yPos + c.cursor*2, c.active)

  # draw each color element with it's foreground color
  for i in 0 ..< c.length:
    tb.setForegroundColor(c.colors[i])
    tb.write(x+2,yPos, $c.colors[i])
    yPos += 2

proc drawColor*(c: var BgColors, tb: var TerminalBuffer,x:int,y:int) =
  var yPos = y

  tb.drawSelectionArrow(x, yPos + c.cursor*2, c.active)

  tb.setForegroundColor(fgBlack)

  # draw each color element with it's background color
  for i in 0 ..< c.length:
    tb.setBackgroundColor(c.colors[i])
    tb.write(x+2,yPos, $c.colors[i])
    yPos += 2


# get the current ForegroundColor from the fg object
proc getFG*(): ForegroundColor =
  result = fg.colors[fg.cursor]


# get the current BackgroundColor from the bg object
proc getBG*(): BackgroundColor =
  result = bg.colors[bg.cursor]
