local M = {}

---Return github url
---@param src string
local function gh(src) return 'https://github.com/' .. src .. '.git' end

---@alias PluginConfig function|nil
---@alias PluginEvents vim.api.keyset.events[]|nil
---@alias PluginKeys Keys[]|nil

---@class Keys
---
---@field [1] string
---@field [2]? string|function
---@field mode? string
---@field desc? string

---@class Spec
---
---@field src string Short url (user/repo)
---@field version? string|vim.VersionRange
---@field name? string Plugin name (dir under which plugin is installed)
---
---@field config PluginConfig Run this after install
---
---Lazily load plugin on these keys, don't put keymaps in config then
---@field keys PluginKeys
---
---Lazily load plugin on these events
---@field events PluginEvents
---@field pattern? string|string[]

---Do vim.pack.add and load
---@param specs Spec[]
---@param packadd_opts { confirm?: boolean }
local function install(specs, packadd_opts)
    local by_name = {}
    local sources = {}

    for _, spec in ipairs(specs) do
        local name = spec.name or spec.src:match '([^/]+)$'
        by_name[name] = spec
        sources[#sources + 1] = {
            src = gh(spec.src),
            name = spec.name,
            version = spec.version,
        }
    end
    if #sources == 0 then return end

    ---Load installed plugin
    ---@param plug { spec: vim.pack.Spec, path: string }
    local function load(plug)
        ---@type Spec
        local spec = by_name[plug.spec.name]
        if not spec then return end

        local configured = false
        local setup = function()
            if configured then return end

            vim.cmd.packadd(vim.fn.escape(plug.spec.name, ' '))
            if spec.config then spec.config() end
            configured = true
        end

        if not spec.events and not spec.keys then setup() end

        if spec.events then
            vim.api.nvim_create_autocmd(spec.events, { once = true, pattern = spec.pattern, callback = setup })
        end

        if spec.keys then
            for _, k in ipairs(spec.keys) do
                local lhs, rhs, mode = k[1], k[2], k.mode or 'n'
                vim.keymap.set(mode, lhs, function()
                    if rhs then
                        setup()
                        if type(rhs) == 'function' then
                            rhs()
                        else
                            vim.api.nvim_feedkeys(rhs, 'n', false)
                        end
                    else
                        vim.keymap.del(mode, lhs)
                        setup()
                        vim.schedule(function()
                            local keys = vim.api.nvim_replace_termcodes(lhs, true, false, true)
                            vim.api.nvim_feedkeys(keys, 'm', false)
                        end)
                    end
                end, { desc = k.desc })
            end
        end
    end

    vim.pack.add(sources, {
        confirm = packadd_opts.confirm or false,
        load = load,
    })
end
---@param specs Spec[]
---@param confirm boolean|nil
M.add = function(specs, confirm) install(specs, { confirm = confirm }) end

M.gh = gh

return M
