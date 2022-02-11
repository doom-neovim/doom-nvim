local show_registers = {}

show_registers.defaults = {}

show_registers.packages = {
  ["registers.nvim"] = {
    "tversteeg/registers.nvim",
    commit = "3a8b22157ad5b68380ee1b751bd87edbd6d46471",
    opt = true,
  },
}

show_registers.configure_functions = {}

return show_registers
