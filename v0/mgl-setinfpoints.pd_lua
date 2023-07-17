local foo = pd.Class:new():register("mgl-setinfpoints")

probatable = {100,25,50,25}

function foo:initialize(sel, atoms)
    self.inlets = 1
    self.outlets = 1
    if type(atoms[1]) == "string" then
        self.tabname = atoms[1]
        return true
    else
        self:error(string.format("luatab: expected array name, got %s",
                                 tostring(atoms[1])))
        return false
    end
end

function foo:in_1_float(val)
    local t = pd.Table:new():sync(self.tabname)
    for i = 0,val-1 do
        local dice = math.random(100)
        if dice < probatable[i%4+1] then
            infpoint = 1
        else
            infpoint = 0
        end
        t:set(i,infpoint)
    end
    t:redraw()
end
