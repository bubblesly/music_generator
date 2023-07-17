local foo = pd.Class:new():register("mgl-suite")

function foo:initialize(sel, atoms)
    self.inlets = 1
    self.outlets = 0
    if type(atoms[1]) == "string" then
        self.t_ipoints = atoms[1]
        -- pd.post("Atom 1: " .. atoms[1] )
    else
        self:error(string.format("luatab, atom 1: expected array name, got %s",
                                 tostring(atoms[1])))
        return false
    end
    if type(atoms[2]) == "string" then
        self.t_chords = atoms[2]
        -- pd.post("Atom 2: " .. atoms[2] )
        return true
    else
        self:error(string.format("luatab, atom 2: expected array name, got %s",
                                 tostring(atoms[2])))
        return false
    end
end

function foo:in_1_float(val)
    local tip = pd.Table:new():sync(self.t_ipoints)
    local tch = pd.Table:new():sync(self.t_chords)
    -- pd.post("In float" )
    for i = 0,val-1 do
        -- pd.post("Fill tch index " .. tostring(i) )
        tipi = tip:get(i)
        -- pd.post("tipi=" .. tostring(tipi))
        if i==0 then
            tch:set(i,0)
        else
            if tipi==1 then
                if math.random(2)>1 then
                    tch:set(i,math.random(7)-1)
                else
                    tch:set(i,tch:get(i-1))
                end
            else
                tch:set(i,tch:get(i-1))
            end
        end
    end
    tch:redraw()
    -- pd.post("Done filling chords.")
end
