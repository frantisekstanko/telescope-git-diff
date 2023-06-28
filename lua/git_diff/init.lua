local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")

local m = {}

m.modified_on_current_branch = function()
    pickers
        .new({
            initial_mode = "normal",
            results_title = "Modified on current branch",
            prompt_title = false,
            finder = finders.new_oneshot_job({
                "git",
                "diff",
                "--name-only",
                "--relative",
                "main...HEAD",
            }),
            sorter = sorters.get_fuzzy_file(),
            previewer = previewers.new_termopen_previewer({
                get_command = function(entry)
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
