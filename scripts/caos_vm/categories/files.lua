-- NOTE It is generally impossible in Starbound to read/write arbitrary files, so all of these
-- caos functions are impossible to emulate. 

--------------------
-- CAOS FUNCTIONS --
--------------------

-- Launches an external URL in the user's browser. The game engine adds http:// at the beginning to
-- prevent malicious launching of programs, so you just need to specify the domain name and path.
CAOS.Cmd("webb", function(http_url)
  sb.logInfo("http://%s", http_url)
end)
