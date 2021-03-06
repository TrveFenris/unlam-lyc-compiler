# Compilers
CC := gcc
CXX := g++

# Portability variables
ifdef ComSpec
# Windows variables
PATHSEP:=\\
rm:=del
mv:=ren
md:=mkdir
else
# UNIX variables
PATHSEP:=/
rm:=/bin/rm -f
mv:=/bin/mv -f
md:=mkdir -p
endif

# Target file to compile
target=Compiler

# Includes, source, object and binaries directories #
includedirs:=include
srcdir:=src
objdir:=obj
bindir:=bin

# Includes, source, object and dependecy files #
INCLUDES := $(addprefix -I,$(includedirs))
CPPSOURCES	:= $(wildcard $(srcdir)/*.c)
CPPOBJECTS := $(CPPSOURCES:$(srcdir)/%.c=$(objdir)/%.o)
CXXSOURCES	:= $(wildcard $(srcdir)/*.cpp)
CXXOBJECTS := $(CXXSOURCES:$(srcdir)/%.cpp=$(objdir)/%.o)
DEPS := $(wildcard $(objdir)/*.d)

# Compiler and flags variables #
CPPFLAGS += $(INCLUDES)
CXXFLAGS += $(INCLUDES)

all: $(CPPOBJECTS) $(CXXOBJECTS) $(target)

$(target): %: %.y
	$(md) bin
	@echo "Compiling yacc file:" $<
	@echo "Output file:" $@
	bison -o$@.tab.c -d $<
	flex -o$@.l.c $@.l
#$(CC) $(CPPFLAGS) -w -o $(bindir)/$@ $@.tab.c $@.l.c $(CPPOBJECTS)
# Use the line below to compile with g++
	$(CXX) $(CXXFLAGS) -w -o $(bindir)/$@ $@.tab.c $@.l.c $(CXXOBJECTS) $(CPPOBJECTS)
	$(rm) $@.tab.c $@.tab.h $@.l.c

$(CPPOBJECTS): $(objdir)/%.o: $(srcdir)/%.c
	$(md) obj
	$(CC) $(CPPFLAGS) -c $(OUTPUT_OPTION) $<

$(CXXOBJECTS): $(objdir)/%.o: $(srcdir)/%.cpp
	$(md) obj
	$(CXX) $(CXXFLAGS) -c $(OUTPUT_OPTION) $<

.PHONY: clean
clean:
	$(rm) $(target)
	$(rm) $(bindir)$(PATHSEP)*.exe
	$(rm) $(objdir)$(PATHSEP)*.o
	$(rm) $(objdir)$(PATHSEP)*.d
	$(rm) *.tab.h *.tab.c *.l.c *.tab.cc *.l.cc
	$(rm) *.pyc

include $(DEPS)