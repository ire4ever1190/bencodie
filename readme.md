# Bencodie

[docs here](https://ire4ever1190.github.io/bencodie/bencodie.html)

Simple bencoder library. Made since I needed to read some bencoded text but the other libraries either didn't work or didn't do what I want.

This maps to/from `JsonNode` so that you can easily convert your objects to/from bencoding.

```nim
# This is basically the entire API
assert readBencode("li14e4:spamli42eee") == %*[14, "spam", [42]]
assert writeBencode(%14) == "i14e"
```
