! Intrinsics function sign take quad precision.
program test
  use check_mod
  real(16) :: a1(5), a2(5), ares(25), aexp(25)
  real(16), parameter :: b1(5) = [huge(0.0_16), tiny(0.0_16), epsilon(0.0_16), &
                                  1.2262622222222222212_16,1.0_16]
  real(16), parameter :: b2(5) = [1.1_16, 1.564_16, 1.0_16, 1.39554_16, &
                                  1.8999666_16]
  a1 = [huge(0.0_16), tiny(0.0_16), epsilon(0.0_16), &
        1.2262622222222222212_16,1.0_16]
  a2 = [1.1_16, 1.564_16, 1.0_16, 1.39554_16, 1.8999666_16]
  aexp = [0.114752329663329016623924815520573101_16, &
          3.36210314311209350626267781732175260E-4932_16, &
          1.92592994438723585305597794258492732E-0034_16, &
          1.22626222222222222120000000000000003_16, &
          1.00000000000000000000000000000000000_16, &
          0.985247670336670983376075184479426976_16, &
          1.56399999999999999999999999999999997_16, &
          0.999999999999999999999999999999999807_16, &
          0.169277777777777778800000000000000012_16, &
          0.899966599999999999999999999999999914_16, &
          -0.114752329663329016623924815520573101_16, &
          -3.36210314311209350626267781732175260E-4932_16, &
          -1.92592994438723585305597794258492732E-0034_16, &
          -1.22626222222222222120000000000000003_16, &
          -1.00000000000000000000000000000000000_16, &
          -0.985247670336670983376075184479426976_16, &
          -1.56399999999999999999999999999999997_16, &
          -0.999999999999999999999999999999999807_16, &
          -0.169277777777777778800000000000000012_16, &
          -0.899966599999999999999999999999999914_16, &
          0.114752329663329016623924815520573101_16, &
          3.36210314311209350626267781732175260E-4932_16, &
          1.92592994438723585305597794258492732E-0034_16, &
          1.22626222222222222120000000000000003_16, &
          1.00000000000000000000000000000000000_16]

  ares(1:5) = modulo(a1,a2)

  a1 = -a1
  ares(6:10) = modulo(a1, a2)
  
  a2 = -a2
  ares(11:15) = modulo(a1, a2)
  
  a1 = -a1
  ares(16:20) = modulo(a1, a2)
  
  ares(21:25) = modulo(b1, b2)
  call checkr16(ares, aexp, 25)
end
