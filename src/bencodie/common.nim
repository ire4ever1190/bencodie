import strutils

type
  DecodeError* = object of CatchableError
  EncodeError* = object of CatchableError


const defaultShow* {.intdefine.}: int = 7
  ## How much to highlight in the error message when a length isn't known

func highlightSection*(buf: openArray[char], highlight: int, show: int = highlight, start = 0): string =
  ## Highlights a section so that error messages are better.
  ##
  ## - **highlight**: How much of the string to highlight
  ## - **show**: How much of the string to show
  ## - **start**: Where to start the highlighting
  runnableExamples:
    import std/strutils

    let highlighted = "hello world".highlightSection("hello".len, "hello world".len)
    assert highlighted = """
      hello world
      ^^^^^
    """.unindent()
  #==#
  assert show >= highlight + start, "You must be showing atleast as much as you're highlighting"
  # Allocate for
  # - All we want to show from original string
  # - The ^^^^ underneath
  # - The newline
  result = newStringOfCap(highlight + show + 1)
  result &= cast[string](buf[0..<min(show, buf.len)])
  result &= "\n"
  if start > 0:
    result &= " ".repeat(start)
  result &= "^".repeat(highlight)

template toOpenArray*(x: openArray[char], start: int): openArray[char] =
  ## Slices `x` so that it now starts at index `start` (And goes through the end)
  x.toOpenArray(start, x.len - 1)
