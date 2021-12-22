local todo_comments = {}

todo_comments.defaults = {}

todo_comments.packer_config = {}
todo_comments.packer_config["todo-comments.nvim"] = function()
  require("todo-comments").setup(doom.todo_comments)
end

return todo_comments
