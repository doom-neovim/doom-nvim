---[[---------------------------------------]]---
--     logging - Doom Nvim logging system      --
--              Author: NTBBloodbath           --
--              License: GPLv2                   --
---[[---------------------------------------]]---

function Log_init()
	if Doom.logging ~= 0 then
		local today = os.date('%Y-%m-%d %H:%M:%S')
		local boot_msg = '['
			.. today
			.. '] - Starting Doom Nvim '
			.. Doom.version
			.. ' ...'
		Try({
			function()
				if Doom.logging == 3 then
					print(boot_msg)
				end
				Cmd('silent !echo " " >> ' .. Doom_logs)
				Cmd(
					'silent !echo "' .. boot_msg .. '" >> ' .. Doom_logs
				)
			end,
			Catch({
				function(_)
					print('Cannot write on_start log message')
					Cmd('!touch ' .. Doom_logs)
				end,
			}),
		})
	end
end

function Log_message(msg_type, msg, level)
	--[[
         + : Doom Nvim internal
         * : External command
         ? : Prompt
         ! : Error
         !!! : CRITICAL
    --]]
	local output = ''
	if Doom.logging ~= 0 then
		-- Generate log message
		if msg_type == '!' then
			output = '[!] - ' .. msg
		elseif msg_type == '+' then
			output = '[+] - ' .. msg
		elseif msg_type == '*' then
			output = '[*] - ' .. msg
		elseif msg_type == '?' then
			output = '[?] - ' .. msg
		elseif msg_type == '!!!' then
			output = '[!!!] - ' .. msg
		end

		Try({
			function()
				if Doom.logging >= level then
					if Doom.logging == 3 then
						print(output)
					end
					Cmd(
						'silent !echo "' .. output .. '" >> ' .. Doom_logs
					)
				end
			end,
			Catch({
				function(_)
					local err_msg = '[!] - Cannot save: ' .. msg .. ''
					print(err_msg)
					Cmd(
						'silent !echo "' .. err_msg .. '" >> ' .. Doom_logs
					)
				end,
			}),
		})
	end
end

-- Dump messages to doom.log file
function Dump_messages()
	if Doom.logging ~= 0 then
		Cmd(
			'silent !echo "[---] - Dumping :messages" >> ' .. Doom_logs
		)
		Cmd('redir >> ' .. Doom_logs)
		Cmd('silent messages')
		Cmd('redir END')
		Cmd('silent !echo " " >> ' .. Doom_logs)
		Cmd(
			'silent !echo "[---] - End of dump" >> ' .. Doom_logs
		)
	end
end
