local foo = pd.Class:new():register("mgl-globval")

function foo:initialize(sel, atoms)
    self.inlets = 1
    self.outlets = 1
    if type(atoms[1]) == "string" then
        self.varname = atoms[1]
        pd.post("Atom 1: " .. atoms[1] )
        if globtable == nil then
            pd.post("Create globtable")
            globtable = {}
        end
        return true
    else
        self:error(string.format("luatab, atom 1: expected array name, got %s",
                                 tostring(atoms[1])))
        return false
    end
end

function foo:in_1_float(val)
    pd.post(val)
    globtable[self.varname] = val
end

function foo:in_1_symbol(val)
    pd.post(val)
    globtable[self.varname] = val
end


function foo:in_1_bang()
    pd.post(globtable[self.varname])
    self:outlet(1, "float", {globtable[self.varname]})
end
