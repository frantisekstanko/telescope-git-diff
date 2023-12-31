local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")

local m = {}

local file_display_name = function(file)
    if vim.fn.filereadable(file) == 0 then
        return "D " .. file
    end

    return "  " .. file
end

m.modified_on_current_branch = function()
    local gitFileList =
        vim.fn.systemlist("git diff --name-only --relative main...HEAD")

    if vim.tbl_isempty(gitFileList) then
        print("No modified files on current branch.")
        return
    end

    local telescopeResults = {}
    for _, file in ipairs(gitFileList) do
        table.insert(telescopeResults, {
            display = file_display_name(file),
            value = file,
        })
    end

    pickers
        .new({
            initial_mode = "normal",
            results_title = "Modified on current branch",
            prompt_title = false,
            finder = finders.new_table({
                results = telescopeResults,
                entry_maker = function(entry)
                    return {
                        value = entry.value,
                        display = entry.display,
                        ordinal = entry.display,
                    }
                end,
            }),
            sorter = sorters.get_fzy_sorter(),
            previewer = previewers.new_termopen_previewer({
                get_command = function(entry)
                    if vim.fn.filereadable(entry.value) == 0 then
                        return { "echo", "File was deleted." }
                    end

                    return {
                        "git",
                        "diff",
                        "--relative",
                        "main",
                        entry.value,
                    }
                end,
            }),
        })
        :find()
end

return m
