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
CXXFLAGS := -std=c++17 \
             -Wall -Wextra -Wpointer-arith -Wcast-qual \
             -Wno-missing-braces -Wempty-body \
             -Wno-error=deprecated-declarations \
             -pedantic-errors -Wno-pedantic \
             -O3
LIBS :=

# out
OUT_DIR := out

# program
PROGRAM_DIR := $(OUT_DIR)/bin
PROGRAM := $(PROGRAM_DIR)/$(PROGRAM_NAME)

# test sample dir
TEST_DIR := test

# sources
SOURCE_DIR := src
SOURCES := $(wildcard $(SOURCE_DIR)/*.cpp)
SOURCE_NAMES = $(notdir $(SOURCES))

# headers
HEADER_DIR := include
HEADER_DIR := c:/local/lib/ac-library
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

test/sample-1.in :
	python oj_helper.py d

download_sample : test/sample-1.in

.PHONY : clean
clean:
	$(RM) -r $(OUT_DIR)
	$(RM) -r $(TEST_DIR)

.PHONY : run
run: $(PROGRAM)
	$(PROGRAM) < in_001.txt

.PHONY : test
test: $(PROGRAM) test/sample-1.in
	oj test -c $(PROGRAM)

.PHONY : submit
submit: $(PROGRAM) test
	python oj_helper.py s ${SOURCE_DIR}/main.cpp
