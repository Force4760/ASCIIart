import nre
import functions
import canvas
import appState
import strutils
import saveJson



proc processRects(ca: var Canvas, app: var AppState, matches: Captures) =
  # version of the rect function
  let version = matches[0]

  # process and parse arguments
  var
    x1 = parseInt(matches[2])
    y1 = parseInt(matches[3])
    x2 = parseInt(matches[4])
    y2 = parseInt(matches[5])

  case version:
    of "d":
      # draw double rect
      ca.doubleRectDraw(app, x1, y1, x2, y2)

    of "s":
      # draw single rect
      ca.singleRectDraw(app, x1, y1, x2, y2)

    of "f":
      # draw filled rect
      ca.fillDraw(app, x1, y1, x2, y2)

    else:
      # default
      # draw  rect
      ca.rectDraw(app, x1, y1, x2, y2)



# process and draw line on the canvas
proc processLines(ca: var Canvas, app: var AppState, matches: Captures) =
  # version of the line function
  let version = matches[0]

  # process and parse arguments
  var
    line = parseInt(matches[2])
    startL = parseInt(matches[3])
    endL = parseInt(matches[4])

  case version:
    of "v":
      # draw vertical line
      ca.vertLineDraw(app, line, startL, endL)

    else:
      # (default)
      # draw horizontal line
      ca.horizontalLineDraw(app, line, startL, endL)


# Process the Save and Export functions
proc saveExporteProcessor(ca: var Canvas, matches: Captures, app: var AppState) =
  let function = matches[0]

  case function:
    # export project to ansi
    of "export", "e":
      ca.exportAnsi(matches[1], app)

    # save project as json
    of "save", "s":
      ca.exportJson(matches[1], app)

    else:
      discard


# Process the Rect and Line functions
proc functionsProcessor(ca: var Canvas, matches: Captures, app: var AppState) =
  let function = matches[1]

  case function:
    # line drawing
    of "line":
      ca.processLines(app, matches)

    # rectangle drawing
    of "rect":
      ca.processRects(app, matches)

    else:
      discard





# process and execute the input command as a function
proc processInputRegex*(ca: var Canvas, app: var AppState, command: string) =
  # regular expression for processing
  # the input provided by the user
  # with the intent of using it to call
  # functions on the canvas
  let regex = re"(d|s|f|v|h|\w*)(line|rect)\((\d+)+\s*,\s*(\d+)+\s*,\s*(\d+)+\s*,*\s*(\d+)*\)"
  let regexLoader = re"""(save|s|load|l|export|e)\("*(\w+)"*\)"""

  var commandType = "function"

  # match the regular expression to the command
  # matches is an array
  #
  # matches[0] --> version:
  #     d -> double
  #     s -> single
  #     f -> fill
  #     v -> vertical
  #     h -> horizontal
  # matches[1] --> function type:
  #     line -> line function (v or h) (h is the default)
  # rect -> rectangle function (d, s or f) (f is the default)
  #
  # the rest of the matches are the values
  # that provide coordinates to draw the constructs

  var matches: Captures

  # functions matcher
  try:
    matches = command.toLowerAscii.match(regex).get.captures
  # save, export matcher
  except:
    matches = command.toLowerAscii.match(regexLoader).get.captures
    commandType = "SaveLoad"

  if commandType == "function":
    ca.functionsProcessor(matches, app)
  else:
    ca.saveExporteProcessor(matches, app)
