# Package

version       = "0.1.0"
author        = "Jake Leahy"
description   = "Simple bencode decoder/encoder that maps to/from JsonNode"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.9.0"

task checkDocs, "Runs documentation generator to make sure nothing is wrong":
  exec "nimble doc --errorMax:1 --warningAsError:BrokenLink:on --project --outdir:docs src/bencodie.nim"
