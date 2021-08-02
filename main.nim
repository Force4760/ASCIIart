import illwill
import os
import src/canvas
import src/palleteCanvas
import src/repeater
import src/processer
import src/appState
import src/colors
import src/input
import argparse

var p = newParser:
  flag("--load", help="Load a previously made template/project (json file)")
  flag("--show", help="Show a .ans file (uses less)")
  arg("names", nargs = -1)


proc run(canvas: var Canvas) =
  illwillInit(fullscreen=true)
  setControlCHook(exitProc)
  hideCursor()

  var rep = newRepeater()
  var palleteC = makePallete(10)
  var appState = newAppState()

  while true:
    var tb = newTerminalBuffer(terminalWidth(), terminalHeight())

    processInput(appState, canvas, palleteC, rep)

    case appState.screen:
      of "pallete":
        palleteC.draw(tb,3,1,2)
      of "color":
        fg.drawColor(tb,3,1)
        bg.drawColor(tb,23,1)
      of "input":
        tb.graphicInput(appState)
      else:
        canvas.draw(tb, 3,1,1)

    rep.drawRepeater(tb, 1, terminalHeight() - 2)

    canvas.drawCoordinates(tb, terminalWidth() - 1, terminalHeight() - 1)

    tb.display()
    sleep(20)



proc create() =
  let width = inputInt("Width: ")
  let height = inputInt("Height: ")
  var canvas = makeCanvas(width, height)
  canvas.run()

proc loaded(name: string) =
  var canvas: Canvas
  var isToRun = true

  try:
    canvas = makeFromJson(name)
  except:
    isToRun = false
    echo("\u001b[31mAn error occurred loading the file\u001b[0m")

  if isToRun:
    canvas.run()




proc main() =
  var opts = p.parse(commandLineParams())

  if opts.load == true:
    if opts.names != @[]:
      loaded(opts.names[0])
    else:
      echo("\u001b[31mPlease provide a file name\u001b[0m")


  elif opts.show == true:
    if opts.names != @[]:
      discard execShellCmd("less " & opts.names[0] & ".ans")
    else:
      echo("\u001b[31mPlease provide a file name\u001b[0m")

  else:
    create()


main()
