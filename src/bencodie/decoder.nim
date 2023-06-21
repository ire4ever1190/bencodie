import common
import std/[
  parseutils,
  json,
  strutils,
  tables
]


func readInt(buf: openArray[char], item: var JsonNode): int =
  if buf[0] != 'i':
    raise (ref DecodeError)(msg: "Integer doesn't start with i\n" & buf.highlightSection(1, 5))

  var num: int
  let len = buf.toOpenArray(1).parseInt(num)

  if len == 0:
    raise (ref DecodeError)(msg: "Invalid integer\n" & buf.highlightSection(1))
  elif buf.len == len + 1 or buf[len + 1] != 'e':
    raise (ref DecodeError)(msg: "Integer doesn't end with e\n'" & buf.highlightSection(len + 2))

  item = %num
  return 2 + len # Length + i at start + e at end


func readString(buf: openArray[char], item: var string): int =
  ## Parses a string from the buffer. This operates directly on string for performance reasons
  # Get the length of the string
  var strLength: int
  let lenLen = buf.parseInt(strLength)
  if lenLen == 0:
    raise (ref DecodeError)(msg: "Invalid length on string\n" & buf.highlightSection(defaultShow))
  elif lenLen + 1 == buf.len or buf[lenLen] != ':':
    raise (ref DecodeError)(msg: "Missing : in string\n" & buf.highlightSection(defaultShow))
  elif buf.len - 2 < strLength:
    raise (ref DecodeError)(msg: "String is not long enough\n" & buf.highlightSection(defaultShow))
  # Now parse the actual string
  # We just copy it across
  item = newString(strLength)
  for i in 0..<strLength:
    item[i] = buf[lenLen + 1 + i] # Length of string length + colon, then we can get the index
  return lenLen + 1 + strLength # Length of string length + colon + how long the string was

func readString(buf: openArray[char], item: var JsonNode): int {.inline.} =
  ## Reads a string from the buffer. This operates on JsonNode like everything else
  var str: string
  result = buf.readString(str)
  item = %str

proc readDict(buf: openArray[char], items: var JsonNode): int
proc readList(buf: openArray[char], items: var JsonNode): int

proc readValue(buf: openArray[char], item: var JsonNode): int =
  ## Parses any value depending on what the first character is
  ##
  ## - 'i': Integer
  ## - Some digit: String
  ## - 'l': List
  ## - 'd': Dictionary
  case buf[0]
  of 'i':
    result += buf.readInt(item)
  of Digits:
    result += buf.readString(item)
  of 'l':
    result += buf.readList(item)
  of 'd':
    result += buf.readDict(item)
  else:
    raise (ref DecodeError)(msg: "Unexpected character\n" & buf.highlightSection(1, defaultShow))

proc readDict(buf: openArray[char], items: var JsonNode): int =
  if buf[0] != 'd':
    raise (ref DecodeError)(msg: "Dictionary doesn't start with 'd'\n" & buf.highlightSection(1, defaultShow))
  var i = 1
  items = newJObject()
  while i < buf.len and buf[i] != 'e': # Lists end with 'e'
    # First parse the key
    var key: string
    i += buf.toOpenArray(i).readString(key)
    # Now we can parse the value
    var val: JsonNode
    i += buf.toOpenArray(i).readValue(val)
    items[key] = val
  return i


proc readList(buf: openArray[char], items: var JsonNode): int =
  if buf[0] != 'l':
    raise (ref DecodeError)(msg: "List doesn't start with 'l'\n" & buf.highlightSection(1, 4))
  items = newJArray()
  var i = 1
  while i < buf.len and buf[i] != 'e': # Lists end with 'e'
    var newItem: JsonNode
    i += buf.toOpenArray(i).readValue(newItem)
    items &= newItem
  return i

proc readBencode*(buf: openArray[char]): JsonNode =
  ## Parses a bencode string and returns it as `JsonNode`
  runnableExamples:
    import std/json
    assert readBencode("li42e5:stuffi666ee") == %*[42, "stuff", 666]
  #==#
  discard buf.readValue(result)


