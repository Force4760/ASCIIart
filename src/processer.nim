import illwill
import canvas
import repeater
import appState
import colors
import functions
import regex
import command


# function to quit the illwill app
# illwill boilerplate
proc exitProc*() {.noconv.} =
  illwillDeinit()
  showCursor()
  quit(0)


# change the current screen
proc changeScreen(app: var AppState, toChange: string) =
  case app.screen:
  of "canvas":
    app.screen = toChange
  else:
    app.screen = "canvas"


# Enter key processor
proc processEnter(app: var AppState, c: var Canvas) =
  case app.screen:
    of "canvas":
      # set current cell based on the app state
      c.setCell(app)

    of "pallete":
      # set the selected character to the sellected pallete cell value
      app.selectedCharacter = c.getCell()
      # change screen to canvas
      app.screen = "canvas"


# Enter key processor for the input screen
proc processInputEnter(app: var AppState, c: var Canvas) =
  try:
    # process and execute command
    c.processInputRegex(app, app.command)

    # reset command
    #app.setCommand("")

    app.changeScreen("input")

  except:
    # display an error message on any error
    app.setCommand(errorString)


# processor for the delete key
proc processDel(app: var AppState, c: var Canvas) =
  case app.screen:
    of "canvas":
      # clear current cell
      c.resetCell()

    else:
      app.screen = "canvas"


# backspace processor for the input screen
proc processInputBackspace(app: var AppState) =
  if app.command == errorString:
    app.setCommand("")
  elif len(app.command) > 0:
    app.commandBackspace()


# Change the active color chooser
proc changeColor*(app: var AppState) =
  # set to background
  if app.activeColorChooser == fg:
    app.activeColorChooser = bg
    bg.active = true
    fg.active = false

  # set to foreground
  else:
    app.activeColorChooser = fg
    bg.active = false
    fg.active = true


# Key processor for the color screen
proc processKeyColor(key: var Key, app: var AppState) =
  case key
    of Key.Escape:
      # quit
      exitProc()

    # change active color chooser
    # (vim like key bindings)
    of Key.Left, Key.H, Key.Right, Key.L:
      app.changeColor()

    # change cursor and color
    # (vim like key bindings)
    of Key.Up, Key.K:
      app.activeColorChooser.moveColorCursor(-1)
    of Key.Down, Key.J:
      app.activeColorChooser.moveColorCursor(1)

    # change screens
    # set background
    # set foreground
    of Key.P:
      app.changeScreen("pallete")
      app.selectedBgColor = getBG()
      app.selectedFgColor = getFG()
    of Key.C:
      app.changeScreen("color")
      app.selectedBgColor = getBG()
      app.selectedFgColor = getFG()
    of Key.Delete, Key.Backspace, Key.D, Key.Enter, Key.Space:
      app.changeScreen("canvas")
      app.selectedBgColor = getBG()
      app.selectedFgColor = getFG()

    else:
      discard


# Key processor for the Input screen
proc processKeyInput(key: var Key, c: var Canvas, app: var AppState) =
  case key
    of Key.None:
      discard

    of Key.Escape:
      # Quit
      exitProc()

    # move cursor
    of Key.Left:
      app.commandMoveCursor(-1)
    of Key.Right:
      app.commandMoveCursor(1)

    # add number keys to the command
    of Key.Zero, Key.One, Key.Two, Key.Three, Key.Four, Key.Five, Key.Six, Key.Seven, Key.Eight, Key.Nine:
      app.commandAdd($wordToNum(key))

    # Add certain special keys
    of Key.LeftParen:
      app.commandAdd("(")
    of Key.RightParen:
      app.commandAdd(")")
    of Key.Space:
      app.commandAdd(" ")
    of Key.Comma:
      app.commandAdd(",")
    of Key.Semicolon:
      app.commandAdd(";")
    of Key.Dot:
      app.commandAdd(".")
    of Key.Underscore:
      app.commandAdd("_")
    of Key.Minus:
      app.commandAdd("-")
    of Key.DoubleQuote:
      app.commandAdd("\"")

    of Key.Enter:
      app.processInputEnter(c)

    of Key.Colon:
      app.changeScreen("input")

    # remove character after cursor
    of Key.Delete:
      app.commandDel()

    # remove character before cursor
    of Key.Backspace:
      app.processInputBackspace()

    # add the input key
    else:
      app.commandAdd($key)


# General Key processor
proc processKey(key: var Key, app: var AppState, c: var Canvas, r: var Repeater) =
  case key
    of Key.Escape:
      # quit
      exitProc()

    # add number keys to repeater
    of Key.Zero, Key.One, Key.Two, Key.Three, Key.Four, Key.Five, Key.Six, Key.Seven, Key.Eight, Key.Nine:
      r.addToRepeater(key)

    # move canvas (vim like key bindings)
    of Key.ShiftL:
      r.repeatMoveCanvas(c,-1,0)
    of Key.ShiftH:
      r.repeatMoveCanvas(c,1,0)
    of Key.ShiftJ:
      r.repeatMoveCanvas(c,0,-1)
    of Key.ShiftK:
      r.repeatMoveCanvas(c,0,1)

    # Move cursor (with vim key bindings)
    of Key.Left, Key.H:
      r.repeatMoveCursor(c,-1,0)
    of Key.Right, Key.L:
      r.repeatMoveCursor(c,1,0)
    of Key.Up, Key.K:
      r.repeatMoveCursor(c,0,-1)
    of Key.Down, Key.J:
      r.repeatMoveCursor(c,0,1)

    # Change screens
    of Key.P:
      app.changeScreen("pallete")
    of Key.C:
      app.changeScreen("color")
    of Key.I, Key.Colon:
      app.changeScreen("input")

    of Key.Enter, Key.Space:
      processEnter(app, c)

    of Key.Delete, Key.D:
      processDel(app, c)

    of Key.Backspace:
      # remove last number from repeater
      r.remFromRepeater()

    else:
      discard


# General Process Input function
proc processInput*(app: var AppState, canvas: var Canvas, pallete: var Canvas, repeater: var Repeater) =
  var key = getKey()

  case app.screen:
    of "pallete":
      # Pallete key processor
      key.processKey(app, pallete, repeater)

    of "color":
      # Color key processor
      key.processKeyColor(app)

    of "input":
      # Input key processor
      key.processKeyInput(canvas, app)

    else:
      # General (canvas) key processor
      key.processKey(app, canvas, repeater)



