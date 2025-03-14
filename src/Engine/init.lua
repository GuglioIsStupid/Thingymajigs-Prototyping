local path = (... .. "."):gsub("init.", "")

MiniClass = require(path .. "MiniClass")
MicrogameHandler = require(path .. "MicrogameHandler")
Timer = require(path .. "Timer")

Ease = require(path .. "Backend.Ease")
Tween = require(path .. "Backend.Tween")
TweenType = require(path .. "Backend.TweenType")
VarTween = require(path .. "Backend.VarTween")

TweenManager = require(path .. "Tween")