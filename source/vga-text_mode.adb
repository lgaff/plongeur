with VGA; use VGA;
with Kernel.Utilities; use Kernel.Utilities;
with X86_IO; use X86_IO;
with Kernel.ASCII; use Kernel.ASCII;

package body VGA.Text_Mode is
   procedure Write
      (Char : in Character;
       X : in Screen_Width;
       Y : in Screen_Height;
       Attributes : in Attribute := Current_Attribute) is
   begin
      case Char is
         --  Unimplemented control chars
         when Character'Val (10) =>
            null;
         when others =>
            Plongeur_Console (Y)(X).Char := Char;
            Plongeur_Console (Y)(X).Attributes := Attributes;
      end case;
   end Write;

   procedure Write
      (Str : in String;
       Attributes : in Attribute := Current_Attribute) is
   begin
      for Index in Str'First .. Str'Last loop
         case Str (Index) is
            when FF =>
               Cursor_Y := Cursor_Y + 1;
               Cursor_X := 1;
            when TAB =>
               if Cursor_X + Tab_Size >= Columns then
                  Cursor_Y := Cursor_Y + 1;
                  Cursor_X := 1;
               else
                  Cursor_X := Cursor_X + (Tab_Size - Cursor_X mod Tab_Size);
               end if;
            when others =>
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
               if Cursor_Y = Rows then
                  Scroll;
               end if;
         end case;
      end loop;
      Update_Cursor_Position;
   end Write;

   procedure Scroll is
   begin
      --  TODO: Write a memcpy routine, and use it to implement this.
      for Y in Screen_Height'First .. Screen_Height'Last - 1 loop
         for X in Screen_Width'First .. Screen_Width'Last - 1 loop
            Plongeur_Console (Y)(X) := Plongeur_Console (Y + 1)(X + 1);
         end loop;
      end loop;
      for X in Screen_Width'First .. Screen_Width'Last loop
         Plongeur_Console (Screen_Height'Last) (X).Char := ' ';
      end loop;
      Cursor_X := Screen_Width'First;
      Cursor_Y := Screen_Height'Last;
   end Scroll;

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
end VGA.Text_Mode;