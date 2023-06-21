import std/[
  json,
  sequtils,
  algorithm
]
import common

template write(str: string, buf: var string) =
  ## Writes a string value to the buffer
  buf.addInt(str.len)
  buf &= ":" & str

proc writeBencode*(data: JsonNode, result: var string) =
  ## Writes JSON into a bencode encoded string. This performs it inplace
  case data.kind
  of JInt:
    result &= "i"
    result.addInt(data.num)
    result &= 'e'
  of JString:
    data.str.write(result)
  of JArray:
    result &= 'l'
    for item in data:
      item.writeBencode(result)
    result &= 'e'
  of JObject:
    # We first need to sort the keys, and then write them out
    var keys = toSeq(data.keys)
    keys.sort()
    result &= 'd'
    for key in keys:
      key.write(result)
      data[key].writeBencode(result)
    result &= 'e'
  else:
    raise (ref EncodeError)(msg: $data.kind & " cannot be converted into Bencode")

proc writeBencode*(data: JsonNode): string =
  ## Converts JSON into a Bencoded string.
  ##
  ## - See [writeBencode(data, result)] for inplace version
  data.writeBencode(result)
