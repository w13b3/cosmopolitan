-- Copyright 2022 Justine Alexandra Roberts Tunney
--
-- Permission to use, copy, modify, and/or distribute this software for
-- any purpose with or without fee is hereby granted, provided that the
-- above copyright notice and this permission notice appear in all copies.
--
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
-- WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
-- AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
-- DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
-- PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
-- TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.

assert(EncodeLua(nil) == "nil")
assert(EncodeLua(true) == "true")
assert(EncodeLua(false) == "false")
assert(EncodeLua(0) == "0")
assert(EncodeLua(0.0) == "0.")
assert(EncodeLua(3.14) == "3.14")
assert(EncodeLua(0/0) == "0/0")
assert(EncodeLua(123.456e-789) == '0.')
assert(EncodeLua(9223372036854775807) == '9223372036854775807')
assert(EncodeLua(-9223372036854775807 - 1) == '-9223372036854775807 - 1')
assert(EncodeLua(7000) == '7000')
assert(EncodeLua(0x100) == '0x0100')
assert(EncodeLua(0x10000) == '0x00010000')
assert(EncodeLua(0x100000000) == '0x0000000100000000')
assert(EncodeLua(math.huge) == "math.huge")
assert(EncodeLua({2, 1}) == "{2, 1}")
assert(EncodeLua({3, 2}) == "{3, 2}")
assert(EncodeLua({[0]=false}) == "{[0]=false}")
assert(EncodeLua({[1]=123, [2]=456}) == "{123, 456}")
assert(EncodeLua({[1]=123, [3]=456}) == "{[1]=123, [3]=456}")
assert(EncodeLua({["hi"]=1, [1]=2}) == "{[1]=2, hi=1}")
assert(EncodeLua({[1]=2, ["hi"]=1}) == "{[1]=2, hi=1}")
assert(EncodeLua({[3]=3, [1]=3}) == "{[1]=3, [3]=3}")
assert(EncodeLua({[{[{[3]=2}]=2}]=2}) == "{[{[{[3]=2}]=2}]=2}")
assert(EncodeLua(" [\"new\nline\"] ") == "\" [\\\"new\\nline\\\"] \"")
assert(EncodeLua("hello") == [["hello"]])
assert(EncodeLua("\x00") == [["\x00"]])
assert(EncodeLua("→") == [["\xe2\x86\x92"]])
assert(EncodeLua("𐌰") == [["\xf0\x90\x8c\xb0"]])
assert(EncodeLua("\a") == [["\a"]])
assert(EncodeLua("\b") == [["\b"]])
assert(EncodeLua("\r") == [["\r"]])
assert(EncodeLua("\n") == [["\n"]])
assert(EncodeLua("\v") == [["\v"]])
assert(EncodeLua("\t") == [["\t"]])
assert(EncodeLua("\f") == [["\f"]])
assert(EncodeLua("\e") == [["\e"]])
assert(EncodeLua("\"") == [["\""]])
assert(EncodeLua("\\") == [["\\"]])

x = {}
x.c = 'c'
x.a = 'a'
x.b = 'b'
assert(EncodeLua(x) == '{a="a", b="b", c="c"}')

x = {2, 1}
x[3] = x
assert(string.match(EncodeLua(x), "{2, 1, \"cyclic@0x%x+\"}"))

-- 63 objects
assert(EncodeLua(
{k={k={k={k={k={k={k={k={k={k={k={k={k={k=
{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k=
{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k=
{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k=
{k={k={k={k=0}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}) ==
"{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k={k="..
"{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k={k="..
"{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k={k="..
"{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k=0}}"..
"}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"..
"}}}}}}}}}}}}}")

-- 64 objects
assert(EncodeLua(
{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k=
{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k=
{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k=
{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k=
{k={k={k={k=0}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
) ==
"{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k={k="..
"{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k={k="..
"{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k={k="..
"{k={k={k={k={k={k={k={k={k={k={k={k={k={k={k={k=\"greatdepth@0\"}}}"..
"}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"..
"}}}}}}}}}}}}}")

--------------------------------------------------------------------------------
-- benchmark		nanos	ticks
-- LuaEncArray		455	1410
-- LuaEncUnsort		699	2165
-- LuaEncObject		1134	3513

function LuaEncArray()
   EncodeLua({2, 1, 10, 3, "hello"})
end

function LuaEncObject()
   EncodeLua({hi=2, 1, 10, 3, "hello"})
end

UNSORT = {sorted=false}
function LuaEncUnsort()
   EncodeLua({hi=2, 1, 10, 3, "hello"}, UNSORT)
end

function bench()
   print("LuaEncArray", Benchmark(LuaEncArray))
   print("LuaEncUnsort", Benchmark(LuaEncUnsort))
   print("LuaEncObject", Benchmark(LuaEncObject))
end
