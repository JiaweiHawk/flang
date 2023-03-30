! RUN: %flang -O0 -c %s 2>&1 | FileCheck %s

program align
implicit none

    !dir$ align alignment
    type T1
        integer(kind=2)     :: f1
        integer(kind=4)     :: f2
    end type T1
! CHECK: F90-W-0280-Syntax error in directive ALIGN: allow int alignment only

    !dir$ align -3
    type T2
        integer(kind=2)     :: f1
        integer(kind=4)     :: f2
    end type T2
! CHECK: F90-W-0280-Syntax error in directive ALIGN: allow int alignment only

    !dir$ align 0
    type T3
        integer(kind=2)     :: f1
        integer(kind=4)     :: f2
    end type T3
! CHECK: F90-W-0280-Syntax error in directive ALIGN: allow power of 2 alignment only

    !dir$ align 3
    type T4
        integer(kind=2)     :: f1
        integer(kind=4)     :: f2
    end type T4
! CHECK: F90-W-0280-Syntax error in directive ALIGN: allow power of 2 alignment only


end program align
