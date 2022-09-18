local templates = {}
templates.setting = function(a)
  -- local x = [[ aaa]]
  return [[    new = value]]
end
templates.package = function() end
templates.config = function() end
templates.cmd = function() end
templates.autocmd = function() end
templates.bind = function() end
return templates
