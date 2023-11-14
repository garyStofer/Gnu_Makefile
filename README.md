# Gnu_Makefile
Simple Makefile with automatic target and dependency creation from .c files found in a specified source directory tree

Can be used as a general template by modifying the following variables:

+  Build_target -- The executable. If no relative path is given it will end up in the working directory where make was started from
+  OBJ_dir      -- a directory where the compile output (.o and .d) files will be placed 
+  SRC_dir      -- single or multiple directory(ies) where .c source files are searched in.  Sub directories will be transcended 
+  INC_dirs     -- single or multiple directory(ies) where include files are to be searched for by the compiler 

Uses compiler options -MMD and -MP to create .d dependency files along with .o object files when a .c file is created. Note that if 
the .d files are manually removed after they have been created the dependencies to the .h files will not be in effect until either 
the associated .c file is edited or a make clean is executed. I.e. the .d files are not listed as pre-reqs for the .o files. This is
in order to keep the makefile simple and concise.
