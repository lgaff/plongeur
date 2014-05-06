with VGA.Text_Mode;
with Kernel.ASCII; use Kernel.ASCII;
with Kernel.Utilities; use Kernel.Utilities;

package body Text_Console is
   procedure Put (Str : in String) is
   begin
      VGA.Text_Mode.Write (Str);
   end Put;
   procedure Put (C : in Character) is
      Buf : String (1 .. 1);
   begin
      Buf (1) := C;
      VGA.Text_Mode.Write (Buf);
   end Put;
   procedure Put (Num : in Integer;
                  Base : in Integer := Decimal) is
      Buffer : array (0 .. 11) of Integer := (others => 16);
      Position : Integer := 11;
      Tmp_Num : Integer := Num;
   begin
      if Tmp_Num = 0 then
         Put (Number_Symbols (1));
      end if;
      while Tmp_Num > 0 loop
         Buffer (Position) := Tmp_Num mod Base;
         Tmp_Num  := (Tmp_Num - Buffer (Position)) / Base;
         Position := Position - 1;
      end loop;
      for Index in Position .. Buffer'Last loop
         if Buffer (Index) < 16 then
            Put (Number_Symbols (Buffer (Index) + 1));
         end if;
      end loop;
   end Put;

   procedure Put (Num : in Interfaces.Unsigned_32;
                  Base : in Integer := Hexadecimal) is
   begin
      Put (To_Integer (Num), Base);
   end Put;

   procedure Put (Num : in Interfaces.Unsigned_64;
                  Base : in Integer := Hexadecimal) is
      Parts : constant Double_Double := To_Double_Double (Num);
   begin
      if Parts.High_Double > 0 then
         Put (Parts.High_Double, Base);
         Put (" ");
      end if;
      Put (Parts.Low_Double, Base);
   end Put;

   procedure Put_Line is
   begin
      Put (FF);
   end Put_Line;
   procedure Put_Line (Str : in String) is
   begin
      Put (Str & FF);
   end Put_Line;
   procedure Put_Line (Num : in Integer;
                  Base : in Integer := Decimal) is
   begin
      Put (Num, Base);
      Put_Line;
   end Put_Line;
end Text_Console;