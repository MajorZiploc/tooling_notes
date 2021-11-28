# basic form of rules in Make
# target: dependencies
# 	commands
#
# make is indent sensitive
#
# Variables: more like basic text substitution. can sub of targets, dependencies, commands, and other variables
# 	all upper case
#
# $(ELE) to expand the variable to its value
# $() also operators on make functions and primitives like:
# 	foreach
#     $(foreach ELE,$(ELES),body here operating on $(ELE))
# 	patsubst (string substitution by glob like pattern): this will not modify the ELE_TO_DO_THE_REPLACE_ON variable, just return a new string
# 		$(patsubst %search_pattern%,%replace_pattern%,$(ELE_TO_DO_THE_REPLACE_ON))
# 	wildcard
# 	info
# 		$(info I will be printed onto the screen)
#
# Wildcard:
# 	% just like sql
#
# Special vars:
# 	used in commands section of a rule:
#	 		$@: refers to the target's evaluated value (target does not have to be hardcoded text, can be made of variables and basic regex patterns aswell)
# 		$^: refers to the dependencies's evaluated value (dependencies does not have to be hardcoded text, can be made of variables and basic regex patterns aswell)
# 		$< some sort of subset of $^
#
# Silence outputing the command being run in the commands section:
# 	Prefix the command with an @
# 	Example:
# 		@ls
# 			ls will not be printed but the output of the command will be output like normal
#
# dependencies section can also be used to call make rules from the same file
# Example:
# 	distribute: clean
# 		tar zcvf dist.tgz *
# distribute will go to satify the dependencies, for which it goes to satify clean which will remove derived files
#
# TODO: take notes on PHONY and with '- include' means
#
# Makefile can also contain project util commands
# Example:
#	 diff:
#			$(info The status of the repository, and the volume of per-file changes:)
#			@git status
#			@git diff --stat
#
#
BINARY=bin
CODEDIRS=. lib
INCDIRS=. ./include/ # can be list. is a list of 2 dirs in this case

CC=gcc
OPT=-O0
# generate files that encode make rules for the .h dependencies
DEPFLAGS=-MP -MD
# automatically add the -I onto each include directory
CFLAGS=-Wall -Wextra -g $(foreach D,$(INCDIRS),-I$(D)) $(OPT) $(DEPFLAGS)

# for-style iteration (foreach) and regular expression completions (wildcard)
CFILES=$(foreach D,$(CODEDIRS),$(wildcard $(D)/*.c))
# regular expression replacement
OBJECTS=$(patsubst %.c,%.o,$(CFILES))
DEPFILES=$(patsubst %.c,%.d,$(CFILES))

all: $(BINARY)

ls:
	@ls

$(BINARY): $(OBJECTS)
	$(CC) -o $@ $^

# only want the .c file dependency here, thus $< instead of $^.
#
%.o:%.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -rf $(BINARY) $(OBJECTS) $(DEPFILES)

# shell commands are a set of keystrokes away
distribute: clean
	tar zcvf dist.tgz *

# @ silences the printing of the command
# $(info ...) prints output
diff:
	$(info The status of the repository, and the volume of per-file changes:)
	@git status
	@git diff --stat

# include the dependencies
-include $(DEPFILES)

# add .PHONY so that the non-targetfile - rules work even if a file with the same name exists.
.PHONY: all clean distribute diff
