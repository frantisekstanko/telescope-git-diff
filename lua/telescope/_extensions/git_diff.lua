local git_diff = require "git_diff"

return require("telescope").register_extension {
  exports = {
    modified_on_current_branch = git_diff.modified_on_current_branch,
    file_commit_history = git_diff.file_commit_history,
  },
}
