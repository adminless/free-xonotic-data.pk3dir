CPP := cc -xc -E
QCC ?= gmqcc

PROGS_OUT ?= ..
WORKDIR ?= ../.tmp

QCCFLAGS_WATERMARK ?= $(shell git describe --tags --dirty='~')
VER = $(subst *,\*,$(QCCFLAGS_WATERMARK))
NDEBUG ?= 1
XONOTIC ?= 1
ENABLE_EFFECTINFO ?= 0
ENABLE_DEBUGDRAW ?= 0
ENABLE_DEBUGTRACE ?= 0
BUILD_MOD ?=

ifndef ZIP
	ifneq ($(shell which zip 2>/dev/null),)
		ZIP := zip -9
	endif
	ifneq ($(shell which 7z 2>/dev/null),)
		ZIP := 7z a -tzip -mx=9
	endif
	ifneq ($(shell which 7za 2>/dev/null),)
		ZIP := 7za a -tzip -mx=9
	endif
    ifndef ZIP
        $(warning "No zip / 7z / 7za in ($(PATH))")
        ZIP := : zip_not_found
    endif
endif

# Set to empty string to temporarily enable warnings when debugging
QCCFLAGS_WERROR ?= \
	-Werror

# We eventually need to get rid of these
QCCFLAGS_WTFS ?= \
	-Wno-field-redeclared

QCCDEFS ?= \
	-DXONOTIC=$(XONOTIC) \
	-DWATERMARK="$(QCCFLAGS_WATERMARK)" \
	-DNDEBUG=$(NDEBUG) \
	-DENABLE_EFFECTINFO=$(ENABLE_EFFECTINFO) \
	-DENABLE_DEBUGDRAW=$(ENABLE_DEBUGDRAW) \
	-DENABLE_DEBUGTRACE=$(ENABLE_DEBUGTRACE) \
	$(if $(BUILD_MOD), -DBUILD_MOD="$(BUILD_MOD)" -I$(BUILD_MOD), ) \
	$(QCCDEFS_EXTRA)

# -Ooverlap-locals is required
QCCFLAGS ?= \
	-std=gmqcc \
	-Ooverlap-locals \
	-O3 \
	$(QCCFLAGS_WERROR) \
	-Wall \
	$(QCCFLAGS_WTFS) \
	-flno -futf8 -fno-bail-on-werror \
	-frelaxed-switch -freturn-assignments \
	$(QCCFLAGS_EXTRA)



.PHONY: all
all: qc pk3

$(WORKDIR):
	@mkdir -p $@

.PHONY: clean
clean: | $(WORKDIR)
	$(RM) $(PROGS_OUT)/csprogs.dat
	$(RM) $(PROGS_OUT)/menu.dat
	$(RM) $(PROGS_OUT)/progs.dat
	$(RM) $(WORKDIR)/*.d
	$(RM) $(WORKDIR)/*.qc
	$(RM) $(WORKDIR)/*.txt

.PHONY: qc
qc: $(PROGS_OUT)/csprogs.dat $(PROGS_OUT)/menu.dat $(PROGS_OUT)/progs.dat

.PHONY: pk3
pk3: csprogs-$(VER).pk3





%-$(VER).pk3: $(PROGS_OUT)/%.dat
	$(eval PROG=$*)
	$(eval PK3=$(PROG)-$(VER).pk3)
	$(eval TXT=$(PROG)-$(VER).txt)
	$(eval DAT=$(PROG)-$(VER).dat)
	$(eval LNO=$(PROG)-$(VER).lno)
	@ echo "http://xonotic.org" > $(TXT)
	@ ln -f $(PROGS_OUT)/$(PROG).dat $(DAT)
	@ ln -f $(PROGS_OUT)/$(PROG).lno $(LNO)
	@ $(RM) *.pk3
	$(ZIP) $(PK3) $(TXT) $(DAT) $(LNO)
	@ $(RM) $(TXT) $(DAT) $(LNO)

QCCVERSION := $(shell cd lib && $(QCC) --version)
QCCVERSIONFILE := $(WORKDIR)/qccversion.$(shell echo ${QCCVERSION} | git hash-object --stdin)
$(QCCVERSIONFILE): | $(WORKDIR)
	@ $(RM) $(WORKDIR)/qccversion.*
	@ echo $(QCCVERSION) > $@

export WORKDIR
export CPP
export QCC
export QCCDEFS
export QCCFLAGS

$(PROGS_OUT)/csprogs.dat: client/progs.inc $(QCCVERSIONFILE) | $(WORKDIR)
	@ echo make[1]: Entering directory \`$(CURDIR)/client\'
	./tools/qcc.sh client $@ $<
-include $(WORKDIR)/client.d

$(PROGS_OUT)/progs.dat: server/progs.inc $(QCCVERSIONFILE) | $(WORKDIR)
	@ echo make[1]: Entering directory \`$(CURDIR)/server\'
	./tools/qcc.sh server $@ $<
-include $(WORKDIR)/server.d

$(PROGS_OUT)/menu.dat: menu/progs.inc $(QCCVERSIONFILE) | $(WORKDIR)
	@ echo make[1]: Entering directory \`$(CURDIR)/menu\'
	./tools/qcc.sh menu $@ $<
-include $(WORKDIR)/menu.d
