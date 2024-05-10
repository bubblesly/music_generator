local foo = pd.Class:new():register("mgl-makemelo1")

require("scale")
require("note")
-- require("degree")
require("chord")

function foo:initialize(sel, atoms)
    self.inlets = 2
    self.outlets = 1
    self.c = 1
    if type(atoms[1]) == "string" and type(atoms[2]) == "string" then
        self.notestable = atoms[1]
        self.triggertable = atoms[2]
        pd.post("Init")
        return true
    else
        self:error(string.format("mgl-makemelo1: expected array names, got %s",
                                 tostring(atoms[1]), " and ", tostring(atoms[2])))
        return false
    end
    self:update_table()
end

function foo:update_table()
    local nt = pd.Table:new():sync(self.notestable)
    local tt = pd.Table:new():sync(self.triggertable)
    local sn = pd.Table:new():sync("Scale")
    local cn = pd.Table:new():sync("Chords")

    

    local sout = self.s:to_semitones()
    local l = tt:length()

    local curoctave = 4


    pd.post(l)
    pd.post("In update_table()")
    self:outlet(1, "symbol", {self.s:tostring()})
    for i = 0,l-1 do
        local ind = i%7+1
        -- pd.post(ind)
        pd.post(7*(i//7))
        tt:set(i,sout[ind]+12*(i//7))
        nt:set(i,sout[ind]+12*(i//7))
    end
    tt:redraw()
    nt:redraw()
    pd.post(self.s:tostring())
end

function foo:in_1_bang()
    self:update_table()
end
