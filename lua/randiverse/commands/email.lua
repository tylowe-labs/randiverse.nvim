local config = require("randiverse.config")
local utils = require("randiverse.commands.utils")

local M = {}

local flag_mappings = {
    c = "capitalize",
    d = "digits",
    s = "specials",
    S = "separator",
    m = "muddle-property",
}

local expected_flags = {
    ["capitalize"] = {
        bool = true,
    },
    ["digits"] = {
        bool = false,
        validator = function(s) end,
        transformer = function(s) end,
    },
    ["specials"] = {
        bool = false,
        validator = function(s) end,
        transformer = function(s) end,
    },
    ["separator"] = {
        bool = true,
    },
    ["muddle-property"] = {
        bool = false,
        validator = utils.string_is_probability,
        transformer = utils.string_to_number,
    },
    cross_flags_validator = utils.pass_through,
}

-- TODO: Probability that first/last name is substring + first/last name positions odds
local generate_username = function(flags)
    local first_name = utils.read_random_line(config.user_opts.data.ROOT .. config.user_opts.data.name.FIRST)
    local last_name = utils.read_random_line(config.user_opts.data.ROOT .. config.user_opts.data.name.LAST)

    local username_components = {}
    if math.random() < 0.7 then
        table.insert(username_components, first_name)
        table.insert(username_components, last_name)
    else
        table.insert(username_components, last_name)
        table.insert(username_components, first_name)
    end
    if flags["separator"] then
        local separators = config.user_opts.data.email.separators
        table.insert(username_components, 2, separators[math.random(#separators)])
    end

    local digit_list = config.user_opts.data.email.digits
    local special_list = config.user_opts.data.email.specials
    for _ = 1, flags["digits"] or config.user_opts.data.email.default_digits do
        table.insert(username_components, digit_list[math.random(#digit_list)])
    end
    for _ = 1, flags["specials"] or config.user_opts.data.email.default_specials do
        table.insert(username_components, special_list[math.random(#special_list)])
    end

    local chars = {}
    for char in table.concat(username_components):gmatch(".") do
        table.insert(chars, char)
    end
    for i = #chars, 1, -1 do
        if math.random() < flags["muddle-property"] or config.user_opts.data.email.default_muddle_property then
            -- TODO: don't allow separators to exist in 1 or last range!
            local j = math.random(i)
            chars[i], chars[j] = chars[j], chars[i]
        end
    end
    local username = table.concat(chars)

    if flags["capitalize"] then
        return username
    end
    return string.lower(username)
end

M.normal_random_email = function(args)
    args = args or {}
    local parsed_flags = utils.parse_command_flags(args, flag_mappings)
    local transformed_flags = utils.validate_and_transform_command_flags(expected_flags, parsed_flags)

    local username = generate_username(transformed_flags)
    local domains = config.user_opts.data.email.domains
    local tlds = config.user_opts.data.email.tlds
    return string.format("%s@%s.%s", username, domains[math.random(#domains)], tlds[math.random(#tlds)])
end

return M
