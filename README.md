# telescopn-git-diff

A [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
extension that makes it easy to list all modified files on the current branch
branch, or show a commit history for the current file.

## Modified on current branch

This one opens almost instantly.

![Screenshot](https://i.imgur.com/BSsSPxb.png)

## File commit history

This one is very performant compared to other similar plugins or extensions
I could find and test. Most of them freeze neovim when used with big
repositories. This implementation works fine even with
the [Linux kernel](https://github.com/torvalds/linux).

![Screenshot](https://i.imgur.com/VQLlkK8.png)

## How to use

The extension does not perform any key bindings. You have to provide your own.

A minimal example for [lazy.nvim](https://github.com/folke/lazy.nvim) with
example key bindings:

```lua
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "frantisekstanko/telescope-git-diff" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup()
    telescope.load_extension("git_diff")
  end,
  keys = {
    {
      "<leader>m",
      function()
        require("telescope").extensions.git_diff.modified_on_current_branch({
          show_only_basenames = true,
        })
      end,
      desc = "Show modified on current branch",
    },
    {
      desc = "Commit history for current file",
      "<leader>=",
      function()
        require("telescope").extensions.git_diff.file_commit_history()
      end,
    },
  },
}
```

### Specifying the branch to diff against

If your main branch is called something other than `main`, or you want to view
the diff compared to a different branch, you can specify the branch name as
such:

```lua
function()
  local git_diff = require("telescope").extensions.git_diff
  git_diff.modified_on_current_branch({
    diff_against_branch = "dev",
  })
end,
```

### Show only basenames in the file list

This will not show the full paths in the filelist.

```lua
function()
  local git_diff = require("telescope").extensions.git_diff
  git_diff.modified_on_current_branch({
    show_only_basenames = true,
  })
end,
```

## Show commit history for a file

Example binding to show the commit history of a file. If no options are
provided, the history is shown for the current file. Otherwise, the filename
can be provided as `file_path`. This should rarely be needed.

```lua
{
  desc = "Commit history for current file",
  "<leader>=",
  function()
    local git_diff = require("telescope").extensions.git_diff
    git_diff.file_commit_history()
  end,
},
```
