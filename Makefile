###
### Variables
###
ANSIBLE_VERSION=2.5


###
### Default
###
help:
	@printf "%s\n\n" "Available commands"
	@printf "%s\n"   "make lint             Lint source files"
	@printf "%s\n"   "make help             Show help"

lint:
	yamllint .
