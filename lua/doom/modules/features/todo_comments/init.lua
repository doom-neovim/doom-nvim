local todo_comments = {}

todo_comments.settings = {}

todo_comments.packages = {
  ["todo-comments.nvim"] = {
    "folke/todo-comments.nvim",
    commit = "8df75dbb9ddd78a378b9661f25f0b193f38f06dd",
  },
}

todo_comments.configs = {}
todo_comments.configs["todo-comments.nvim"] = function()
  require("todo-comments").setup(doom.features.todo_comments.settings)
end

return todo_comments
