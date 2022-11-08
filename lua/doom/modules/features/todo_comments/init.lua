local DoomModule = require('doom.modules').DoomModule

---@toc doom.features.todo_comments
---@text # Todo Comments
---
--- Adds the ability to generate todo_comments from function, class or variable
--- signatures.
---
--- ![](https://user-images.githubusercontent.com/292349/118135272-ad21e980-b3b7-11eb-881c-e45a4a3d6192.png)
---

local todo_comments = DoomModule.new("todo_comments")

todo_comments.settings = {}

---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "features.todo_comments")
todo_comments.packages = {
  ["todo-comments.nvim"] = {
    "folke/todo-comments.nvim",
    commit = "8df75dbb9ddd78a378b9661f25f0b193f38f06dd",
  },
}
---minidoc_afterlines_end

todo_comments.configs = {}
todo_comments.configs["todo-comments.nvim"] = function()
  require("todo-comments").setup(doom.features.todo_comments.settings)
end

return todo_comments
