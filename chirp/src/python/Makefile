include ../../../config.mk
include ../../../rules.mk

PYTHON_INSTALL_DIR = $(CCTOOLS_INSTALL_DIR)/lib/python$(CCTOOLS_PYTHON_VERSION)/site-packages

# Python always uses 'so' for its modules (even on Darwin)
CCTOOLS_DYNAMIC_SUFFIX = so
# SWIG produces code that causes a lot of warnings, so use -w to turn those off.
LOCAL_CCFLAGS = -fPIC -w $(CCTOOLS_PYTHON_CCFLAGS)
LOCAL_LINKAGE = $(CCTOOLS_PYTHON_LDFLAGS)

EXTERNAL_DEPENDENCIES = ../libchirp.a ../../../dttools/src/libdttools.a
CHIRPPYTHONSO = _CChirp.$(CCTOOLS_DYNAMIC_SUFFIX)
LIBRARIES = $(CHIRPPYTHONSO)
OBJECTS = chirp_wrap.o ../chirp_swig_wrap.o
TARGETS = Chirp.py $(LIBRARIES)

all: $(TARGETS)

Chirp.py: chirp_wrap.c CChirp.py

# The odd symlink in the following rule is necessary to overcome a problem
# in the framework search path emitted by the Python configuration on macOS.
chirp_wrap.c CChirp.py: chirp.i chirp.binding.py
	@echo "SWIG chirp.i (python)"
	@$(CCTOOLS_SWIG) -o chirp_wrap.c -python -I../../../dttools/src/ -I../ chirp.i
	@cat CChirp.py > Chirp.py
	@cat chirp.binding.py >> Chirp.py
	ln -sf /System/Library/Frameworks/Python.framework .

$(CHIRPPYTHONSO): $(OBJECTS) $(EXTERNAL_DEPENDENCIES)

clean:
	rm -f $(OBJECTS) $(TARGETS) Python.framework Chirp.py CChirp.py chirp_wrap.c *.pyc

test:

install: all
	mkdir -p $(PYTHON_INSTALL_DIR)
	cp Chirp.py $(CHIRPPYTHONSO) $(PYTHON_INSTALL_DIR)/
