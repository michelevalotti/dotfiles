local M = {}

function M.exec(command)
    local f = io.popen(command)
    if f == nil then return nil end
    local l = f:read("*a")
    f:close()
    return l
end

function M.table_len(table)
    local len = 0
    for _ in pairs(table) do
        len = len + 1
    end
    return len
end

function M.get_index_of_table_entry(tbl, val)
    for k,v in pairs(tbl) do
        if v == val then
            return k
        end
    end
end

function M.bool_to_sign(bool)
    local bool_to_int = bool and 1 or 0
    return (2 * bool_to_int) - 1
end

function M.split_str(str, char)
    local tbl = {}
    for p in string.gmatch(str, "([^" .. char .. "]+)") do
        table.insert(tbl, p)
    end
    return tbl
end

function M.list_dir(path, files_only)
    files_only = files_only or false
    local cmd = "ls " .. path
    if files_only then
        cmd = "find " .. path .. " -maxdepth 1 -type f | xargs -- basename"
    end
    local ls_ret = M.exec(cmd)
    if ls_ret == nil then
        return nil
    end
    return M.split_str(ls_ret, '\n')
end

function M.get_git_dir(path)
    local current_path = path or vim.fn.expand('%:p:h')
    local cmd = "git -C " .. current_path .. " rev-parse --show-toplevel 2>/dev/null"
    local git_dir = M.exec(cmd)
    if git_dir == nil then
        return nil
    end
    git_dir = string.gsub(git_dir, "\n", "")
    return git_dir
end

function M.get_tree_chain()
    local node_chain = {}
    local node = vim.treesitter.get_node()
    if node == nil then return node_chain end

    local node_type = node:type()
    while node_type ~= "module" do
        if node_type == "function_definition" or node_type == "class_definition" then
            table.insert(node_chain, node)
        end
        node = node:parent()
        if node == nil then break end
        node_type = node:type()
    end

    local node_chain_names = {}
    for _, n in pairs(node_chain) do
        local node_name = vim.treesitter.get_node_text(n:child(1), 0)
        table.insert(node_chain_names, node_name)
    end
    return node_chain_names
end

local global_timer = vim.uv.new_timer()
function M.add_debounce(t, fn, args)
    if global_timer == nil then
        return
    end
    global_timer:stop()
    global_timer:start(t, 0, vim.schedule_wrap(function ()
        if args == nil then
            return
        end
        pcall(fn, unpack(args))
    end))
end

function M.tbl_extend(tbl_orig, tbl_add)
    for k, v in pairs(tbl_add) do
        tbl_orig[k] = v
    end
    return tbl_orig
end

return M
