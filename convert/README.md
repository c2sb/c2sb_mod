This documents manual conversion steps. In the future, I hope to automate this process.

# Extract agent file
Run `revelation.exe <file>` to extract your `.agent` or `.agents` file.

# Convert C16 to PNG
1. Run `c16topng.exe -t <filename.c16>` to extract the `.c16` images.
2. Copy these to `agents/images/<filename>/` as-is.

# Convert WAV to OGG
1. Convert the files. (I have been using FlicFlac to do the conversion.)
2. Copy these to `agents/sounds/` as-is.

Note that Starbound does support WAV files, but because it doesn't support the _type_ of WAV files
that are in Creatures, we need to perform the conversion.

# Convert COS to LUA
This is the tricky part. Note that `AgentName` is the name of your agent.

1. Move and rename the cos file to `agents/scripts/AgentName.lua`.

2. Perform the following regex replacements:

| Regex | Replacement | Reason/Note |
|-------|-------------|-------------|
| `\*(.*)$` | `--*\1` | Comments |
| `\[` | `[[` | byte array to string (1) |
| `\]` | `]]` | byte array to string (2) |
| `\b(inst|slow|lock|unlk|over)\b` | `\1()` | Some no-arg commands |
| `scrp (\d+) (\d+) (\d+) (\d+)` | `scrp(\1, \2, \3, \4, function()` | Script definition (head) |
| `\breps (\d+|va\d\d|mv\d\d|ov\d\d)` | `reps(\1, function()` | Repeat loop (head) |
| `\benum (\d+) (\d+) (\d+)` | `enum(\1, \2, \3, function()` | Enums |
| `\b(endm|next|repe)\b` | `end)` | Script definition (tail), other stuff |
| `\b(endi|retn)\b` | `end` |  |
| `\b(attr|bhvr|accg|elas|aero|rnge|fric|tick|wait) (-?\d+)` | `\1(\2)` | Add parentheses to one-arg numeric calls |
| `\bkill (ownr|targ)` | `kill(\1)` | Common kill command |
| `\b(setv|addv|subv|andv|divv|modv|mulv|orrv) (va\d\d|mv\d\d|ov\d\d|velx|vely|_p1_|_p2_|from) (-?\d+|wdth|hght|posx|posy|posl|post|posr|posb|va\d\d|mv\d\d|ov\d\d|velx|vely|_p1_|_p2_|from)\b` | `\1(\2, \3)` | Basic variable functions |
| `\bscrx (\d+) (\d+) (\d+) (\d+)` | `scrx(\1, \2, \3, \4)` | |
| `\bdoif\b` | `if` | |
| `\belif\b` | `elseif` | |
| `(=|\beq\b)` | `==` | Do this FIRST! |
| `(<>|\bne\b)` | `~=` | |
| `\bge\b` | `>=` | |
| `\ble\b` | `<=` | |
| `\bgt\b` | `>` | |
| `\blt\b` | `<` | |
| `\bloop\b` | `repeat` | |
| `\buntl\b` | `until` | |
| `\brand (-?\d+) (-?\d+)` | `rand(\1, \2)` | Common rand calls |
| `\bstim writ\b` | `stim_writ` | Command rename |
| `\bstim wrt+\b` | `stim_wrt_plus` | command rename |
| `\bgsub (\w+)` | `\1()` | |
| `\bsubr (\w+)` | `local function \1()` | NOTE: You must also MOVE this block to the BEGINNING of your SCRP script block! |


3. At the beginning of the file, add
~~~lua
require("/scripts/caos_vm/caos.lua")
AgentName = {}
~~~

_Note: `AgentName` must match the file name._

4. Surround your install script with the following
~~~lua
function AgentName.install()
  -- Your install script
end
~~~

5. Remove `rscr`, and surround your uninstall/removal script with the following
~~~lua
function AgentName.uninstall()
  -- Your removal script
end
~~~

6. Add parentheses and commas to new: commands.
~~~lua
-- Before: new: simp 3 8 4608 "ASmechaseed" 11 0 rand 500 3000
-- After:
new: simp (3, 8, 4608, "ASmechaseed", 11, 0, rand (500, 3000))
~~~

_Note: The colon syntax is magically valid. :)_

7. Ensure that all commands in conditional statements have their parentheses!
Lua will NOT complain if they are missing!
~~~lua
if fall ~= 1        -- BAD! No error, but doesn't work!
if fall() ~= 1      -- GOOD!
~~~

8. Make sure that all `if` and `elseif` have a trailing `then`. With a script that has new lines properly in place you can use the regex `\b(if|elseif)\b (.*)$` replaced with `\1 \2 then`.

9. (Temporary) Replace all instances of ovxx, mvxx, vaxx in conditionals with getv(ovxx), etc.

Since this is still a manual and incomplete process, you will need to continue with the parentheses additions and script fixups. Look at the included scripts for examples.

Note the LUA documentation on function calls. Single-argument functions that take a string (`"str"` or `[[str]]`) don't need parentheses. Additionally, the code was designed in such a way that no-argument commands being passed to another command needs parentheses, for example `setv(va00, posx)`, but you otherwise need to use parentheses in conditionals, such as `if posx() == 3500` (poor example).
