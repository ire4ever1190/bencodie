import bencodie
import bencodie/common
import std/unittest
import std/json


suite "Decoders":
  test "Valid integer":
    check readBencode("i14e") == %14

  test "Integer doesn't start with i":
    expect DecodeError:
      discard readBencode("14e")

  test "Integer doesn't end with e":
    expect DecodeError:
      discard readBencode("i14")

  test "Valid string":
    check readBencode("4:spam") == %"spam"
    check readBencode("14:12345678901234") == %"12345678901234"

  test "Missing length":
    expect DecodeError:
      discard readBencode("yup")

  test "Wrong length":
    expect DecodeError:
      discard readBencode("14:test")

  test "Missing :":
    expect DecodeError:
      discard readBencode("4spam")

  test "List":
    check readBencode("li42e5:stuffi666ee") == %*[42, "stuff", 666]

  test "List in list":
    # This was causing an infinite loop
    check readBencode("li14e4:spamli42eee") == %*[14, "spam", [42]]

  test "Dict in dict":
    check readBencode("d3:food3:fooi2eee") == %*{"foo": {"foo": 2}}

  test "List with two lists":
    check readBencode("llelee") == %*[[], []]

  test "List with two dicts":
    check readBencode("ld3:fooleed3:barleee") == %*[{"foo": []}, {"bar": []}]

suite "Encoders":
  test "Integer":
    check writeBencode(%14) == "i14e"

  test "String":
    check writeBencode(%"spam") == "4:spam"

  test "List":
    check writeBencode(%*[42, "stuff", 666]) == "li42e5:stuffi666ee"

  test "Dict":
    check writeBencode(%*{
      "c": 3,
      "a": 1,
      "b": 2
    }) == "d1:ai1e1:bi2e1:ci3ee"
