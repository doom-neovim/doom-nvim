This is the most recent commit that I have merged 53a269f , so it is not the most recent because merging was unsuccessful.

(I am not sure exactly why merging the latest changes did not work but upon opening vim I noticed that both startup and all keybinds did not work. There was a large applyKeymaps traverse error but I will try to document that later.)

### Current Behavior:

Upon running packer compile I get following messages. It makes me a little confused since most of these binds come from doom modules, not users, and so I am wondering if I am the only one who gets them?

<details>

```vim

Mapper error : unique identifier fast_exit_n cannot be used twice
Mapper error : unique identifier write_as_n cannot be used twice
Mapper error : unique identifier save_as_n cannot be used twice
Mapper error : unique identifier exit_and_save_n cannot be used twice
Mapper error : unique identifier exit_and_save_n_1 cannot be used twice
Mapper error : unique identifier exit_and_discard_n cannot be used twice
Mapper error : unique identifier toggle_background_n cannot be used twice
Mapper error : unique identifier toggle_sigcolumn_n cannot be used twice
Mapper error : unique identifier set_indent_n cannot be used twice
Mapper error : unique identifier toggle_number_n cannot be used twice
Mapper error : unique identifier toggle_spelling_n cannot be used twice
Mapper error : unique identifier toggle_syntax_n cannot be used twice
Mapper error : unique identifier restore_session_n cannot be used twice
Mapper error : unique identifier show_hover_doc_n cannot be used twice
Mapper error : unique identifier jump_to_prev_diagnostic_n cannot be used twice
Mapper error : unique identifier jump_to_next_diagnostic_n cannot be used twice
Mapper error : unique identifier jump_to_declaration_n cannot be used twice
Mapper error : unique identifier jump_to_definition_n cannot be used twice
Mapper error : unique identifier jump_to_references_n cannot be used twice
Mapper error : unique identifier jump_to_implementation_n cannot be used twice
Mapper error : unique identifier do_code_action_n cannot be used twice
Mapper error : unique identifier jump_to_prev_diagnostic_n_1 cannot be used twice
Mapper error : unique identifier jump_to_next_diagnostic_n_1 cannot be used twice
Mapper error : unique identifier show_signature_help_n cannot be used twice
Mapper error : unique identifier rename_n cannot be used twice
Mapper error : unique identifier do_action_n cannot be used twice
Mapper error : unique identifier jump_to_type_n cannot be used twice
Mapper error : unique identifier jump_to_declaration_n_1 cannot be used twice
Mapper error : unique identifier jump_to_definition_n_1 cannot be used twice
Mapper error : unique identifier jump_to_references_n_1 cannot be used twice
Mapper error : unique identifier jump_to_implementation_n_1 cannot be used twice
Mapper error : unique identifier jump_to_prev_n cannot be used twice
Mapper error : unique identifier jump_to_next_n cannot be used twice
Mapper error : unique identifier jump_to_prev_n_1 cannot be used twice
Mapper error : unique identifier jump_to_next_n_1 cannot be used twice
Mapper error : unique identifier line_n cannot be used twice
Mapper error : unique identifier loclist_n cannot be used twice
Mapper error : unique identifier toggle_completion_n cannot be used twice
Mapper error : unique identifier terminal_n cannot be used twice
Mapper error : unique identifier toggle_wrap_n cannot be used twice
Mapper error : unique identifier commit_single_hunk_n cannot be used twice
Mapper error : unique identifier commit_current_buf_n cannot be used twice
Mapper error : unique identifier jump_to_next_n_2 cannot be used twice
Mapper error : unique identifier jump_to_next_n_3 cannot be used twice

```

</details>

### Expected Behavior:
<!-- A concise description of what you expected to happen. -->

### Steps To Reproduce:
<!--
Example: steps to reproduce the behavior:
1. In this environment...
2. With this config...
3. Run '...'
4. See error...
-->

### Logs

<details>
<summary>Check Health Output</summary>

<!-- Run `:checkhealth` and paste output here ** -->

</details>

<details>
<summary>Doom Report Output</summary>

<!-- Run `:DoomReport` and copy the contents of `~/.local/share/nvim/doom_report.md` -->

</details>

### Anything else:
<!--
Links? References? Screenshots? Anything that will give us more context about the issue that you are encountering!
-->

