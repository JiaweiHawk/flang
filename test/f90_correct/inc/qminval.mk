#
# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#

########## Make rule for test qminval  ########


qminval: run
	

build:  $(SRC)/qminval.f08
	-$(RM) qminval.$(EXESUFFIX) core *.d *.mod FOR*.DAT FTN* ftn* fort.*
	@echo ------------------------------------ building test $@
	-$(CC) -c $(CFLAGS) $(SRC)/check.c -o check.$(OBJX)
	-$(FC) -c $(FFLAGS) $(LDFLAGS) $(SRC)/qminval.f08 -o qminval.$(OBJX)
	-$(FC) $(FFLAGS) $(LDFLAGS) qminval.$(OBJX) check.$(OBJX) $(LIBS) -o qminval.$(EXESUFFIX)


run: 
	@echo ------------------------------------ executing test qminval 
	qminval.$(EXESUFFIX)

verify: ;


