---[[------------------------]]---
--       COLOR UTILITIES        --
---]]------------------------[[---

local vim = vim

-------------------------------------------------------------------------------
-- Functions:
-- {{{1

-- Convert RGB to Hex color.
-- @param r Red value
-- @param g Green value
-- @param b Blue value
-- @return HEX color, e.g. '#1E1E1E'
function RGB_to_Hex(r, g, b)
	return '#' .. string.format('%02X%02X%02X', r, g, b)
end

-- Convert Hex to RGB color.
-- @param color HEX color
-- @return RGB color, e.g. {30, 30, 30}
function Hex_to_RGB(color)
	color = color:gsub('#', '')
	return {
		tonumber('0x' .. string.sub(color, 1, 2)),
		tonumber('0x' .. string.sub(color, 3, 4)),
		tonumber('0x' .. string.sub(color, 5, 6)),
	}
end

-- Convert HUE to RGB
function Hue_to_RGB(p, q, t)
	if t < 0 then
		t = t + 1
	end
	if t > 1 then
		t = t - 1
	end

	if t < (1.0 / 6) then
		return (p + (q - p) * 6.0 * t)
	end
	if t < (1.0 / 2) then
		return q
	end
	if t < (2.0 / 3) then
		return (p + (q - p) * 2.0 / 3 - t) * 6.0
	end

	return p
end

-- Convert HSL to RGB color.
function HSL_to_RGB(h, s, l)
	local r = 0
	local g = 0
	local b = 0
	-- achromatic
	if s == 0.0 then
		r = l
		g = l
		b = l
	else
		local q = l < 0.5 and l * (1 + s) or l + s - l * s
		local p = 2 * l - q
		r = Hue_to_RGB(p, q, h + 0.33333)
		g = Hue_to_RGB(p, q, h)
		b = Hue_to_RGB(p, q, h - 0.33333)
	end

	return {
		r * 255.0,
		g * 255.0,
		b * 255.0,
	}
end

-- Convert RGB to HSL color.
-- @param red Red value
-- @param green Green value
-- @param blue Blue value
function RGB_to_HSL(red, green, blue)
	local r = red / 255
	local g = green / 255
	local b = blue / 255
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)

	local h = 0.0
	local s = 0.0
	local l = (max + min) / 2

	if max == min then
		h = 0 -- achromatic
		s = 0 -- achromatic
	else
		local d = max - min
		s = (l > 0.5 and d / (2 - max - min) or d / (max + min))

		if max == r then
			h = (g - b) / d + (g < b and 6 or 0)
		end
		if max == g then
			h = (b - r) / d + 2
		end
		if max == b then
			h = (r - g) / d + 4
		end
		h = h / 6
	end

	return { h, s, l }
end

-- 1}}}
-------------------------------------------------------------------------------
-- Composed functions:
-- {{{1

function Hex_to_HSL(color)
	local r, g, b = Hex_to_RGB(color)
	return RGB_to_HSL(r, g, b)
end

function HSL_to_Hex(h, s, l)
	local r, g, b = HSL_to_RGB(h, s, l)
	return RGB_to_Hex(r, g, b)
end

function Lighten(color, percentage)
	local amount = percentage == nil and 5.0 or percentage

	if amount < 1.0 then
		amount = 1.0 + amount
	else
		amount = 1.0 + (amount / 100.0)
	end

	-- Let's pass amount variable to Neovim so we can use
	-- the Neovim map function
	vim.g.amount = amount

	local rgb = Hex_to_RGB(color)
	rgb = vim.fn.map(rgb, 'v:val * amount')
	-- Let's delete the g:amount variable since we don't need it anymore
	vim.cmd('unlet g:amount')

	rgb = vim.fn.map(rgb, 'v:val > 255.0 ? 255.0 : v:val')
	rgb = vim.fn.map(rgb, 'float2nr(v:val)')
	local hex = RGB_to_Hex(rgb[1], rgb[2], rgb[3])

	return hex
end

function Darken(color, percentage)
	local amount = percentage == nil and 5.0 or percentage

	if amount < 1.0 then
		amount = 1.0 - amount
	else
		amount = 1.0 - (amount / 100.0)
	end
	if amount < 0.0 then
		amount = 0.0
	end

	-- Let's pass amount variable to Neovim so we can use
	-- the Neovim map function
	vim.g.amount = amount

	local rgb = Hex_to_RGB(color)
	rgb = vim.fn.map(rgb, 'v:val * amount')
	-- Let's delete the g:amount variable since we don't need it anymore
	vim.cmd('unlet g:amount')

	rgb = vim.fn.map(rgb, 'v:val > 255.0 ? 255.0 : v:val')
	rgb = vim.fn.map(rgb, 'float2nr(v:val)')
	local hex = RGB_to_Hex(rgb[1], rgb[2], rgb[3])

	return hex
end

local function interpolate(start, _end, amount)
	local diff = _end - start
	return start + (diff * amount)
end

function Mix(first, second, percentage)
	local amount = percentage == nil and 0.0 or percentage

	local first_rgb = Hex_to_RGB(first)
	local second_rgb = Hex_to_RGB(second)

	local r = interpolate(first_rgb[1], second_rgb[1], amount)
	local g = interpolate(first_rgb[2], second_rgb[2], amount)
	local b = interpolate(first_rgb[3], second_rgb[3], amount)

	return RGB_to_Hex(r, g, b)
end
-- 1}}}
