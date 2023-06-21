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
