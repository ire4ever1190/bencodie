import bencodie/[decoder, encoder]
import std/json

##[
  .. importdoc:: bencodie/decoder.nim
  .. importdoc:: bencodie/encoder.nim

  Simple encoder/decoder for the [Bencode format](https://en.wikipedia.org/wiki/Bencode).
  The library operates over `JsonNode` so that you can reuse your own converters/json utilities.

  It supports the following types

  - `string`
  - `int`
  - `list`
  - `dict`

  `bool` and `float` are not supported since they were not in the standard.

  Reading is done with [readBencode()]
]##

runnableExamples:
  # Supports integers
  assert readBencode("i14e") == %14
  # Strings
  assert readBencode("4:spam") == %"spam"
  # Lists
  assert readBencode("li14e4:spamli42eee") == %*[14, "spam", [42]]
  # Dicts
  assert readBencode("d3:foo3:bar3") == %*{"foo": "bar"}

## Writing can be done via [writeBencode(data, result)] (in-place) or [writeBencode(data)] (returns a string)

runnableExamples:
  # Returning new string
  assert writeBencode(%14) == "i14e"
  # In-place
  var res: string
  writeBencode(%14, res)
  assert res == "i14e"

export decoder, encoder
export json
