import illwill
import appState
import strutils
import command


# General cli Input function
proc input*(arguments: varargs[string, `$`]): string =
  for arg in arguments:
    stdout.write arg
  result = stdin.readLine()


# Int cli Input function
proc inputInt*(arguments: varargs[string, `$`]): int =
  var inp = 1
  while true:
    # make the user input something that
    # is possible to convert to int
    try:
      inp = parseInt(input(arguments))
      break
    except:
      continue
  result = inp

# Graphical input function
proc graphicInput*(tb: var TerminalBuffer, app: var AppState) =
  # coordinates to center the box on the screen
  let startX = int(terminalWidth()/20)
  let endX = terminalWidth() - startX
  let startY = int(terminalHeight() / 2) - 1
  let endY = startY + 2

  # draw the graphic input box
  tb.drawRect(startX, startY, endX, endY)

  # render the command
  tb.write(startX+1,startY+1, app.renderCommand())
