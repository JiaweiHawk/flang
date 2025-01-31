#
# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#

########## Make rule for test qp07  ########


qp07: run


build:  $(SRC)/qp07.f08
	-$(RM) qp07.$(EXESUFFIX) core *.d *.mod FOR*.DAT FTN* ftn* fort.*
	@echo ------------------------------------ building test $@
	-$(CC) -c $(CFLAGS) $(SRC)/check.c -o check.$(OBJX)
	-$(FC) -c $(FFLAGS) $(LDFLAGS) $(SRC)/qp07.f08 -o qp07.$(OBJX)
	-$(FC) $(FFLAGS) $(LDFLAGS) qp07.$(OBJX) check.$(OBJX) $(LIBS) -o qp07.$(EXESUFFIX)


run:
	@echo ------------------------------------ executing test qp07
	qp07.$(EXESUFFIX)

verify: ;
