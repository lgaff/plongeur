with VGA; use VGA;
with Kernel.Utilities; use Kernel.Utilities;

package body Console is
   procedure Write
      (Char : in Character;
       X : in Screen_Width;
       Y : in Screen_Height;
       Attributes : in Attribute := Current_Attribute) is
   begin
      Plongeur_Console (Y)(X).Char := Char;
      Plongeur_Console (Y)(X).Attributes := Attributes;
   end Write;

   procedure Write
      (Str : in String;
       X : in Screen_Width;
       Y : in Screen_Height;
       Attributes : in Attribute := Current_Attribute) is
   begin
      for Index in Str'First .. Str'Last loop
         Write (Str (Index),
               X + Screen_Width (Index) - 1,
               Y,
               Attributes);
      end loop;
   end Write;

   procedure Write
      (Str : in String;
       Attributes : in Attribute := Current_Attribute) is
   begin
      for Index in Str'First .. Str'Last loop
         Write (Str (Index),
            Cursor_X,
            Cursor_Y,
            Attributes);
         if Cursor_X = Columns then
            Cursor_Y := Cursor_Y + 1;
            Cursor_X := 1;
         else
            Cursor_X := Cursor_X + 1;
         end if;
      end loop;

      Update_Cursor_Position;
   end Write;

   procedure Blank is
   begin
      for X in Screen_Width'First .. Screen_Width'Last loop
         for Y in Screen_Height'First .. Screen_Height'Last loop
            Write (' ', X, Y, Current_Attribute);
         end loop;
      end loop;
   end Blank;

   procedure Update_Cursor_Position is
      C_Pos : Double_Byte;
   begin
      C_Pos := To_Double_Byte ((Cursor_Y - 1)
             * Columns + (Cursor_X - 1));
      Write_Port (CRTC_Controller_Address_Register, CRTC_Cursor_Location_High);
      Write_Port (CRTC_Controller_Data_Register, C_Pos.High_Byte);
      Write_Port (CRTC_Controller_Address_Register, CRTC_Cursor_Location_Low);
      Write_Port (CRTC_Controller_Data_Register, C_Pos.Low_Byte);
   end Update_Cursor_Position;
end Console;