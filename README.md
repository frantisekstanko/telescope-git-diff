# telescope-git-diff

A [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
extension that makes it easy to list all the files modified on the current
branch, i.e. "what will the pull request look like".

![Screenshot](https://i.imgur.com/Lu2G618.png)

## How to use

Minimal example for [lazy.nvim](https://github.com/folke/lazy.nvim):

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
                local git_diff = require("telescope").extensions.git_diff
                git_diff.modified_on_current_branch()
            end,
            desc = "Show modified on current branch",
        },
    },
}
```
