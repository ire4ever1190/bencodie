import std/[
  json,
  sequtils,
  algorithm,
  tables
]
import common

import pkg/casserole

template write(str: string, buf: var string) =
  ## Writes a string value to the buffer
  buf.addInt(str.len)
  buf &= ":" & str

proc writeBencode*(data: JsonNode, result: var string) =
  ## Writes JSON into a bencode encoded string. This performs it inplace
  case data
  of JInt(num):
    result &= "i"
    result.addInt(num)
    result &= 'e'
  of JString(val):
    val.write(result)
  of JArray(items):
    result &= 'l'
    for item in items:
      item.writeBencode(result)
    result &= 'e'
  of JObject(obj):
    # We first need to sort the keys, and then write them out
    var keys = toSeq(obj.keys)
    keys.sort()
    result &= 'd'
    for key in keys:
      key.write(result)
      obj[key].writeBencode(result)
    result &= 'e'
  else:
    raise (ref EncodeError)(msg: $data.kind & " cannot be converted into Bencode")

proc writeBencode*(data: JsonNode): string =
  ## Converts JSON into a Bencoded string.
  ##
  ## - See [writeBencode(data, result)] for inplace version
  data.writeBencode(result)
