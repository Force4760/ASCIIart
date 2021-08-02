import colors
import illwill



# App state object that holds important information:
#   -> selectedCharacter
#   -> selectedBgColor
#   -> selectedfgColor
#   -> activeColorChooser:
#       -> if the user is choosing a Foreground or a Background color
#   -> command:
#       -> command to be interpreted as a function
#   -> commandCursor:
#       -> cursor position of the command string
#   -> screen:
#       -> screen that is being shown:
#           -> canvas, colors, pallete, input
type AppState* = object
  selectedCharacter*: string
  selectedBgColor*: BackgroundColor
  selectedFgColor*: ForegroundColor
  activeColorChooser*: TermColors
  command*: string
  commandCursor*: int
  screen*: string


# Create a new default App state object
proc newAppState*(): AppState =
  var app = AppState(
    selectedCharacter:"-",
    selectedBgColor: bgNone,
    selectedFgColor: fgWhite,
    activeColorChooser: fg,
    command: "",
    commandCursor: 0,
    screen: "canvas")
  result = app


# error message shown on error
const errorString* = "Sorry! An error occurred!"


proc appError*(app: var AppState) =
  app.screen = "input"
  app.command = errorString
  app.commandCursor = len(errorString)
