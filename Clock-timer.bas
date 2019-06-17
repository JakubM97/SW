$regfile = "m8def.dat"
$crystal = 4000000
$hwstack = 40
$swstack = 16
$framesize = 32

Config Lcd = 16 * 2

'Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Clear Up , Compare B Pwm = Clear Up , Prescale = 1
Config Timer1 = Pwm , Pwm = 8 , Compare B Pwm = Clear Up , Prescale = 1

Config Lcdpin = Pin , Db4 = Portc.2 , Db5 = Portc.3 , Db6 = Portc.4 , Db7 = Portc.5 , E = Portc.1 , Rs = Portc.0
Config Pinb.1 = Output
Config Timer0 = Timer , Prescale = 64

Config Debounce = 30
Debounce Pind.4 , 0 , 0
Debounce Pind.3 , 0 , 0
Debounce Pind.2 , 0 , 0
Debounce Pind.1 , 0 , 0

Portd.4 = 1                                                 'Start
Portd.3 = 1                                                 'Mode
Portd.2 = 1                                                 ' "+"
Portd.1 = 1                                                 ' "-"

On Timer0 Przerwanie_co_2ms
Led Alias Portb.1
Dim Licznik As Integer
Dim Sekundy As Byte
Dim Minuty As Byte
Dim Godziny As Byte
Dim Jasnosc As Byte
Dim Zmiana As Bit
Dim Timestop As Bit
Dim Jednostkaczas As Byte


Enable Interrupts
Enable Timer0
Timer0 = 6
Licznik = 0

Sekundy = 55
Minuty = 1
Godziny = 0

Jasnosc = 0

Jednostkaczas = 0

Cls
Cursor Off Noblink

Do
 If Minuty = 0 And Sekundy = 0 Then

 End If

 Timestop = 0
 'Licznik = 491


 If Licznik > 490 Then
   Cls
   If Sekundy > 9 Then
     Lcd "Time: "
     If Minuty > 9 Then
      Lcd Minuty + ":" + Sekundy
     Else
      Lcd "0" + Minuty + ":" + Sekundy
     End If
   End If

 If Sekundy < 10 Then
    Lcd "Time: "
    If Minuty > 9 Then
      Lcd Minuty + ":" + "0" + Sekundy
     Else
      Lcd "0" + Minuty + ":0" + Sekundy
     End If
 End If
 End If

 If Pind.3 = 0 And Pind.2 = 1 And Pind.1 = 1 Then
   If Jednostkaczas = 2 Then
      Jednostkaczas = 0
   Else
      Jednostkaczas = Jednostkaczas + 1
   End If
 End If

 If Pind.2 = 0 And Pind.1 = 1 And Pind.3 = 1 Then
   If Jednostkaczas = 0 Then
      If Sekundy > 58 Then
        Minuty = Minuty + 1
        Sekundy = 0
      Else
         Sekundy = Sekundy + 1
      End If

   Elseif Jednostkaczas = 1 Then
      Minuty = Minuty + 1

      If Minuty > 58 Then
         Godziny = Godziny + 1
         Minuty = 0
      End If

   Else
      Godziny = Godziny + 1
   End If

   Waitms 200
 End If

 If Timestop = 1 Then
   Waitms 250
 End If

Loop

End
Przerwanie_co_2ms:

 Counter0 = Counter0 + 6
 If Timestop = 0 Then
   Incr Licznik
   If Zmiana = 0 Then
      Pwm1b = Jasnosc
      Incr Jasnosc
      If Jasnosc > 160 Then
         Zmiana = 1
      End If
   Else
      Pwm1b = Jasnosc
      Decr Jasnosc
      If Jasnosc < 1 Then
         Zmiana = 0
      End If
   End If

   If Licznik = 500 Then
      Sekundy = Sekundy - 1
      Licznik = 0
   End If
   If Sekundy = 0 Then
    Sekundy = 59
    Minuty = Minuty - 1
 End If
 End If
Return
