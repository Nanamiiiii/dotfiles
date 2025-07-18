-- clangd configuration
local h = require("utils.helper")
-- Get cross compiler path for query driver
local compilers = {
    -- Native
    "gcc",
    "g++",
    -- RISC-V Cross
    "riscv64-unknown-linux-gnu-gcc",
    "riscv64-unknown-linux-gnu-g++",
    "riscv64-unknown-linux-musl-gcc",
    "riscv64-unknown-linux-musl-g++",
}

local compilers_path = {}
for _, val in ipairs(compilers) do
    local res = h.binary_path(val)
    if res ~= nil then
        table.insert(compilers_path, res)
    end
end

-- consruct clangd command args
local clangd_cmd = { "clangd" }
if next(compilers_path) ~= nil then
    local query_drivers = table.concat(compilers_path, ",")
    table.insert(clangd_cmd, "--query-driver=" .. query_drivers)
end

return {
    cmd = clangd_cmd,
}
