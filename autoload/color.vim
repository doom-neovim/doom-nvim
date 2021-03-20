" File: color.vim
" Author: romgrk
" Date: 15 Mar 2016
" Description: vimscript RGB/HSL color parsing
" This is mostly a transcript from a javascript color parsing module.
" !::exe [so %]
" ================================================================================
" Definitions: {{{1
" In function names:
"  • “Hex” refers to hexadecimal color format e.g. #599eff
"  • “RGB” refers to an array of numbers [r, g, b]
"                                      where   r,g,b ∈ [0, 255]
"  • “HSL” refers to an array of floats  [h, s, l]
"                                      where   h,s,l ∈ [0, 1.0]
" }}}1
" ================================================================================
" Color-format patterns:
" {{{1

let s:patterns = {}

" 6 hex-numbers, optionnal #-prefix
let s:patterns['hex']      = '\v#?(\x{2})(\x{2})(\x{2})'

" short version is strict: starting # mandatory
let s:patterns['shortHex'] = '\v#(\x{1})(\x{1})(\x{1})'

" Disabled
"let s:patterns['rgb']  = '\vrgb\s*\((\d+)\s*,(\d+)\s*,(\d+)\s*)\s*'
"let s:patterns['rgba'] = '\vrgba\s*\((\d+)\s*,(\d+)\s*,(\d+)\s*,(\d+)\s*)\s*'

" }}}1
" ================================================================================
" Functions:
" {{{1

" @params  String       string   The string to test
" @returns Boolean     [0 or 1]  if string matches: rrggbb OR #rrggbb OR #rgb
fu! color#Test (string)
    for key in keys(s:patterns)
        if a:string =~# s:patterns[key]
            return 1
        end
    endfor
    return 0
endfu

" @params (r, g, b)
" @params ([r, g, b])
" @returns String           A RGB color
fu! color#RGBtoHex (...)
    let [r, g, b] = ( a:0==1 ? a:1 : a:000 )
    let num = printf('%02x', float2nr(r)) . ''
          \ . printf('%02x', float2nr(g)) . ''
          \ . printf('%02x', float2nr(b)) . ''
    return '#' . num
endfu

" @param {String|Number} color   The color to parse
fu! color#HexToRGB (color)
    if type(a:color) == 2
        let color = printf('%x', a:color)
    else
        let color = a:color | end

    let matches = matchlist(color, s:patterns['hex'])
    let factor  = 0x1

    if empty(matches)
        let matches = matchlist(color, s:patterns['shortHex'])
        let factor  = 0x10
    end

    if len(matches) < 4
        throw 'Couldnt parse ' . string(color) . ' ' .  string(matches)
    end

    let r = str2nr(matches[1], 16) * factor
    let g = str2nr(matches[2], 16) * factor
    let b = str2nr(matches[3], 16) * factor

    return [r, g, b]
endfu


" Converts an HSL color value to RGB. Conversion formula
" adapted from http://en.wikipedia.org/wiki/HSL_color_space.
" Assumes h, s, and l are contained in the set [0, 1] and
" returns r, g, and b in the set [0, 255].
" @param   Number  h     OR     @param  Array [h, s, l]
" @param   Number  s
" @param   Number  l
" @returns Array [r, g, b]     The RGB representation
fu! color#HSLtoRGB(...) " (h, s, l)
    let [h, s, l] = ( a:0==1 ? a:1 : a:000 )

    if (s == 0.0) " achromatic
        let r = l
        let g = l
        let b = l
    else
        let q = l < 0.5 ? l * (1 + s) : l + s - l * s
        let p = 2 * l - q
        let r = color#Hue2RGB(p, q, h + 0.33333)
        let g = color#Hue2RGB(p, q, h)
        let b = color#Hue2RGB(p, q, h - 0.33333)
    end

    return [r * 255.0, g * 255.0, b * 255.0]
endfu


" @param   Number  r     OR     @param  Array [r, g, b]
" @param   Number  g
" @param   Number  b
" @returns Array [h, s, l]     The HSL representation
fu! color#RGBtoHSL(...)
    let [r, g, b] = ( a:0==1 ? a:1 : a:000 )
    let max = max([r, g, b])
    let min = min([r, g, b])

    let r   = str2float(r)
    let g   = str2float(g)
    let b   = str2float(b)
    let max = str2float(max)
    let min = str2float(min)

    let max = max / 255
    let min = min / 255
    let r = r / 255
    let g = g / 255
    let b = b / 255
    let h = str2float(0)
    let s = str2float(0)
    let l = (max + min) / 2

    if (max == min)
        let h = 0   " achromatic
        let s = 0   " achromatic
    else
        let d = max - min
        let s = (l > 0.5 ? d / (2 - max - min)
                       \ : d / (max + min)     )
        if (max == r)
            let h = (g - b) / d + (g < b ? 6 : 0)
        end
        if (max == g)
            let h = (b - r) / d + 2
        end
        if (max == b)
            let h = (r - g) / d + 4
        end
        let h = h / 6
    end

    return [h, s, l]
endfu

fu! color#Hue2RGB(...) " (p, q, t)
    let [p, q, t] = ( a:0==1 ? a:1 : a:000 )

    if(t < 0) | let t += 1 | end
    if(t > 1) | let t -= 1 | end

    if(t < 1.0/6) | return (p + (q - p) * 6.0 * t)           | end
    if(t < 1.0/2) | return (q)                               | end
    if(t < 2.0/3) | return (p + (q - p) * (2.0/3 - t) * 6.0) | end

    return p
endfu

" }}}1
" ================================================================================
" Composed functions:
" {{{1

fu! color#HexToHSL (color)
    let [r, g, b] = color#HexToRGB(a:color)
    return color#RGBtoHSL(r, g, b)
endfu

fu! color#HSLtoHex (...)
    let [h, s, l] = ( a:0==1 ? a:1 : a:000 )
    let [r, g, b] = color#HSLtoRGB(h, s, l)
    return color#RGBtoHex(r, g, b)
endfu

" @params String                 color      The color
" @params {Number|String|Float} [amount=5]  The percentage of light
fu! color#Lighten(color, ...)
    let amount = a:0 ?
                \(type(a:1) < 2 ?
                    \str2float(a:1) : a:1 )
                \: 5.0

    if(amount < 1.0)
        let amount = 1.0 + amount
    else
        let amount = 1.0 + (amount / 100.0)
    end

    let rgb = color#HexToRGB(a:color)
    let rgb = map(rgb, 'v:val * amount')
    let rgb = map(rgb, 'v:val > 255.0 ? 255.0 : v:val')
    let rgb = map(rgb, 'float2nr(v:val)')
    let hex = color#RGBtoHex(rgb)
    return hex
endfu

" @params String                 color      The color
" @params {Number|String|Float} [amount=5]  The percentage of darkness
fu! color#Darken(color, ...)
    let amount = a:0 ?
                \(type(a:1) < 2 ?
                    \str2float(a:1) : a:1 )
                \: 5.0

    if(amount < 1.0)
        let amount = 1.0 - amount
    else
        let amount = 1.0 - (amount / 100.0)
    end

    if(amount < 0.0)
        let amount = 0.0 | end


    let rgb = color#HexToRGB(a:color)
    let rgb = map(rgb, 'v:val * amount')
    let rgb = map(rgb, 'v:val > 255.0 ? 255.0 : v:val')
    let rgb = map(rgb, 'float2nr(v:val)')
    let hex = color#RGBtoHex(rgb)
    return hex
endfu

function! color#Decrease (...)
    if &background == 'light'
        return call(function('color#Lighten'), a:000)
    end
    return call(function('color#Darken'), a:000)
endfunc

function! color#Increase (...)
    if &background == 'light'
        return call(function('color#Darken'), a:000)
    end
    return call(function('color#Lighten'), a:000)
endfunc

function! color#Mix (a, b, ...)
    let amount = a:0 ? a:1 : 0.5

    let ca = color#HexToRGB(a:a)
    let cb = color#HexToRGB(a:b)

    let r = s:interpolate(ca[0], cb[0], amount)
    let g = s:interpolate(ca[1], cb[1], amount)
    let b = s:interpolate(ca[2], cb[2], amount)

    return color#RGBtoHex([r, g, b])
endfunc

function! s:interpolate (start, end, amount)
    let diff = a:end - a:start
    return a:start + (diff * a:amount)
endfunc

" }}}1

