--[[

- 1. need to turn off gpg
- 2.

        require("plenary.reload").reload_module(selection.value)

wha possibilities are there.

- disable fully
- cronjo
- solve bug
- ask dannymat if he uses neogit.


--------

`git-remotes`

walk through the command

1. test it on ghq
2. does this work with "others" repos
3. do I have to add forks to my own user?
4. fork nest.nvim > add connor remote and make sure his branch is available
5. use the local nest branch.

if this would work with the regular ghq structure and I can  just add
remotes to my own forks when they have been added to my system that would
be ideal. maybe it would be possible to use the save command to
store all remotes in the exporst list that would be the ideal thing in my
case I believe.

---------------------------------------------------------

>>> OVERRIDE CMP <<<

Yeah go for it, if you wanted you could copy the lua/doom/modules/features/lsp
to lua/user/modules/lsp and make any changes you want there.  I'm pretty sure
everything will work.

TODO: try this and just duplicate the lsp module.

OR try this according to docs:

```lua
--- config.lua

local lsp = doom.modules.lsp
local old_nvim_cmp_config_function = lsp.configs['nvim-cmp']
lsp.configs['nvim-cmp'] = function()
  old_nvim_cmp_config_function() -- Run the default config
  local cmp = require("cmp") -- direct access to plugin
end
```

---------------------------------------------------------

create helper that adds appropriate package keys.


add_package
add_telescope_extension

---------------------------------------------------------

move my binds helper to user/utils. this way I can keep all of my heplers in there.

---------------------------------------------------------
https://github.com/echasnovski/mini.nvim

what is this
------------------------------------------

see if it is possible to keep all operator changing mappings in one module and then see if it works.
otherwise it has to be done "first" but first see if that is even necessary.

------------------------------------------

what are all options defaults? possibilities?

ask connor does nest use nvim-mapper to create the binds or is this done in nvim-mapper?

look at the mapping util.

------------------------------------------

look at simon's recommndations for data analysis plugins and create a module for doom
so that it can easilly be reused again.

------------------------------------------

TEST COMMAND WITH ARGUMENTS <<<<<<<<<<
HOW IS THIS DONE IN GTD NEORG?

------------------------------------------

fix the paths module so that you update paths efficiently.

READ:
/Users/hjalmarjakobsson/code/repos/github.com/nvim-neorg/neorg/lua/neorg/modules/core/queries/native/module.lua

TODO: fix paths and formatting module. move code format to leader>code>format>all

[packer.nvim] [ERROR 12:03:15] async.lua:20: Error in coroutine: ...ite/pack/packer/start/packer.nvim/lua/packer/compile.lua:652: attempt to index a nil value

it is like a racist sexist thing to say so that is quite fucking strange
it is a turtle banging on his chest because she sais things that are so absurd that it is hard to follow her ideas sometimes.
but why are we giving them three billion dollars i am asking myself?

let's take one of the most amazing things every ou know that is actually much harder that you might think it is.

you can find a poll for anything so that is not very strange. freshly forty the puertorican rattlesnake and so good good.
so now let's have a fun show.

let's fall down and make this shit which is something that you might never understand and the reason why this is is because that
is something that you might never ever understand. draw a basketball rworded rworded as fworded. he is nworded as fuck.
how did I subsist withing are you out of your fucking mind. grind it around the screw. hexagon.

bourbon this is getting good and so that is one of the most amazing things that you can ever imagine. matt mccuskar.
and the dog that you hate. what are you talking about. how about you take the base out of your voice when you talk to big jay.
after you made the bet you saw us play. naha. talk shit and come get some. even though you are making excellent points I am
on jay and luis' side luis tried to fist fight shane in the middle of the fight. i said fucked up shit i am going to get knocked
out by luis j gomez. i am too real ass. they really did loose twelve to zero which is just pathetic.

try callong my yabai scripts from. this could become quite amazing actually and so it makes nothing into the reason why they don't do that
and so nothing can be said to you that mimics this behaior.

winter came back. that is a bit strange and it will be interesting to hear what this will do to nature and stuff. i am really going to be
so fucking incredibly interested in what that does.

this is going to be so much fun because I had never thought this would be possible to do in neovim. terminal and that is something
and what is the argument against that one. dude when i am done now this is going to be so much fucking fun and this system looks
so fucking nice. i am here to take questions from you covid didn't come from a lab.

it is all of the above so that something will happen and the thing for that is that they never ever fucking did that shit and so why
would they even look into that shit. in order to see if they have the ability to learn this type of stuff or not.

teaching farmers how to use facebook. he is trying to stay balanced but he is doing a very bad job. it makes me quite fucking sad
and so that is the thing that really makes it so you cannot really make sure this is what goes on.

so he posed this questino. i know that i will become a monster if I can only get out of this shit. it is the most important thing
ever and that is just such a help. regarding people who are closer and so he said the same thing for conny who is a truck
driver and there is such an insane piple of that and so that is one of the most insane things that you can ever do.
the country with the highest tax cap in the world sais this is something that would make sense you know and that is the reason why
they do that shit you know.

i should try the refactor plugin on the reloader module and see how it feels. maybe it would work to use it for just moving chunks

into smaller functions that would be nice and so that is something that is quite cool.

this is just so fuckying cool because niow everything is done at eye focus which means that you never have to do any kind of annoying
unergonomic movements for your neck.

you have to think right in order to hae a good outcome so you cant stop thinking about something negative.

it is when you buy shit that it makes you into something that is quite fucking retraded and the thing that is wiffed away
from the discussion and that is a thing that.

this is a bit annoying and that is going to make you feel like shit which is something that is a bit hard to expect but that side
won't ever fucking roll with this and it is abit fucking annoying

i have woken up so early. that it is really annoying and I feel absolutely destroyed and it is not very nice at all right now so
we will see what it becmoes but I am so fucking stressed out right now that it is not fun to talk about.

enough nurses so that they cannot really do the health duties that they need to do.
wimab whih monoclonal antibodies into muscles and so paxlovid and introduction into subcutanious issue.

quite disturbing and they were getting money and if you get a should you should take it because these things are quite amazing
and I have used it on a lot of patients and then you should call this number.

A. NEXT STEP IS TO USE REFACTOR PLUGIN TO MAKE THE RELOADER MODULE INTO AS SMALL FUNCTIONAL COMPONENTS AS POSSIBLE SO THAT YOU CAN REUSE
ANYTHING IF YOU'D LIKE.

B. TEST EDITORCONFIG ON DOROTHY

https://github.com/VonHeikemen/dotfiles/blob/master/my-configs/neovim/lua/conf/keymaps.lua

TODO: DEKLARERA -> TRANSFER MONEY?

- debug luasnip

-> create bindings for all new stuff.

-> fix doom settings picker

-> 2 char binds for the most important ones. (all modules)

-> make pickers for each package component.

-> all_modules_picker -> binding to call sub picker for each module component?

-> displayers -> how is the git branch displayers created > i notice that it changes colors


-> refactor all displayers into one big one?? this would make sense, since all data is tagged with a corresponding type.

this is pretty fucking cool and the thing about this is that you might never fucking need this shit and so for various reasons
this is something that you might need to do.

function sync_doom_global_to_settings()
end

--]]


