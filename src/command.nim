import strutils
import appState


# remove "Shift" and "Ctrl" from the string
proc removeKeywords*(character: string): string =
  result = character.replace("Shift", "").replace("Ctrl", "")


# Move the cursor command
proc commandMoveCursor*(app: var AppState, delta: int) =
  let finalCursor = app.commandCursor + delta

  # can't be negative
  if finalCursor < 0:
    app.commandCursor = 0
  # can't be larger than the length of the command
  elif finalCursor > len(app.command):
    app.commandCursor = len(app.command)
  # just update it
  else:
    app.commandCursor = finalCursor


# Add new character to the command
proc commandAdd*(app: var AppState, character: string) =
  let ch = character.removeKeywords()
  try:
    # add character at cursor position
    app.command = app.command[0 ..< app.commandCursor] & ch & app.command[app.commandCursor ..^ 1]
    # move the cursor to after the added character
    app.commandMoveCursor(len(ch))
  except:
    discard


# Remove one character from the command
proc commandBackspace*(app: var AppState) =
  try:
    # remove the character before the cursor
    app.command = app.command[0 ..< app.commandCursor - 1] & app.command[app.commandCursor ..^ 1]
    # move the cursor back
    app.commandMoveCursor(-1)
  except:
    discard


# Remove one character from the command
proc commandDel*(app: var AppState) =
  try:
    # remove the character after the cursor
    app.command = app.command[0 ..< app.commandCursor] & app.command[app.commandCursor + 1 ..^ 1]
  except:
    discard


# Set a new command and delete the previous one
proc setCommand*(app: var AppState, command: string) =
  # change the command
  app.command = command
  # move the cursor
  app.commandCursor = len(command)


# Render command and cursor
proc renderCommand*(app: var AppState): string =
  return app.command[0 ..< app.commandCursor] & "|" & app.command[app.commandCursor ..^ 1]
