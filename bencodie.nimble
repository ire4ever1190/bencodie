# Package

version       = "0.2.0"
author        = "Jake Leahy"
description   = "Simple bencode decoder/encoder that maps to/from JsonNode"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 2.2.8"
requires "gh:ire4ever1190/casserole >= 0.2.12"

task checkDocs, "Runs documentation generator to make sure nothing is wrong":
  exec "nimble doc --errorMax:1 --warningAsError:BrokenLink:on --project --outdir:docs src/bencodie.nim"
