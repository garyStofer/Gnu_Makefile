MAKEFLAGS += --no-builtin-rules  #black magic removal
# Note: 
# If the .d (dependency) files are manually removed the dependencies for include files will not
# get picked up unless there is a change in the .c file or until the next "make clean" is executed.

BUILD_Target = MyProg			# The name of the executable to build -- it will end up in the working directory 

OBJ_dir = ./obj/
SRC_dir =  ./src/
INC_dirs = ./incl/ ./src/

# Following are the search paths for prerequisites 
vpath %.h $(INC_dirs)		# Include file search path includes the source path  -- This should also be conveyed to the complile rule
vpath %.c $(SRC_dir)
#vpath %.d $(OBJ_dir)

# Add a prefix to INC_DIRS to add the "-I" compile flag 
INC_FLAGS := $(addprefix -I,$(INC_dirs))
CPPFLAGS := $(INC_FLAGS) -MMD -MP		#-MMD and -MP generates the .d files when a .c file is compiled

# Manually entering the obj targets
#OBJfiles := sub.o main.o	
#OBJECTS := $(patsubst %, $(OBJ_dir)%, $(OBJfiles))	# Creates the object target list in the OBJ_dir folder

#Automatically scanning for source files and creating .o targets from .c files found
# create object target list by searching for .c files in the source path and then  switch .c with .o and substitute the obj path for the src 
SRC := $(shell find $(SRC_dir) -name "*.c")
OBJECTS := $(subst $(SRC_dir),$(OBJ_dir),$(SRC:.c=.o))

# String substitution (suffix version without %).
# As an example, ./build/hello.cpp.o turns into ./build/hello.cpp.d
DEPS := $(OBJECTS:.o=.d)

	
#####   First Target -- This is what gets built by default #####
$(BUILD_Target) :$(OBJECTS) 	# This will drive the creation of the .o files in the OBJdir for the prerequisites 
	@#echo "$@ link rule"
	$(CC) $(LDFLAGS) $(TARGET_ARCH) $^ $(LOADLIBES) $(LDLIBS) -o $@


# the compile rule for the prerequisits of the final target -- 
$(OBJ_dir)%.o : %.c									# pattern rule picks up the .c as a pre-req for a .o
	@#echo "MY pattern rule .c to .o via OBJ_dir"
	@mkdir -p '$(@D)'
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@	


.PHONY: clean
clean:
	@echo cleaning $(OBJ_dir)
	@rm -rf $(OBJ_dir)			# removing all of the OBJS forces a complete re-compile / re-link
	@rm -f $(BUILD_Target)		# just for good measure remove the exe as well 

# see automatic generation via -MMD -MP and include $(DEPS) below
-include $(DEPS


# some built in default variables from make -- as displayed by make -p
#LINK.c =  														% : %c
#$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH)  		$^ $(LOADLIBES) $(LDLIBS) -o $@

#LINK.o =  														% : %.o
# $(CC) $(LDFLAGS) $(TARGET_ARCH) 								$^ $(LOADLIBES) $(LDLIBS) -o $@

#COMPILE.c =  													%.o : %.c  
#$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c 					$(OUTPUT_OPTION) $<


# Include the .d makefiles. The - at the front suppresses the errors of missing
# Makefiles. Initially, all the .d files will be missing, and we don't want those
# errors to show up.

#some example dependencies 
# The internal dependencies for the various object targets  No need to specify the .c file here, it gets picked up by the compile pattern rule
# This should get generated by the compiler and then included as a seperate file -- Note that the $(OBJ_dir) path has to be pre-pended 
#$(OBJ_dir)main.o:min.h max.h		# no need to specify the .c file, it gets picked up by the %.o : %.c pattern rule
#$(OBJ_dir)main.o:defs.h			# add one more dependency -- this one is found in the second vpath entry for .h
#$(OBJ_dir)sub.o: defs.h			# this indicates that def.h is a prerequisit for sub.o file only
# example of multiple targets depending on the same pre-req
#$(OBJ_dir)main.o $(OBJ_dir)/sub.o : defs.h	# this indicates that def.h is a prerequisit for both .o files 

)