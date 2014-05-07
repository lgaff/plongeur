--  Module      : VGA.Text_Mode
--  Description : driver for the 80x25 text mode VGA.
--  Author      : Lindsay Gaff
--  Email       : lindsaygaff@gmail.com
--  License     : Unrestricted
-------------------------------------------------------------------------------
with System;

package VGA.Text_Mode is
   type Blink_Flag is
      (Dont_Blink,
       Blink);
   for Blink_Flag'Size use 1;

   for Blink_Flag use
      (Dont_Blink => 0,
      Blink => 1);

   type Foreground_Color is
      (Black,
       Low_Blue,
       Low_Green,
       Low_Cyan,
       Low_Red,
       Low_Magenta,
       Brown,
       Light_Grey,
       Dark_Grey,
       High_Blue,
       High_Green,
       High_Cyan,
       High_Red,
       High_Magenta,
       Yellow,
       White);

   for Foreground_Color use
      (Black => 16#0#,
       Low_Blue => 16#1#,
       Low_Green => 16#2#,
       Low_Cyan => 16#3#,
       Low_Red => 16#4#,
       Low_Magenta => 16#5#,
       Brown => 16#6#,
       Light_Grey => 16#7#,
       Dark_Grey => 16#8#,
       High_Blue => 16#9#,
       High_Green => 16#A#,
       High_Cyan => 16#B#,
       High_Red => 16#C#,
       High_Magenta => 16#D#,
       Yellow => 16#E#,
       White => 16#F#);

   for Foreground_Color'Size use 4;

   type Background_Color is
      (Black,
       Blue,
       Green,
       Cyan,
       Red,
       Magenta,
       Brown,
       Light_Grey);

   for Background_Color use
      (Black => 16#0#,
       Blue => 16#1#,
       Green => 16#2#,
       Cyan => 16#3#,
       Red => 16#4#,
       Magenta => 16#5#,
       Brown => 16#6#,
       Light_Grey => 16#7#);

   for Background_Color'Size use 3;

   type Attribute is record
      Foreground : Foreground_Color;
      Background : Background_Color;
      Blink : Blink_Flag;
   end record;

   for Attribute use record
      Foreground at 0 range 0 .. 3;
      Background at 0 range 4 .. 6;
      Blink at 0 range 7 .. 7;
   end record;

   type Character_Cell is record
      Char : Character;
      Attributes : Attribute;
   end record;

   for Character_Cell'Size use 16;

   for Character_Cell use record
      Char at 0 range 0 .. 7;
      Attributes at 1 range 0 .. 7;
   end record;

   Columns : constant Unsigned_16 := 80;
   Rows : constant Unsigned_16 := 25;

   subtype Screen_Width is Unsigned_16 range 1 .. Columns;
   subtype Screen_Height is Unsigned_16 range 1 .. Rows;

   type Row is array (Screen_Width) of Character_Cell;
   type Column is array (Screen_Height) of Character_Cell;

   type Text_Console is array (Screen_Height) of Row;

   --  TODO: I may modify this to be private and
   --  use setters for updating fg/bg colors
   Current_Attribute : Attribute :=
      (Foreground => High_Green,
       Background => Blue,
       Blink => Dont_Blink
      );

   procedure Write
      (Char : in Character;
       X : in Screen_Width;
       Y : in Screen_Height;
       Attributes : in Attribute := Current_Attribute);

   procedure Write
      (Str : in String;
       Attributes : in Attribute := Current_Attribute);

   procedure Blank;
   procedure Scroll;
private
   Plongeur_Console : Text_Console;
   for Plongeur_Console'Address use System'To_Address (16#B8000#);
   --  This import is required to satisfy to the compiler that we
   --  know what we're doing by manually setting the address
   pragma Import (Ada, Plongeur_Console);
   procedure Update_Cursor_Position;

   Cursor_X : Screen_Width := 1;
   Cursor_Y : Screen_Height := 1;
   Tab_Size : Screen_Width := 8;

end VGA.Text_Mode;
