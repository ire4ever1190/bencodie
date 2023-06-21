import std/[
  json,
  sugar,
  algorithm
]
import common

template write(str: string, buf: var string) =
  ## Writes a string value to the buffer
  buf.addInt(str.len)
  buf &= ":" & str

proc writeBencode*(x: JsonNode): string =
  ## Writes JSON into a bencode encoded string
  case x.kind
  of JInt:
    result = "i"
    result.addInt(x.num)
    result &= 'e'
  of JString:
    x.str.write(result)
  of JArray:
    result &= 'l'
    for item in x:
      result &= item.writeBencode()
    result &= 'e'
  of JObject:
    # We first need to sort the keys, and then write them out
    var keys: seq[string]
    for key in x.keys:
      keys &= key
    keys.sort()
    result &= 'd'
    for key in keys:
      key.write(result)
      result &= x[key].writeBencode()
    result &= 'e'
  else:
    raise (ref EncodeError)(msg: $x.kind & " cannot be converted into Bencode")
