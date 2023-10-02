# Requires the following project directory structure:
#  /src
#
# Following directories are generated
#  /out
#    /bin
#    /obj
#    /depend

PROGRAM_NAME := $(shell basename `readlink -f .`)

# compiler
CXX := g++
CXXFLAGS := -std=c++2b \
             -Wall -Wextra -Wpointer-arith -Wcast-qual \
             -Wno-missing-braces -Wempty-body \
             -Wno-error=deprecated-declarations \
             -Wno-c++98-compat \
             -Wno-c++98-compat-pedantic \
             -Wno-poison-system-directories \
             -pedantic-errors -pedantic \
             -O3
LIBS :=

# out
OUT_DIR := out

# program
PROGRAM_DIR := $(OUT_DIR)/bin
PROGRAM := $(PROGRAM_DIR)/$(PROGRAM_NAME)

# sources
SOURCE_DIR := src
SOURCES := $(wildcard $(SOURCE_DIR)/*.cpp)
SOURCE_NAMES = $(notdir $(SOURCES))

# headers
HEADER_DIR := include
HEADERS := $(wildcard $(HEADER_DIR)/*.h)

# objs
OBJ_DIR := $(OUT_DIR)/obj
OBJS := $(addprefix $(OBJ_DIR)/,$(SOURCE_NAMES:.cpp=.o))

# dependencies
DEPEND_DIR := $(OUT_DIR)/depend
DEPENDS := $(addprefix $(DEPEND_DIR)/,$(SOURCE_NAMES:.cpp=.depend))

.PHONY: all
all: $(DEPENDS) $(PROGRAM)
$(PROGRAM): $(OBJS)
	mkdir -p $(PROGRAM_DIR)
	$(CXX) $(CXXFLAGS) $(LIBS) $^ -o $(PROGRAM)

$(DEPEND_DIR)/%.depend: $(SOURCE_DIR)/%.cpp $(HEADERS)
	@mkdir -p $(DEPEND_DIR)
	$(CXX) $(CXXFLAGS) $(LIBS) -I$(HEADER_DIR) -MM $< > $@

$(OBJ_DIR)/%.o: $(SOURCE_DIR)/%.cpp
	@mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) $(LIBS) -I$(HEADER_DIR) -c $^ -o $@

ifneq "$(MAKECMDGOALS)" "clean"
-include $(DEPENDS)
endif

.PHONY : clean
clean:
	$(RM) -r $(OUT_DIR)

.PHONY : run
run: $(PROGRAM)
	$(PROGRAM) < in_001.txt

.PHONY : test
test: $(PROGRAM)
	./run_test.sh $(PROGRAM)
