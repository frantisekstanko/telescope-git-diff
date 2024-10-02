local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local previewers = require "telescope.previewers"
local devicons = require "nvim-web-devicons"

local m = {}

local file_display_name = function(file, show_only_basenames)
  local display_file_name = file

  local icon = devicons.get_icon(file, vim.fn.fnamemodify(file, ":e"), { default = true })

  if show_only_basenames then
    display_file_name = vim.fn.fnamemodify(file, ":t")
  end

  if vim.fn.filereadable(file) == 0 then
    return "D " .. icon .. " " .. display_file_name
  end

  return "  " .. icon .. " " .. display_file_name
end

local main_branch_name = function()
  vim.fn.system "git rev-parse --verify main"

  if vim.v.shell_error == 0 then
    return "main"
  end

  vim.fn.system "git rev-parse --verify master"

  if vim.v.shell_error == 0 then
    return "master"
  end

  return nil
end

m.modified_on_current_branch = function(opts)
  opts = opts or {}
  opts.diff_against_branch = opts.diff_against_branch or main_branch_name()
  opts.show_only_basenames = opts.show_only_basenames or false

  local gitFileList = vim.fn.systemlist("git diff --name-only --relative " .. opts.diff_against_branch .. "...HEAD")

  if vim.v.shell_error ~= 0 then
    print("Branch " .. opts.diff_against_branch .. " does not exist.")
    return
  end

  if vim.tbl_isempty(gitFileList) then
    print "No modified files on current branch."
    return
  end

  local telescopeResults = {}
  for _, file in ipairs(gitFileList) do
    table.insert(telescopeResults, {
      display = file_display_name(file, opts.show_only_basenames),
      value = file,
    })
  end

  pickers
    .new({
      initial_mode = "normal",
      results_title = "Modified on current branch",
      prompt_title = false,
      finder = finders.new_table {
        results = telescopeResults,
        entry_maker = function(entry)
          return {
            value = entry.value,
            display = entry.display,
            ordinal = entry.display,
          }
        end,
      },
      sorter = sorters.get_fzy_sorter(),
      previewer = previewers.new_termopen_previewer {
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
      },
    })
    :find()
end

return m
