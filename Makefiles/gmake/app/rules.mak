# -*- makefile -*- Time-stamp: <2012-03-08 10:46:34 ptr>
#
# Copyright (c) 1997-1999, 2002, 2003, 2005-2007
# Petr Ovtchenkov
#
# This material is provided "as is", with absolutely no warranty expressed
# or implied. Any use is at your own risk.
#
# Permission to use or copy this software for any purpose is hereby granted
# without fee, provided the above notices are retained on all copies.
# Permission to modify the code and to distribute modified code is granted,
# provided the above notices are retained, and a notice that the code was
# modified is included with the above copyright notice.
#

dbg-shared:	$(EXTRA_PRE_DBG) $(OUTPUT_DIR_DBG) ${PRG_DBG} ${ALLPRGS_DBG} $(EXTRA_POST_DBG)

dbg-static:	$(EXTRA_PRE_DBG) $(OUTPUT_DIR_DBG) ${PRG_DBG} ${ALLPRGS_DBG} $(EXTRA_POST_DBG)

release-shared:	$(EXTRA_PRE) $(OUTPUT_DIR) ${PRG} ${ALLPRGS} $(EXTRA_POST)

release-static:	$(EXTRA_PRE) $(OUTPUT_DIR) ${PRG} ${ALLPRGS} $(EXTRA_POST)

ifndef WITHOUT_STLPORT
stldbg-shared:	$(EXTRA_PRE_STLDBG) $(OUTPUT_DIR_STLDBG) ${PRG_STLDBG} ${ALLPRGS_STLDBG} $(EXTRA_POST_STLDBG)

stldbg-static:	$(EXTRA_PRE_STLDBG) $(OUTPUT_DIR_STLDBG) ${PRG_STLDBG} ${ALLPRGS_STLDBG} $(EXTRA_POST_STLDBG)
endif

ifeq ("$(findstring $(COMPILER_NAME),bcc dmc)","")
define cpplnk_str
$(LINK.cc) $(LINK_OUTPUT_OPTION) ${START_OBJ} $(1) $(LDLIBS) ${STDLIBS} ${END_OBJ}
endef
else
ifeq ($(OSNAME),windows)
define cpplnk_str
$(LINK.cc) $(subst /,\\,${START_OBJ} $(1) ${END_OBJ}, $(LINK_OUTPUT_OPTION), $(MAP_OUTPUT_OPTION), $(LDLIBS) ${STDLIBS},,)
endef
else
define cpplnk_str
$(LINK.cc) ${START_OBJ} $(1) ${END_OBJ}, $(LINK_OUTPUT_OPTION), $(MAP_OUTPUT_OPTION), $(LDLIBS) ${STDLIBS},,
endef
endif
endif

define prog_lnk
ifeq ($${_$(1)_C_SOURCES_ONLY},)
$${$(1)_PRG}:	$$($(1)_OBJ) $$(LIBSDEP)
	$$(call cpplnk_str,$$($(1)_OBJ))

$${$(1)_PRG_DBG}:	$$($(1)_OBJ_DBG) $$(LIBSDEP)
	$$(call cpplnk_str,$$($(1)_OBJ_DBG))

ifndef WITHOUT_STLPORT
$${$(1)_PRG_STLDBG}:	$$($(1)_OBJ_STLDBG) $$(LIBSDEP)
	$$(call cpplnk_str,$$($(1)_OBJ_STLDBG))
endif
else
$${$(1)_PRG}:	$$($(1)_OBJ) $$(LIBSDEP)
	$$(LINK.c) $$(LINK_OUTPUT_OPTION) $$($(1)_OBJ) $$(LDLIBS)

$${$(1)_PRG_DBG}:	$$(OBJ_DBG) $$(LIBSDEP)
	$$(LINK.c) $$(LINK_OUTPUT_OPTION) $$($(1)_OBJ_DBG) $$(LDLIBS)

ifndef WITHOUT_STLPORT
$${$(1)_PRG_STLDBG}:	$$($(1)_OBJ_STLDBG) $$(LIBSDEP)
	$$(LINK.c) $$(LINK_OUTPUT_OPTION) $$($(1)_OBJ_STLDBG) $$(LDLIBS)
endif
endif
endef

$(foreach prg,$(PRGNAMES),$(eval $(call prog_lnk,$(prg))))

ifeq ("${_C_SOURCES_ONLY}","")
${PRG}:	$(PRI_OBJ) $(LIBSDEP)
	$(call cpplnk_str,$(PRI_OBJ))

${PRG_DBG}:	$(PRI_OBJ_DBG) $(LIBSDEP)
	$(call cpplnk_str,$(PRI_OBJ_DBG))

ifndef WITHOUT_STLPORT
${PRG_STLDBG}:	$(PRI_OBJ_STLDBG) $(LIBSDEP)
	$(call cpplnk_str,$(PRI_OBJ_STLDBG))
endif
else
${PRG}:	$(PRI_OBJ) $(LIBSDEP)
	$(LINK.c) $(LINK_OUTPUT_OPTION) $(PRI_OBJ) $(LDLIBS)

${PRG_DBG}:	$(PRI_OBJ_DBG) $(LIBSDEP)
	$(LINK.c) $(LINK_OUTPUT_OPTION) $(PRI_OBJ_DBG) $(LDLIBS)

ifndef WITHOUT_STLPORT
${PRG_STLDBG}:	$(PRI_OBJ_STLDBG) $(LIBSDEP)
	$(LINK.c) $(LINK_OUTPUT_OPTION) $(PRI_OBJ_STLDBG) $(LDLIBS)
endif
endif
