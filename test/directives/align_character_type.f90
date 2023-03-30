! RUN: %flang -O0 -S -emit-llvm %s -o - | FileCheck %s

! CHECK: %struct[[BLOCK1:_module_align_character_[0-9]+_]] = type <{ [138 x i8] }
! CHECK: @[[BLOCK1]] = common global %struct[[BLOCK1]] zeroinitializer, align 512

module module_align_character
implicit none

    !dir$ align 128
    character(len=10)   :: v1

    !dir$ align 128
    character(len=10)   :: v2

    interface
        module subroutine module_interface_subroutine()
        end subroutine module_interface_subroutine
    end interface

end module module_align_character

submodule (module_align_character) submodule_align_character

    contains
    module subroutine module_interface_subroutine()

        !dir$ align 256
        character(len=10)   :: v3
! CHECK:    %[[V3:v3_[0-9]+]] = alloca [10 x i8], align 256

        !dir$ align 256
        character(len=10)   :: v4
! CHECK:    %[[V4:v4_[0-9]+]] = alloca [10 x i8], align 256

        v3 = "101"
! CHECK:      store volatile i64 %{{[0-9]+}}, ptr %[[V3]], align

        v4 = "102"
! CHECK:      store volatile i64 %{{[0-9]+}}, ptr %[[V4]], align

    end subroutine module_interface_subroutine
end submodule submodule_align_character



program align
use module_align_character
implicit none

    !dir$ align 512
    character(len=10)   :: v5
! CHECK:    %[[V5:v5_[0-9]+]] = alloca [10 x i8], align 512

    !dir$ align 512
    character(len=10)   :: v6
! CHECK:    %[[V6:v6_[0-9]+]] = alloca [10 x i8], align 512

    v5 = "201"
! CHECK:      store volatile i64 %{{[0-9]+}}, ptr %[[V5]], align

    v6 = "202"
! CHECK:      store volatile i64 %{{[0-9]+}}, ptr %[[V6]], align

    v1 = "81"
! CHECK:      store volatile i64 %{{[0-9]+}}, ptr @[[BLOCK1]], align

    v2 = "82"
! CHECK:      %[[TEMP:[0-9]+]] = getelementptr i8, ptr @[[BLOCK1]], i64 512
! CHECK:      store volatile i64 %{{[0-9]+}}, ptr %[[TEMP]], align

end program align


subroutine subroutine_align()

    !dir$ align 1024
    character(len=10)   :: v7
! CHECK:    %[[V7:v7_[0-9]+]] = alloca [10 x i8], align 1024

    !dir$ align 1024
    character(len=10)   :: v8
! CHECK:    %[[V8:v8_[0-9]+]] = alloca [10 x i8], align 1024

    v7 = "401"
! CHECK:      store volatile i64 %{{[0-9]+}}, ptr %[[V7]], align

    v8 = "402"
! CHECK:      store volatile i64 %{{[0-9]+}}, ptr %[[V8]], align

    return
end subroutine subroutine_align


function function_align()

    !dir$ align 2048
    character(len=10)   :: v9
! CHECK:    %[[V9:v9_[0-9]+]] = alloca [10 x i8], align 2048

    !dir$ align 2048
    character(len=10)   :: v10
! CHECK:    %[[V10:v10_[0-9]+]] = alloca [10 x i8], align 2048

    v9 = "801"
! CHECK:      store volatile i64 %{{[0-9]+}}, ptr %[[V9]], align

    v10 = "802"
! CHECK:      store volatile i64 %{{[0-9]+}}, ptr %[[V10]], align

    return
end function function_align
