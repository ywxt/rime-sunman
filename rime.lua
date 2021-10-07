-- rime.lua

local t = require("sunman/sunman_spelling")
sunman_spelling = t.filter
sunman_spelling_processor = t.processor

sunman_pua_filter = require("sunman/sunman_pua")

sunman_single_char = require("sunman/sunman_single_char")

sunman_postpone_fullcode = require("sunman/sunman_postpone_fullcode")

sunman_charset_filter = require("sunman/sunman_charset")
