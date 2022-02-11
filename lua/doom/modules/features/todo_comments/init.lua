local todo_comments = {}

todo_comments.defaults = {}

todo_comments.packages = {
  ["todo-comments.nvim"] = {
    "folke/todo-comments.nvim",
    commit = "98b1ebf198836bdc226c0562b9f906584e6c400e",
    event = "ColorScheme",
  },
}



todo_comments.configure_functions = {}
todo_comments.configure_functions["todo-comments.nvim"] = function()
  require("todo-comments").setup(doom.todo_comments)
end

return todo_comments
