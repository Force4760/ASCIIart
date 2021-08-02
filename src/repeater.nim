import strutils
import illwill
import canvas
import functions



# Repeater type
# works by repeating certain functions
# X number of times
type Repeater* = object
  timesR*: string # times to repeat


# Create a new Repeater Object
proc newRepeater*(): Repeater =
  result = Repeater(timesR: "")


# Add a number to the repeater
# Maximum number of numbers is 3
proc addToRepeater*(r: var Repeater, toAdd: string) =
  if len(r.timesR) < 3:
    r.timesR = r.timesR & toAdd

proc addToRepeater*(r: var Repeater, key: Key) =
  if len(r.timesR) < 3:
    r.timesR = r.timesR & $wordToNum(key)


# Remove the last number from a repeater
proc remFromRepeater*(r: var Repeater) =
  # check if timesR has at least one number
  if len(r.timesR) > 0:
    r.timesR = r.timesR[0..^2]


# Clear the repeater
# (it will repeat 0 times if called)
proc clearRepeater*(r: var Repeater) =
  r.timesR = ""


# convert timesR from a string to an int
proc timesToRepeat*(rep: var Repeater):int =
  var times: int
  try:
    times = parseInt(rep.timesR)
  except:
    times = 1
  result = times


# Draw and show to the user the repeater box
# it will show a divider
proc drawRepeaterBox(tb: var TerminalBuffer, y: int, width: int, height: int) =
  # set colors
  tb.setBackgroundColor(bgNone)
  tb.setForegroundColor(fgBlue)

  # draw divider
  tb.fill(0,y, terminalWidth(), terminalHeight(), "‾")
  # clear screen after the divider
  tb.fill(0,y+1, terminalWidth(), terminalHeight(), " ")


# Draw and show to the user the repeater
# (box and repeater number)
proc drawRepeater*(rep: var Repeater, tb: var TerminalBuffer,x: int, y: int) =
  # repeater number
  let toWrite = rep.timesR

  # draw to the screen
  tb.drawRepeaterBox(y,6,2)
  tb.write(x ,y+1, bgNone, fgBlue, toWrite)


# Move the cursor repeatedly
proc repeatMoveCursor*(rep: var Repeater, c: var Canvas, x: int, y: int) =
  let times = rep.timesToRepeat()

  # move the cursor x times
  for _ in 0 ..< times:
    c.moveCursor(x,y)

  rep.clearRepeater()


# Move the canvas repeatedly
proc repeatMoveCanvas*(rep: var Repeater, c: var Canvas, x: int, y: int) =
  var times = rep.timesToRepeat()

  # move the canvas x times
  for _ in 0..<times:
    c.moveCanvas(x,y)

  rep.clearRepeater()
