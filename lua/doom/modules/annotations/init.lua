local annotations = {}

annotations.defaults = {
  enabled = true,
  languages = {
	  lua = {
	    template = {
        annotation_convention = "ldoc",
		  },
    },
	},
}

annotations.packer_config = {}
annotations.packer_config["neogen"] = function()
  require('neogen').setup(doom.annotations)
end

return annotations
