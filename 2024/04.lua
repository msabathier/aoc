--[[
--- Day 4: Ceres Search ---

"Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it. After a brief flash, you recognize the interior of the Ceres monitoring station!

As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt; she'd like to know if you could help her with her word search (your puzzle input). She only has to find one word: XMAS.

This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words. It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them. Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:

..X...
.SAMX.
.A..A.
XMAS.S
.X....

The actual word search will be full of letters instead. For example:

MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX

In this word search, XMAS occurs a total of 18 times; here's the same word search again, but where letters not involved in any XMAS have been replaced with .:

....XXMAS.
.SAMXMS...
...S..A...
..A.A.MS.X
XMASAMX.MM
X.....XA.A
S.S.S.S.SS
.A.A.A.A.A
..M.M.M.MM
.X.X.XMASX

Take a look at the little Elf's word search. How many times does XMAS appear?
--]]

---Return an interator over multiple lists
---@param ... table
---@return fun(state: table[], i?: integer): integer, table
---@return table state
---@return integer i
local function zip(...)
  local iterator = function(state, i)
    local values = {}
    for _, t in ipairs(state) do
      table.insert(values, t[i + 1])
    end
    if #state == #values then
      return i + 1, table.unpack(values)
    else
      return nil
    end
  end
  return iterator, { ... }, 0
end

local xmas = {}
for line in io.lines("input-04.txt") do
  table.insert(xmas, {})
  local i = #xmas
  for letter in string.gmatch(line, "%u") do
    table.insert(xmas[i], letter)
  end
end

local xmasCount = 0
for i = 1, #xmas do
  for j = 1, #xmas[i] do
    if xmas[i][j] == "X" then
      for _, di, dj in zip({ 0, 1, 1, 1, 0, -1, -1, -1 }, { 1, 1, 0, -1, -1, -1, 0, 1 }) do
        local row1 = xmas[i + di] or {}
        local row2 = xmas[i + 2 * di] or {}
        local row3 = xmas[i + 3 * di] or {}
        if (row1[j + dj] == "M") and (row2[j + 2 * dj] == "A") and (row3[j + 3 * dj] == "S") then
          xmasCount = xmasCount + 1
        end
      end
    end
  end
end
print(xmasCount)

--[[
--- Part Two ---

The Elf looks quizzically at you. Did you misunderstand the assignment?

Looking for the instructions, you flip over the word search to find that this isn't actually an XMAS puzzle; it's an X-MAS puzzle in which you're supposed to find two MAS in the shape of an X. One way to achieve that is like this:

M.S
.A.
M.S

Irrelevant characters have again been replaced with . in the above diagram. Within the X, each MAS can be written forwards or backwards.

Here's the same example from before, but this time all of the X-MASes have been kept instead:

.M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
..........

In this example, an X-MAS appears 9 times.

Flip the word search from the instructions back over to the word search side and try again. How many times does an X-MAS appear?
--]]

xmasCount = 0
for i = 1, #xmas do
  for j = 1, #xmas[i] do
    if xmas[i][j] == "A" then
      local rowUp = xmas[i - 1] or {}
      local rowDown = xmas[i + 1] or {}
      if
        (
          (rowUp[j - 1] == "M" and rowDown[j + 1] == "S")
          and ((rowUp[j + 1] == "M" and rowDown[j - 1] == "S") or (rowUp[j + 1] == "S" and rowDown[j - 1] == "M"))
        )
        or (
          (rowUp[j - 1] == "S" and rowDown[j + 1] == "M")
          and ((rowUp[j + 1] == "M" and rowDown[j - 1] == "S") or (rowUp[j + 1] == "S" and rowDown[j - 1] == "M"))
        )
      then
        xmasCount = xmasCount + 1
      end
    end
  end
end
print(xmasCount)
