!** Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
!** See https://llvm.org/LICENSE.txt for license information.
!** SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

!* Tests for runtime library MATMUL routines

program p
  use check_mod
  integer, parameter :: NbrTests = 1378

  real*16, dimension(3) :: arr1
  real*16, dimension(3, 4) :: arr2
  real*16, dimension(4) :: arr3
  real*16, dimension(4, 4) :: arr4
  real*16, dimension(0:3, -1:1) :: arr5
  real*16, dimension(-3:-1) :: arr6
  real*16, dimension(-1:2, 0:3) :: arr7
  real*16, dimension(11) :: arr20
  real*16, dimension(11) :: arr13
  real*16, dimension(11, 11) :: arr14
  real*16, dimension(2, 11) :: arr15
  real*16, dimension(389) :: arr16
  real*16, dimension(389, 387) :: arr17
  real*16, dimension(387) :: arr18
  real*16, dimension(2, 387) :: arr19

  data arr1 /0.0_16, 1.0_16, 2.0_16/
  data arr5 /0.0_16, 1.0_16, 2.0_16, 3.0_16, 4.0_16, 5.0_16,   &
             6.0_16, 7.0_16, 8.0_16, 9.0_16, 10.0_16, 11.0_16/
  data arr2 /0.0_16, 1.0_16, 2.0_16, 3.0_16, 4.0_16, 5.0_16,   &
             6.0_16, 7.0_16, 8.0_16, 9.0_16, 10.0_16, 11.0_16/
  data arr6 /0.0_16, 1.0_16, 2.0_16/
  data arr3 /0.0_16, 1.0_16, 2.0_16, 3.0_16/
  data arr4 /0.0_16, 1.0_16, 2.0_16, 3.0_16, 4.0_16, 5.0_16,   &
             6.0_16, 7.0_16, 8.0_16, 9.0_16, 10.0_16, 11.0_16, &
             12.0_16, 13.0_16, 14.0_16, 15.0_16/
  data arr7 /0.0_16, 1.0_16, 2.0_16, 3.0_16, 4.0_16, 5.0_16,   &
             6.0_16, 7.0_16, 8.0_16, 9.0_16, 10.0_16, 11.0_16, &
             12.0_16, 13.0_16, 14.0_16, 15.0_16/

  real*16 :: expect(NbrTests)
  real*16 :: results(NbrTests)

  data expect / &
        5.0_16,      14.0_16,      23.0_16,      32.0_16,       0.0_16,      14.0_16, &
       23.0_16,      32.0_16,      14.0_16,      23.0_16, &
       32.0_16,       0.0_16,       0.0_16,       5.0_16,      14.0_16,      23.0_16, &
        0.0_16,       4.0_16,       7.0_16,      10.0_16, &
        2.0_16,       5.0_16,       8.0_16,      11.0_16,       2.0_16,      11.0_16, &
       20.0_16,      29.0_16,       0.0_16,       2.0_16, &
       11.0_16,      20.0_16,       5.0_16,       8.0_16,      11.0_16,       0.0_16, &
       10.0_16,      16.0_16,      22.0_16,       0.0_16, &
        0.0_16,       2.0_16,       0.0_16,      20.0_16,       5.0_16,       0.0_16, &
       11.0_16,       0.0_16,       0.0_16,       5.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,      11.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       5.0_16,       0.0_16,      11.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       7.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,      11.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16,      19.0_16,       0.0_16, &
       31.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,      18.0_16,      12.0_16,       6.0_16,       0.0_16, &
        0.0_16,       1.0_16,       0.0_16,      19.0_16, &
        0.0_16,       4.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,      10.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16,      11.0_16,       0.0_16, &
        5.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,      11.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       7.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16,       0.0_16, &
       31.0_16,       0.0_16,      19.0_16,       0.0_16, &
        0.0_16,       0.0_16,       0.0_16,       0.0_16,      36.0_16,      72.0_16, &
      108.0_16,     144.0_16,     180.0_16,     216.0_16, &
      252.0_16,     288.0_16,     324.0_16,     360.0_16,     396.0_16,      36.0_16, &
        0.0_16,      72.0_16,       0.0_16,     108.0_16, &
        0.0_16,     144.0_16,       0.0_16,     180.0_16,       0.0_16,     216.0_16, &
        0.0_16,     252.0_16,       0.0_16,     288.0_16, &
        0.0_16,     324.0_16,       0.0_16,     360.0_16,       0.0_16,     396.0_16, &
        0.0_16,   38025.0_16,   76050.0_16,  114075.0_16, &
   152100.0_16,  190125.0_16,  228150.0_16,  266175.0_16,  304200.0_16,  342225.0_16, &
   380250.0_16,  418275.0_16,  456300.0_16,  494325.0_16, &
   532350.0_16,  570375.0_16,  608400.0_16,  646425.0_16,  684450.0_16,  722475.0_16, &
   760500.0_16,  798525.0_16,  836550.0_16,  874575.0_16, &
   912600.0_16,  950625.0_16,  988650.0_16, 1026675.0_16, 1064700.0_16, 1102725.0_16, &
  1140750.0_16, 1178775.0_16, 1216800.0_16, 1254825.0_16, &
  1292850.0_16, 1330875.0_16, 1368900.0_16, 1406925.0_16, 1444950.0_16, 1482975.0_16, &
  1521000.0_16, 1559025.0_16, 1597050.0_16, 1635075.0_16, &
  1673100.0_16, 1711125.0_16, 1749150.0_16, 1787175.0_16, 1825200.0_16, 1863225.0_16, &
  1901250.0_16, 1939275.0_16, 1977300.0_16, 2015325.0_16, &
  2053350.0_16, 2091375.0_16, 2129400.0_16, 2167425.0_16, 2205450.0_16, 2243475.0_16, &
  2281500.0_16, 2319525.0_16, 2357550.0_16, 2395575.0_16, &
  2433600.0_16, 2471625.0_16, 2509650.0_16, 2547675.0_16, 2585700.0_16, 2623725.0_16, &
  2661750.0_16, 2699775.0_16, 2737800.0_16, 2775825.0_16, &
  2813850.0_16, 2851875.0_16, 2889900.0_16, 2927925.0_16, 2965950.0_16, 3003975.0_16, &
  3042000.0_16, 3080025.0_16, 3118050.0_16, 3156075.0_16, &
  3194100.0_16, 3232125.0_16, 3270150.0_16, 3308175.0_16, 3346200.0_16, 3384225.0_16, &
  3422250.0_16, 3460275.0_16, 3498300.0_16, 3536325.0_16, &
  3574350.0_16, 3612375.0_16, 3650400.0_16, 3688425.0_16, 3726450.0_16, 3764475.0_16, &
  3802500.0_16, 3840525.0_16, 3878550.0_16, 3916575.0_16, &
  3954600.0_16, 3992625.0_16, 4030650.0_16, 4068675.0_16, 4106700.0_16, 4144725.0_16, &
  4182750.0_16, 4220775.0_16, 4258800.0_16, 4296825.0_16, &
  4334850.0_16, 4372875.0_16, 4410900.0_16, 4448925.0_16, 4486950.0_16, 4524975.0_16, &
  4563000.0_16, 4601025.0_16, 4639050.0_16, 4677075.0_16, &
  4715100.0_16, 4753125.0_16, 4791150.0_16, 4829175.0_16, 4867200.0_16, 4905225.0_16, &
  4943250.0_16, 4981275.0_16, 5019300.0_16, 5057325.0_16, &
  5095350.0_16, 5133375.0_16, 5171400.0_16, 5209425.0_16, 5247450.0_16, 5285475.0_16, &
  5323500.0_16, 5361525.0_16, 5399550.0_16, 5437575.0_16, &
  5475600.0_16, 5513625.0_16, 5551650.0_16, 5589675.0_16, 5627700.0_16, 5665725.0_16, &
  5703750.0_16, 5741775.0_16, 5779800.0_16, 5817825.0_16, &
  5855850.0_16, 5893875.0_16, 5931900.0_16, 5969925.0_16, 6007950.0_16, 6045975.0_16, &
  6084000.0_16, 6122025.0_16, 6160050.0_16, 6198075.0_16, &
  6236100.0_16, 6274125.0_16, 6312150.0_16, 6350175.0_16, 6388200.0_16, 6426225.0_16, &
  6464250.0_16, 6502275.0_16, 6540300.0_16, 6578325.0_16, &
  6616350.0_16, 6654375.0_16, 6692400.0_16, 6730425.0_16, 6768450.0_16, 6806475.0_16, &
  6844500.0_16, 6882525.0_16, 6920550.0_16, 6958575.0_16, &
  6996600.0_16, 7034625.0_16, 7072650.0_16, 7110675.0_16, 7148700.0_16, 7186725.0_16, &
  7224750.0_16, 7262775.0_16, 7300800.0_16, 7338825.0_16, &
  7376850.0_16, 7414875.0_16, 7452900.0_16, 7490925.0_16, 7528950.0_16, 7566975.0_16, &
  7605000.0_16, 7643025.0_16, 7681050.0_16, 7719075.0_16, &
  7757100.0_16, 7795125.0_16, 7833150.0_16, 7871175.0_16, 7909200.0_16, 7947225.0_16, &
  7985250.0_16, 8023275.0_16, 8061300.0_16, 8099325.0_16, &
  8137350.0_16, 8175375.0_16, 8213400.0_16, 8251425.0_16, 8289450.0_16, 8327475.0_16, &
  8365500.0_16, 8403525.0_16, 8441550.0_16, 8479575.0_16, &
  8517600.0_16, 8555625.0_16, 8593650.0_16, 8631675.0_16, 8669700.0_16, 8707725.0_16, &
  8745750.0_16, 8783775.0_16, 8821800.0_16, 8859825.0_16, &
  8897850.0_16, 8935875.0_16, 8973900.0_16, 9011925.0_16, 9049950.0_16, 9087975.0_16, &
  9126000.0_16, 9164025.0_16, 9202050.0_16, 9240075.0_16, &
  9278100.0_16, 9316125.0_16, 9354150.0_16, 9392175.0_16, 9430200.0_16, 9468225.0_16, &
  9506250.0_16, 9544275.0_16, 9582300.0_16, 9620325.0_16, &
  9658350.0_16, 9696375.0_16, 9734400.0_16, 9772425.0_16, 9810450.0_16, 9848475.0_16, &
  9886500.0_16, 9924525.0_16, 9962550.0_16,10000575.0_16, &
 10038600.0_16,10076625.0_16,10114650.0_16,10152675.0_16,10190700.0_16,10228725.0_16, &
 10266750.0_16,10304775.0_16,10342800.0_16,10380825.0_16, &
 10418850.0_16,10456875.0_16,10494900.0_16,10532925.0_16,10570950.0_16,10608975.0_16, &
 10647000.0_16,10685025.0_16,10723050.0_16,10761075.0_16, &
 10799100.0_16,10837125.0_16,10875150.0_16,10913175.0_16,10951200.0_16,10989225.0_16, &
 11027250.0_16,11065275.0_16,11103300.0_16,11141325.0_16, &
 11179350.0_16,11217375.0_16,11255400.0_16,11293425.0_16,11331450.0_16,11369475.0_16, &
 11407500.0_16,11445525.0_16,11483550.0_16,11521575.0_16, &
 11559600.0_16,11597625.0_16,11635650.0_16,11673675.0_16,11711700.0_16,11749725.0_16, &
 11787750.0_16,11825775.0_16,11863800.0_16,11901825.0_16, &
 11939850.0_16,11977875.0_16,12015900.0_16,12053925.0_16,12091950.0_16,12129975.0_16, &
 12168000.0_16,12206025.0_16,12244050.0_16,12282075.0_16, &
 12320100.0_16,12358125.0_16,12396150.0_16,12434175.0_16,12472200.0_16,12510225.0_16, &
 12548250.0_16,12586275.0_16,12624300.0_16,12662325.0_16, &
 12700350.0_16,12738375.0_16,12776400.0_16,12814425.0_16,12852450.0_16,12890475.0_16, &
 12928500.0_16,12966525.0_16,13004550.0_16,13042575.0_16, &
 13080600.0_16,13118625.0_16,13156650.0_16,13194675.0_16,13232700.0_16,13270725.0_16, &
 13308750.0_16,13346775.0_16,13384800.0_16,13422825.0_16, &
 13460850.0_16,13498875.0_16,13536900.0_16,13574925.0_16,13612950.0_16,13650975.0_16, &
 13689000.0_16,13727025.0_16,13765050.0_16,13803075.0_16, &
 13841100.0_16,13879125.0_16,13917150.0_16,13955175.0_16,13993200.0_16,14031225.0_16, &
 14069250.0_16,14107275.0_16,14145300.0_16,14183325.0_16, &
 14221350.0_16,14259375.0_16,14297400.0_16,14335425.0_16,14373450.0_16,14411475.0_16, &
 14449500.0_16,14487525.0_16,14525550.0_16,14563575.0_16, &
 14601600.0_16,14639625.0_16,14677650.0_16,14715675.0_16,   38025.0_16,       0.0_16, &
    76050.0_16,       0.0_16,  114075.0_16,       0.0_16, &
   152100.0_16,       0.0_16,  190125.0_16,       0.0_16,  228150.0_16,       0.0_16, &
   266175.0_16,       0.0_16,  304200.0_16,       0.0_16, &
   342225.0_16,       0.0_16,  380250.0_16,       0.0_16,  418275.0_16,       0.0_16, &
   456300.0_16,       0.0_16,  494325.0_16,       0.0_16, &
   532350.0_16,       0.0_16,  570375.0_16,       0.0_16,  608400.0_16,       0.0_16, &
   646425.0_16,       0.0_16,  684450.0_16,       0.0_16, &
   722475.0_16,       0.0_16,  760500.0_16,       0.0_16,  798525.0_16,       0.0_16, &
   836550.0_16,       0.0_16,  874575.0_16,       0.0_16, &
   912600.0_16,       0.0_16,  950625.0_16,       0.0_16,  988650.0_16,       0.0_16, &
  1026675.0_16,       0.0_16, 1064700.0_16,       0.0_16, &
  1102725.0_16,       0.0_16, 1140750.0_16,       0.0_16, 1178775.0_16,       0.0_16, &
  1216800.0_16,       0.0_16, 1254825.0_16,       0.0_16, &
  1292850.0_16,       0.0_16, 1330875.0_16,       0.0_16, 1368900.0_16,       0.0_16, &
  1406925.0_16,       0.0_16, 1444950.0_16,       0.0_16, &
  1482975.0_16,       0.0_16, 1521000.0_16,       0.0_16, 1559025.0_16,       0.0_16, &
  1597050.0_16,       0.0_16, 1635075.0_16,       0.0_16, &
  1673100.0_16,       0.0_16, 1711125.0_16,       0.0_16, 1749150.0_16,       0.0_16, &
  1787175.0_16,       0.0_16, 1825200.0_16,       0.0_16, &
  1863225.0_16,       0.0_16, 1901250.0_16,       0.0_16, 1939275.0_16,       0.0_16, &
  1977300.0_16,       0.0_16, 2015325.0_16,       0.0_16, &
  2053350.0_16,       0.0_16, 2091375.0_16,       0.0_16, 2129400.0_16,       0.0_16, &
  2167425.0_16,       0.0_16, 2205450.0_16,       0.0_16, &
  2243475.0_16,       0.0_16, 2281500.0_16,       0.0_16, 2319525.0_16,       0.0_16, &
  2357550.0_16,       0.0_16, 2395575.0_16,       0.0_16, &
  2433600.0_16,       0.0_16, 2471625.0_16,       0.0_16, 2509650.0_16,       0.0_16, &
  2547675.0_16,       0.0_16, 2585700.0_16,       0.0_16, &
  2623725.0_16,       0.0_16, 2661750.0_16,       0.0_16, 2699775.0_16,       0.0_16, &
  2737800.0_16,       0.0_16, 2775825.0_16,       0.0_16, &
  2813850.0_16,       0.0_16, 2851875.0_16,       0.0_16, 2889900.0_16,       0.0_16, &
  2927925.0_16,       0.0_16, 2965950.0_16,       0.0_16, &
  3003975.0_16,       0.0_16, 3042000.0_16,       0.0_16, 3080025.0_16,       0.0_16, &
  3118050.0_16,       0.0_16, 3156075.0_16,       0.0_16, &
  3194100.0_16,       0.0_16, 3232125.0_16,       0.0_16, 3270150.0_16,       0.0_16, &
  3308175.0_16,       0.0_16, 3346200.0_16,       0.0_16, &
  3384225.0_16,       0.0_16, 3422250.0_16,       0.0_16, 3460275.0_16,       0.0_16, &
  3498300.0_16,       0.0_16, 3536325.0_16,       0.0_16, &
  3574350.0_16,       0.0_16, 3612375.0_16,       0.0_16, 3650400.0_16,       0.0_16, &
  3688425.0_16,       0.0_16, 3726450.0_16,       0.0_16, &
  3764475.0_16,       0.0_16, 3802500.0_16,       0.0_16, 3840525.0_16,       0.0_16, &
  3878550.0_16,       0.0_16, 3916575.0_16,       0.0_16, &
  3954600.0_16,       0.0_16, 3992625.0_16,       0.0_16, 4030650.0_16,       0.0_16, &
  4068675.0_16,       0.0_16, 4106700.0_16,       0.0_16, &
  4144725.0_16,       0.0_16, 4182750.0_16,       0.0_16, 4220775.0_16,       0.0_16, &
  4258800.0_16,       0.0_16, 4296825.0_16,       0.0_16, &
  4334850.0_16,       0.0_16, 4372875.0_16,       0.0_16, 4410900.0_16,       0.0_16, &
  4448925.0_16,       0.0_16, 4486950.0_16,       0.0_16, &
  4524975.0_16,       0.0_16, 4563000.0_16,       0.0_16, 4601025.0_16,       0.0_16, &
  4639050.0_16,       0.0_16, 4677075.0_16,       0.0_16, &
  4715100.0_16,       0.0_16, 4753125.0_16,       0.0_16, 4791150.0_16,       0.0_16, &
  4829175.0_16,       0.0_16, 4867200.0_16,       0.0_16, &
  4905225.0_16,       0.0_16, 4943250.0_16,       0.0_16, 4981275.0_16,       0.0_16, &
  5019300.0_16,       0.0_16, 5057325.0_16,       0.0_16, &
  5095350.0_16,       0.0_16, 5133375.0_16,       0.0_16, 5171400.0_16,       0.0_16, &
  5209425.0_16,       0.0_16, 5247450.0_16,       0.0_16, &
  5285475.0_16,       0.0_16, 5323500.0_16,       0.0_16, 5361525.0_16,       0.0_16, &
  5399550.0_16,       0.0_16, 5437575.0_16,       0.0_16, &
  5475600.0_16,       0.0_16, 5513625.0_16,       0.0_16, 5551650.0_16,       0.0_16, &
  5589675.0_16,       0.0_16, 5627700.0_16,       0.0_16, &
  5665725.0_16,       0.0_16, 5703750.0_16,       0.0_16, 5741775.0_16,       0.0_16, &
  5779800.0_16,       0.0_16, 5817825.0_16,       0.0_16, &
  5855850.0_16,       0.0_16, 5893875.0_16,       0.0_16, 5931900.0_16,       0.0_16, &
  5969925.0_16,       0.0_16, 6007950.0_16,       0.0_16, &
  6045975.0_16,       0.0_16, 6084000.0_16,       0.0_16, 6122025.0_16,       0.0_16, &
  6160050.0_16,       0.0_16, 6198075.0_16,       0.0_16, &
  6236100.0_16,       0.0_16, 6274125.0_16,       0.0_16, 6312150.0_16,       0.0_16, &
  6350175.0_16,       0.0_16, 6388200.0_16,       0.0_16, &
  6426225.0_16,       0.0_16, 6464250.0_16,       0.0_16, 6502275.0_16,       0.0_16, &
  6540300.0_16,       0.0_16, 6578325.0_16,       0.0_16, &
  6616350.0_16,       0.0_16, 6654375.0_16,       0.0_16, 6692400.0_16,       0.0_16, &
  6730425.0_16,       0.0_16, 6768450.0_16,       0.0_16, &
  6806475.0_16,       0.0_16, 6844500.0_16,       0.0_16, 6882525.0_16,       0.0_16, &
  6920550.0_16,       0.0_16, 6958575.0_16,       0.0_16, &
  6996600.0_16,       0.0_16, 7034625.0_16,       0.0_16, 7072650.0_16,       0.0_16, &
  7110675.0_16,       0.0_16, 7148700.0_16,       0.0_16, &
  7186725.0_16,       0.0_16, 7224750.0_16,       0.0_16, 7262775.0_16,       0.0_16, &
  7300800.0_16,       0.0_16, 7338825.0_16,       0.0_16, &
  7376850.0_16,       0.0_16, 7414875.0_16,       0.0_16, 7452900.0_16,       0.0_16, &
  7490925.0_16,       0.0_16, 7528950.0_16,       0.0_16, &
  7566975.0_16,       0.0_16, 7605000.0_16,       0.0_16, 7643025.0_16,       0.0_16, &
  7681050.0_16,       0.0_16, 7719075.0_16,       0.0_16, &
  7757100.0_16,       0.0_16, 7795125.0_16,       0.0_16, 7833150.0_16,       0.0_16, &
  7871175.0_16,       0.0_16, 7909200.0_16,       0.0_16, &
  7947225.0_16,       0.0_16, 7985250.0_16,       0.0_16, 8023275.0_16,       0.0_16, &
  8061300.0_16,       0.0_16, 8099325.0_16,       0.0_16, &
  8137350.0_16,       0.0_16, 8175375.0_16,       0.0_16, 8213400.0_16,       0.0_16, &
  8251425.0_16,       0.0_16, 8289450.0_16,       0.0_16, &
  8327475.0_16,       0.0_16, 8365500.0_16,       0.0_16, 8403525.0_16,       0.0_16, &
  8441550.0_16,       0.0_16, 8479575.0_16,       0.0_16, &
  8517600.0_16,       0.0_16, 8555625.0_16,       0.0_16, 8593650.0_16,       0.0_16, &
  8631675.0_16,       0.0_16, 8669700.0_16,       0.0_16, &
  8707725.0_16,       0.0_16, 8745750.0_16,       0.0_16, 8783775.0_16,       0.0_16, &
  8821800.0_16,       0.0_16, 8859825.0_16,       0.0_16, &
  8897850.0_16,       0.0_16, 8935875.0_16,       0.0_16, 8973900.0_16,       0.0_16, &
  9011925.0_16,       0.0_16, 9049950.0_16,       0.0_16, &
  9087975.0_16,       0.0_16, 9126000.0_16,       0.0_16, 9164025.0_16,       0.0_16, &
  9202050.0_16,       0.0_16, 9240075.0_16,       0.0_16, &
  9278100.0_16,       0.0_16, 9316125.0_16,       0.0_16, 9354150.0_16,       0.0_16, &
  9392175.0_16,       0.0_16, 9430200.0_16,       0.0_16, &
  9468225.0_16,       0.0_16, 9506250.0_16,       0.0_16, 9544275.0_16,       0.0_16, &
  9582300.0_16,       0.0_16, 9620325.0_16,       0.0_16, &
  9658350.0_16,       0.0_16, 9696375.0_16,       0.0_16, 9734400.0_16,       0.0_16, &
  9772425.0_16,       0.0_16, 9810450.0_16,       0.0_16, &
  9848475.0_16,       0.0_16, 9886500.0_16,       0.0_16, 9924525.0_16,       0.0_16, &
  9962550.0_16,       0.0_16,10000575.0_16,       0.0_16, &
 10038600.0_16,       0.0_16,10076625.0_16,       0.0_16,10114650.0_16,       0.0_16, &
 10152675.0_16,       0.0_16,10190700.0_16,       0.0_16, &
 10228725.0_16,       0.0_16,10266750.0_16,       0.0_16,10304775.0_16,       0.0_16, &
 10342800.0_16,       0.0_16,10380825.0_16,       0.0_16, &
 10418850.0_16,       0.0_16,10456875.0_16,       0.0_16,10494900.0_16,       0.0_16, &
 10532925.0_16,       0.0_16,10570950.0_16,       0.0_16, &
 10608975.0_16,       0.0_16,10647000.0_16,       0.0_16,10685025.0_16,       0.0_16, &
 10723050.0_16,       0.0_16,10761075.0_16,       0.0_16, &
 10799100.0_16,       0.0_16,10837125.0_16,       0.0_16,10875150.0_16,       0.0_16, &
 10913175.0_16,       0.0_16,10951200.0_16,       0.0_16, &
 10989225.0_16,       0.0_16,11027250.0_16,       0.0_16,11065275.0_16,       0.0_16, &
 11103300.0_16,       0.0_16,11141325.0_16,       0.0_16, &
 11179350.0_16,       0.0_16,11217375.0_16,       0.0_16,11255400.0_16,       0.0_16, &
 11293425.0_16,       0.0_16,11331450.0_16,       0.0_16, &
 11369475.0_16,       0.0_16,11407500.0_16,       0.0_16,11445525.0_16,       0.0_16, &
 11483550.0_16,       0.0_16,11521575.0_16,       0.0_16, &
 11559600.0_16,       0.0_16,11597625.0_16,       0.0_16,11635650.0_16,       0.0_16, &
 11673675.0_16,       0.0_16,11711700.0_16,       0.0_16, &
 11749725.0_16,       0.0_16,11787750.0_16,       0.0_16,11825775.0_16,       0.0_16, &
 11863800.0_16,       0.0_16,11901825.0_16,       0.0_16, &
 11939850.0_16,       0.0_16,11977875.0_16,       0.0_16,12015900.0_16,       0.0_16, &
 12053925.0_16,       0.0_16,12091950.0_16,       0.0_16, &
 12129975.0_16,       0.0_16,12168000.0_16,       0.0_16,12206025.0_16,       0.0_16, &
 12244050.0_16,       0.0_16,12282075.0_16,       0.0_16, &
 12320100.0_16,       0.0_16,12358125.0_16,       0.0_16,12396150.0_16,       0.0_16, &
 12434175.0_16,       0.0_16,12472200.0_16,       0.0_16, &
 12510225.0_16,       0.0_16,12548250.0_16,       0.0_16,12586275.0_16,       0.0_16, &
 12624300.0_16,       0.0_16,12662325.0_16,       0.0_16, &
 12700350.0_16,       0.0_16,12738375.0_16,       0.0_16,12776400.0_16,       0.0_16, &
 12814425.0_16,       0.0_16,12852450.0_16,       0.0_16, &
 12890475.0_16,       0.0_16,12928500.0_16,       0.0_16,12966525.0_16,       0.0_16, &
 13004550.0_16,       0.0_16,13042575.0_16,       0.0_16, &
 13080600.0_16,       0.0_16,13118625.0_16,       0.0_16,13156650.0_16,       0.0_16, &
 13194675.0_16,       0.0_16,13232700.0_16,       0.0_16, &
 13270725.0_16,       0.0_16,13308750.0_16,       0.0_16,13346775.0_16,       0.0_16, &
 13384800.0_16,       0.0_16,13422825.0_16,       0.0_16, &
 13460850.0_16,       0.0_16,13498875.0_16,       0.0_16,13536900.0_16,       0.0_16, &
 13574925.0_16,       0.0_16,13612950.0_16,       0.0_16, &
 13650975.0_16,       0.0_16,13689000.0_16,       0.0_16,13727025.0_16,       0.0_16, &
 13765050.0_16,       0.0_16,13803075.0_16,       0.0_16, &
 13841100.0_16,       0.0_16,13879125.0_16,       0.0_16,13917150.0_16,       0.0_16, &
 13955175.0_16,       0.0_16,13993200.0_16,       0.0_16, &
 14031225.0_16,       0.0_16,14069250.0_16,       0.0_16,14107275.0_16,       0.0_16, &
 14145300.0_16,       0.0_16,14183325.0_16,       0.0_16, &
 14221350.0_16,       0.0_16,14259375.0_16,       0.0_16,14297400.0_16,       0.0_16, &
 14335425.0_16,       0.0_16,14373450.0_16,       0.0_16, &
 14411475.0_16,       0.0_16,14449500.0_16,       0.0_16,14487525.0_16,       0.0_16, &
 14525550.0_16,       0.0_16,14563575.0_16,       0.0_16, &
 14601600.0_16,       0.0_16,14639625.0_16,       0.0_16,14677650.0_16,       0.0_16, &
 14715675.0_16,       0.0_16,       1.0_16,       0.0_16/

  arr3 = 0.0_16
  arr3 = matmul(arr1, arr2)
  call assign_result(1, 4, arr3, results)

  arr3 = 0.0_16
  arr3(2:4) = matmul(arr1, arr2(:, 2:4))
  call assign_result(5, 8, arr3, results)

  arr3 = 0.0_16
  arr3(1:3) = matmul(arr1, arr2(:, 2:4))
  call assign_result(9, 12, arr3, results)

  arr3 = 0.0_16
  arr3(2:4) = matmul(arr1, arr2(:, 1:3))
  call assign_result(13, 16, arr3, results)

  arr3 = 0.0_16
  arr3(2:4) = matmul(arr1(1:2), arr2(1:2, 2:4))
  call assign_result(17, 20, arr3, results)

  arr3 = 0.0_16
  arr3 = matmul(arr1(1:2), arr2(2:3, :))
  call assign_result(21, 24, arr3, results)

  arr3 = 0.0_16
  arr3 = matmul(arr1(2:3), arr2(1:2, :))
  call assign_result(25, 28, arr3, results)

  arr3 = 0.0_16
  arr3(2:4) = matmul(arr1(2:3), arr2(1:2, 1:3))
  call assign_result(29, 32, arr3, results)

  arr3 = 0.0_16
  arr3(1:3) = matmul(arr1(1:2), arr2(2:3, 2:4))
  call assign_result(33, 36, arr3, results)

  arr3 = 0.0_16
  arr3(1:3) = matmul(arr1(1:3:2), arr2(1:3:2, 2:4))
  call assign_result(37, 40, arr3, results)

  arr3 = 0.0_16
  arr3(2:4:2) = matmul(arr1(2:3), arr2(1:2, 1:3:2))
  call assign_result(41, 44, arr3, results)

  arr3 = 0.0_16
  arr3(1:3:2) = matmul(arr1(1:2), arr2(2:3, 2:4:2))
  call assign_result(45, 48, arr3, results)

  arr4 = 0.0_16
  arr4(2, 1:3:2) = matmul(arr1(1:2), arr2(2:3, 2:4:2))
  call assign_result(49, 64, arr4, results)

  arr4 = 0.0_16
  arr4(1:3:2, 3) = matmul(arr1(1:2), arr2(2:3, 2:4:2))
  call assign_result(65, 80, arr4, results)

  arr7 = 0.0_16
  arr7(0, 0:2:2) = matmul(arr6(-3:-2), arr5(1:3:2, 0:1))
  call assign_result(81, 96, arr7, results)

  arr7 = 0.0_16
  arr7(-1:1:2, 2) = matmul(arr6(-2:-1), arr5(1:3:2, 0:1))
  call assign_result(97, 112, arr7, results)

  arr3 = 0.0_16
  arr3(3:1:-1) = matmul(arr1(3:1:-2), arr2(1:3:2, 2:4))
  call assign_result(113, 116, arr3, results)

  arr3 = 0.0_16
  arr3(4:2:-2) = matmul(arr1(3:2:-1), arr2(1:2, 3:1:-2))
  call assign_result(117, 120, arr3, results)

  arr4 = 0.0_16
  arr4(2, 3:1:-2) = matmul(arr1(1:2), arr2(3:2:-1, 4:2:-2))
  call assign_result(121, 136, arr4, results)

  arr4 = 0.0_16
  arr4(3:1:-2, 3) = matmul(arr1(2:1:-1), arr2(3:2:-1, 2:4:2))
  call assign_result(137, 152, arr4, results)

  arr7 = 0.0_16
  arr7(0, 2:0:-2) = matmul(arr6(-3:-2), arr5(1:3:2, 0:1))
  call assign_result(153, 168, arr7, results)

  arr7 = 0.0_16
  arr7(1:-1:-2, 2) = matmul(arr6(-1:-2:-1), arr5(3:1:-2, 0:1))
  call assign_result(169, 184, arr7, results)

  do i = 1, 11
    m2 = mod(i, 2)
    if (m2 .eq. 0) then
      arr13(i) = 0.0_16
    else
      arr13(i) = i * 1.0_16
    end if
    do j = 1, 11
      arr14(i, j) = j * 1.0_16
    end do
  end do

  arr20 = 0.0_16
  arr20 = matmul(arr13, arr14)
  call assign_result(185, 195, arr20, results)

  arr15 = 0.0_16
  arr15(1, :) = matmul(arr13, arr14)
  call assign_result(196, 217, arr15, results)

  do i = 1, 389
    m2 = mod(i, 2)
    if (m2 .eq. 0) then
      arr16(i) = 0.0_16
    else
      arr16(i) = i * 1.0_16
    end if
    do j = 1, 387
      arr17(i, j) = j * 1.0_16
    end do
  end do

  arr18 = 0.0_16
  arr18 = matmul(arr16, arr17)
  call assign_result(218, 604, arr18, results)

  arr19 = 0.0_16
  arr19(1, :) = matmul(arr16, arr17)
  call assign_result(605, 1378, arr19, results)

  call checkr16(results, expect, NbrTests)
end program

subroutine assign_result(s_idx, e_idx, arr, rslt)
  integer:: s_idx, e_idx
  real*16, dimension(1:e_idx - s_idx + 1) :: arr
  real*16, dimension(e_idx) :: rslt

  rslt(s_idx:e_idx) = arr
end subroutine
