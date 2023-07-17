local foo = pd.Class:new():register("mgl-scale")

require("scale")
require("note")
require("degree")
require("chord")

function foo:initialize(sel, atoms)
    self.inlets = 2
    self.outlets = 2
    self.c = 1
    self.s = Scale.get_major(Note.from_semitone(0))
    if type(atoms[1]) == "string" then
        self.tabname = atoms[1]
        return true
    else
        self:error(string.format("luatab: expected array name, got %s",
                                 tostring(atoms[1])))
        return false
    end
    self:update_table()
end

function foo:update_table()
    local t = pd.Table:new():sync(self.tabname)
    local sout = self.s:to_semitones()
    self:outlet(1, "symbol", {self.s:tostring()})
    for i = 0,6 do
        t:set(i,sout[i+1])
    end
    t:redraw()
    pd.post(self.s:tostring())
end

function foo:in_1_bang()
    self:update_table()
end

-- v is the degree (0 = degree I, 1 = degree II)
function foo:in_2_float(v)
    local d = Degree(v+1,0)
    local c = ChordBuilder(self.s,d):withSeventh():withNinth():withEleventh():withThirteenth()
    local chord = c:build()
    -- pd.post("Chord: " .. chord:tostring())
    self:outlet(2, "symbol", {chord:tostring()})
    chordnotes = chord:to_ascending_semitones()
    local t = pd.Table:new():sync("chordnotes")
    local tu = pd.Table:new():sync("chordnotes_unwrapped")
    for i = 0,6 do
        -- pd.post(tostring(chordnotes[i+1]))
        t:set(i,chordnotes[i+1])
        tu:set(i,chordnotes[i+1] % 12)
    end
    t:redraw()
end

function foo:in_1_cfifth(val)
    local ret = self.s:cfifth_rotate(val[1])
    if ret == "Error" then
        self:error("cfifth_rotate: expected integer, got " ..
                                tostring(val[1]) )
        return false
    else
        self.s = ret
        pd.post("Circle of fith by " .. tostring(val[1]) )
    end
    self:update_table()
end


function foo:in_1_tominor()
    local ret = self.s:tominor()
    self.s = ret
    pd.post("To minor")
    self:update_table()
end

function foo:in_1_tomajor()
    local ret = self.s:tomajor()
    self.s = ret
    pd.post("To major")
    self:update_table()
end

function foo:in_1_float(v)
    self.s = Scale.get_major(Note.from_semitone(v))
    self:update_table()
end

-- function foo:in_1_getchord(val)
--     local c = Chord.from_scale_and_degree(self,val)
--     pd.post(c:tostring())
-- end
