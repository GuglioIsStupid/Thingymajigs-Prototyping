local path = (... .. "."):gsub("init.", "")

BaseMicrogame = require(path .. "baseMicrogame")

testMicrogame = require(path .. "testMicrogame")
blendingIn = require(path .. "blendingIn")
findHim = require(path .. "findHim")
catchMicrogame = require(path .. "catchGame")