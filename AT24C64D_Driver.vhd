Library IEEE ;
Use IEEE.STD_Logic_1164.All ;
Use IEEE.Numeric_STD.All ;

Entity AT24C64D_Driver Is
 Generic(
  G_Clock_Frequency_Hz : Integer := 100_000_000 
 ) ;
 Port(
  I_Clock             : In    STD_Logic ;
  I_AResetN           : In    STD_Logic ;
  I_Execute_Trig      : In    STD_Logic ;
  I_ReadHigh_WriteLow : In    STD_Logic ;
  I_Address           : In    STD_Logic_vector(15 Downto 0) ;
  I_Data              : In    STD_Logic_vector( 7 Downto 0) ;
  O_Ready             : Out   STD_Logic ;
  O_Data              : Out   STD_Logic_vector( 7 Downto 0) ;
  O_Valid             : Out   STD_Logic ;
  O_SCL               : Out   STD_Logic ;
  IO_SDA              : InOut STD_Logic
 );
End AT24C64D_Driver ;

Architecture Behavioral Of AT24C64D_Driver Is

 Constant C_Slave_Address     : STD_Logic_Vector(6 Downto 0)        := "1010000" ;
 Constant C_I2C_Frequency_Hz  : Integer                             := 1_000_000 ;
 Constant C_I2C_Period        : Integer                             := (G_Clock_Frequency_Hz/C_I2C_Frequency_Hz)/4 ;
 Signal   R_Timer             : Integer Range 0 To 500*C_I2C_Period := 0 ;
 Signal   R_Address           : STD_Logic_vector(15 Downto 0)       := (Others=>'0') ;
 Signal   R_Data              : STD_Logic_vector( 7 Downto 0)       := (Others=>'0') ;
 Signal   R_Enable            : STD_Logic                           := '0' ;
 Signal   R_ReadHigh_WriteLow : STD_Logic                           := '0' ;
 Signal   R_Valid             : STD_Logic                           := '0' ;
 Signal   R_SCL               : STD_Logic                           := '1' ;
 Signal   R_SDA_Out           : STD_Logic                           := '1' ;
 Signal   R_SDA_Direction     : STD_Logic                           := '1' ;
 Signal   R_Acknowledge       : STD_Logic                           := '1' ;
 Signal   W_SDA_In            : STD_Logic                           := '1' ;

Begin

 W_SDA_In <= IO_SDA ;
 
 Process(I_Clock,I_AResetN) Begin
  If I_AResetN='0' Then
   R_Timer             <= 0 ;
   R_Enable            <= '0' ;
   R_ReadHigh_WriteLow <= '0' ;
   R_Address           <= (Others=>'0') ;
   R_Data              <= (Others=>'0') ;
   R_SCL               <= '1' ;
   R_SDA_Out           <= '1' ;
   R_SDA_Direction     <= '1' ;
   R_Acknowledge       <= '0' ;
   R_Valid             <= '0' ;
  Elsif Rising_Edge(I_Clock) Then
   R_Valid <= '0' ;
   If I_Execute_Trig='1' And R_Enable='0' Then
    R_Enable            <= '1' ;
    R_ReadHigh_WriteLow <= I_ReadHigh_WriteLow ;
    R_Address           <= I_Address ;
    R_Data              <= I_Data ;
   End If ;
   If R_Enable='1' Then
    R_Timer <= R_Timer + 1 ;
    Case R_Timer Is
     When 0                   =>    R_SCL <='1';    R_SDA_Out<='1';    R_SDA_Direction<='1';
     When (  2*C_I2C_Period-1)=>    R_SDA_Out<='0';
     When (  4*C_I2C_Period-1)=>    R_SCL<='0';
     When (  5*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(6);
     When (  6*C_I2C_Period-1)=>    R_SCL<='1';
     When (  8*C_I2C_Period-1)=>    R_SCL<='0';
     When (  9*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(5);
     When ( 10*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 12*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 13*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(4);
     When ( 14*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 16*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 17*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(3);
     When ( 18*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 20*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 21*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(2);
     When ( 22*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 24*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 25*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(1);
     When ( 26*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 28*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 29*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(0);
     When ( 30*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 32*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 33*C_I2C_Period-1)=>    R_SDA_Out<='0';
     When ( 34*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 36*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 37*C_I2C_Period-1)=>    R_SDA_Direction<='0';
     When ( 38*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 39*C_I2C_Period-1)=>    R_Acknowledge<=R_Acknowledge Or W_SDA_In;
     When ( 40*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 41*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(15);    R_SDA_Direction<='1';
     When ( 42*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 44*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 45*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(14);
     When ( 46*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 48*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 49*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(13);
     When ( 50*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 52*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 53*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(12);
     When ( 54*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 56*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 57*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(11);
     When ( 58*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 60*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 61*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(10);
     When ( 62*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 64*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 65*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(9);
     When ( 66*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 68*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 69*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(8);
     When ( 70*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 72*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 73*C_I2C_Period-1)=>    R_SDA_Direction<='0';
     When ( 74*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 75*C_I2C_Period-1)=>    R_Acknowledge<=R_Acknowledge Or W_SDA_In;
     When ( 76*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 77*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(7);    R_SDA_Direction<='1';
     When ( 78*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 80*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 81*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(6);
     When ( 82*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 84*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 85*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(5);
     When ( 86*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 88*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 89*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(4);
     When ( 90*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 92*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 93*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(3);
     When ( 94*C_I2C_Period-1)=>    R_SCL<='1';
     When ( 96*C_I2C_Period-1)=>    R_SCL<='0';
     When ( 97*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(2);
     When ( 98*C_I2C_Period-1)=>    R_SCL<='1';
     When (100*C_I2C_Period-1)=>    R_SCL<='0';
     When (101*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(1);
     When (102*C_I2C_Period-1)=>    R_SCL<='1';
     When (104*C_I2C_Period-1)=>    R_SCL<='0';
     When (105*C_I2C_Period-1)=>    R_SDA_Out<=R_Address(0);
     When (106*C_I2C_Period-1)=>    R_SCL<='1';
     When (108*C_I2C_Period-1)=>    R_SCL<='0';
     When (109*C_I2C_Period-1)=>    R_SDA_Direction<='0';
     When (110*C_I2C_Period-1)=>    R_SCL<='1';
     When (111*C_I2C_Period-1)=>    R_Acknowledge<=R_Acknowledge Or W_SDA_In;
     When (112*C_I2C_Period-1)=>    R_SCL<='0';
     When Others=> Null ;
    End Case ;
    If R_ReadHigh_WriteLow='0' Then
     Case R_Timer Is
      When (113*C_I2C_Period-1)=>    R_SDA_Out<=R_Data(7);    R_SDA_Direction<='1';
      When (114*C_I2C_Period-1)=>    R_SCL<='1';
      When (116*C_I2C_Period-1)=>    R_SCL<='0';
      When (117*C_I2C_Period-1)=>    R_SDA_Out<=R_Data(6);
      When (118*C_I2C_Period-1)=>    R_SCL<='1';
      When (120*C_I2C_Period-1)=>    R_SCL<='0';
      When (121*C_I2C_Period-1)=>    R_SDA_Out<=R_Data(5);
      When (122*C_I2C_Period-1)=>    R_SCL<='1';
      When (124*C_I2C_Period-1)=>    R_SCL<='0';
      When (125*C_I2C_Period-1)=>    R_SDA_Out<=R_Data(4);
      When (126*C_I2C_Period-1)=>    R_SCL<='1';
      When (128*C_I2C_Period-1)=>    R_SCL<='0';
      When (129*C_I2C_Period-1)=>    R_SDA_Out<=R_Data(3);
      When (130*C_I2C_Period-1)=>    R_SCL<='1';
      When (132*C_I2C_Period-1)=>    R_SCL<='0';
      When (133*C_I2C_Period-1)=>    R_SDA_Out<=R_Data(2);
      When (134*C_I2C_Period-1)=>    R_SCL<='1';
      When (136*C_I2C_Period-1)=>    R_SCL<='0';
      When (137*C_I2C_Period-1)=>    R_SDA_Out<=R_Data(1);
      When (138*C_I2C_Period-1)=>    R_SCL<='1';
      When (140*C_I2C_Period-1)=>    R_SCL<='0';
      When (141*C_I2C_Period-1)=>    R_SDA_Out<=R_Data(0);
      When (142*C_I2C_Period-1)=>    R_SCL<='1';
      When (144*C_I2C_Period-1)=>    R_SCL<='0';
      When (145*C_I2C_Period-1)=>    R_SDA_Direction<='0';
      When (146*C_I2C_Period-1)=>    R_SCL<='1';
      When (147*C_I2C_Period-1)=>    R_Acknowledge<=R_Acknowledge Or W_SDA_In;
      When (148*C_I2C_Period-1)=>    R_SCL<='0';
      When (149*C_I2C_Period-1)=>    R_SDA_Out<='0';    R_SDA_Direction<='1';
      When (150*C_I2C_Period-1)=>    R_SCL<='1';
      When (152*C_I2C_Period-1)=>    R_SDA_Out<='1';
      When (154*C_I2C_Period-1)=>    R_Enable<='0';    R_Timer<=0;
      When Others => Null ;
     End Case ;
    Else
     Case R_Timer Is
      When (113*C_I2C_Period-1)=>    R_SDA_Out<='1';    R_SDA_Direction<='1';
      When (114*C_I2C_Period-1)=>    R_SCL<='1';
      When (115*C_I2C_Period-1)=>    R_SDA_Out<='0';
      When (116*C_I2C_Period-1)=>    R_SCL<='0';
      When (117*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(6);
      When (118*C_I2C_Period-1)=>    R_SCL<='1';
      When (120*C_I2C_Period-1)=>    R_SCL<='0';
      When (121*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(5);
      When (122*C_I2C_Period-1)=>    R_SCL<='1';
      When (124*C_I2C_Period-1)=>    R_SCL<='0';
      When (125*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(4);
      When (126*C_I2C_Period-1)=>    R_SCL<='1';
      When (128*C_I2C_Period-1)=>    R_SCL<='0';
      When (129*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(3);
      When (130*C_I2C_Period-1)=>    R_SCL<='1';
      When (132*C_I2C_Period-1)=>    R_SCL<='0';
      When (133*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(2);
      When (134*C_I2C_Period-1)=>    R_SCL<='1';
      When (136*C_I2C_Period-1)=>    R_SCL<='0';
      When (137*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(1);
      When (138*C_I2C_Period-1)=>    R_SCL<='1';
      When (140*C_I2C_Period-1)=>    R_SCL<='0';
      When (141*C_I2C_Period-1)=>    R_SDA_Out<=C_Slave_Address(0);
      When (142*C_I2C_Period-1)=>    R_SCL<='1';
      When (144*C_I2C_Period-1)=>    R_SCL<='0';
      When (145*C_I2C_Period-1)=>    R_SDA_Out<='1';
      When (146*C_I2C_Period-1)=>    R_SCL<='1';
      When (148*C_I2C_Period-1)=>    R_SCL<='0';
      When (149*C_I2C_Period-1)=>    R_SDA_Direction<='0';
      When (150*C_I2C_Period-1)=>    R_SCL<='1';
      When (151*C_I2C_Period-1)=>    R_Acknowledge<=R_Acknowledge Or W_SDA_In;
      When (152*C_I2C_Period-1)=>    R_SCL<='0';
      When (154*C_I2C_Period-1)=>    R_SCL<='1';
      When (155*C_I2C_Period-1)=>    R_Data(7)<=W_SDA_In;
      When (156*C_I2C_Period-1)=>    R_SCL<='0';
      When (158*C_I2C_Period-1)=>    R_SCL<='1';
      When (159*C_I2C_Period-1)=>    R_Data(6)<=W_SDA_In;
      When (160*C_I2C_Period-1)=>    R_SCL<='0';
      When (162*C_I2C_Period-1)=>    R_SCL<='1';
      When (163*C_I2C_Period-1)=>    R_Data(5)<=W_SDA_In;
      When (164*C_I2C_Period-1)=>    R_SCL<='0';
      When (166*C_I2C_Period-1)=>    R_SCL<='1';
      When (167*C_I2C_Period-1)=>    R_Data(4)<=W_SDA_In;
      When (168*C_I2C_Period-1)=>    R_SCL<='0';
      When (170*C_I2C_Period-1)=>    R_SCL<='1';
      When (171*C_I2C_Period-1)=>    R_Data(3)<=W_SDA_In;
      When (172*C_I2C_Period-1)=>    R_SCL<='0';
      When (174*C_I2C_Period-1)=>    R_SCL<='1';
      When (175*C_I2C_Period-1)=>    R_Data(2)<=W_SDA_In;
      When (176*C_I2C_Period-1)=>    R_SCL<='0';
      When (178*C_I2C_Period-1)=>    R_SCL<='1';
      When (179*C_I2C_Period-1)=>    R_Data(1)<=W_SDA_In;
      When (180*C_I2C_Period-1)=>    R_SCL<='0';
      When (182*C_I2C_Period-1)=>    R_SCL<='1';
      When (183*C_I2C_Period-1)=>    R_Data(0)<=W_SDA_In;
      When (184*C_I2C_Period-1)=>    R_SCL<='0';
      When (185*C_I2C_Period-1)=>    R_SDA_Out<='1';    R_SDA_Direction<='1';
      When (186*C_I2C_Period-1)=>    R_SCL<='1';
      When (188*C_I2C_Period-1)=>    R_SCL<='0';
      When (189*C_I2C_Period-1)=>    R_SDA_Out<='0';    R_SDA_Direction<='1';
      When (190*C_I2C_Period-1)=>    R_SCL<='1';
      When (192*C_I2C_Period-1)=>    R_SDA_Out<='1';
      When (194*C_I2C_Period-1)=>    R_Enable<='0';    R_Timer<=0;    R_Valid<=Not R_Acknowledge;
      When Others => Null ;
     End Case ;
    End If ;
   End If ;
   
  End If ;
 End Process ;
 
 O_Valid <= R_Valid ;
 O_Data  <= R_Data ;
 IO_SDA  <= R_SDA_Out When R_SDA_Direction='1' Else 'Z' ;
 O_SCL   <= R_SCL;
 O_Ready <= Not R_Enable ;

End Behavioral ;