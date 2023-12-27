local config = require("randiverse.config")
local utils = require("randiverse.commands.utils")

local M = {}

local expected_flags = {
    all = {
        bool = true,
    },
    corpus = {
        bool = false,
        validator = function(s)
            if config.user_opts.data.word.corpuses[s] == nil then
                error(
                    string.format(
                        "flag 'corpus' can not accept value '%s': value must be one of the following [%s]",
                        s,
                        utils.concat_table_keys(config.user_opts.data.word.corpuses)
                    )
                )
            end
        end,
        transformer = utils.pass_through,
    },
    size = {
        bool = false,
        validator = function(s)
            if not utils.string_is_positive_integer(s) then
                error(string.format("flag 'size' can not accept value '%s': value must be a positive integer", s))
            end
        end,
        transformer = utils.string_to_integer,
    },
    cross_flags_validator = function(flags)
        if flags["all"] and flags["corpus"] then
            error("flags 'all' and 'corpus' can not be both set")
        end
    end,
}

local flag_mappings = {
    a = "all",
    c = "corpus",
    s = "size",
}

-- TODO: Validate the word corpuses to ensure it is in the English dictionary and not a name!
-- TODO: Add a means to pass multiple corpuses into word for selection (Ex: Med + Long corpuses -- probably space separated after -c flag)
-- TODO: Flag that specifies the start letter for the word! (-s [--sort])
-- TODO: Flag -p/--paragraphs to enable # of paragraphs in output text (separated by \n\n)
M.normal_random_word = function(args)
    args = args or {}
    local parsed_flags = utils.parse_command_flags(args, flag_mappings)
    local transformed_flags = utils.validate_and_transform_command_flags(expected_flags, parsed_flags)

    local corpus_mappings = config.user_opts.data.word.corpuses
    local corpus_set = {}

    if not transformed_flags["all"] and not transformed_flags["corpus"] then
        corpus_set[corpus_mappings[config.user_opts.data.word.default]] = true
    end
    if transformed_flags["all"] then
        for _, v in pairs(corpus_mappings) do
            corpus_set[v] = true
        end
    end
    if transformed_flags["corpus"] then
        corpus_set[corpus_mappings[transformed_flags["corpus"]]] = true
    end

    local corpuses = {}
    for k, _ in pairs(corpus_set) do
        table.insert(corpuses, k)
    end

    local words = {}
    for _ = 1, transformed_flags["size"] or 1 do
        table.insert(words, utils.read_random_line(config.user_opts.data.ROOT .. corpuses[math.random(#corpuses)]))
    end
    return table.concat(words, " ")
end

return M
