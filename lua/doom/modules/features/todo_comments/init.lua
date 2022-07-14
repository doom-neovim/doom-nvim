local todo_comments = {}

todo_comments.settings = {}

todo_comments.packages = {
  ["todo-comments.nvim"] = {
    "folke/todo-comments.nvim",
    commit = "98b1ebf198836bdc226c0562b9f906584e6c400e",
  },
}

todo_comments.configs = {}
todo_comments.configs["todo-comments.nvim"] = function()
  require("todo-comments").setup(doom.features.todo_comments.settings)
end

return todo_comments
