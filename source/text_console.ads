package Text_Console is

   Binary : constant Integer := 2;
   Octal : constant Integer := 8;
   Decimal : constant Integer := 10;
   Hexadecimal : constant Integer := 16;

   Number_Symbols : constant String := "0123456789ABCDEF";
   Octal_Prefix : constant String := "0";
   Hex_Prefix : constant String := "0x";

   procedure Put (Str : in String);
   procedure Put (C : in Character);
   procedure Put (Num : in Integer;
                Base : in Integer := Decimal);
   procedure Put_Line (Str : in String);
   procedure Put_Line (Num : in Integer;
                  Base : in Integer := Decimal);
   procedure Put_Line;
end Text_Console;
