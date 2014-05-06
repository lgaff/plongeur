with System.Machine_Code; use System.Machine_Code;

package body X86_IO is
   procedure Write_Port (Port : Unsigned_16;
                  Value : in Unsigned_8) is
   begin
      Asm ("outb %0, %1",
         Inputs => (Unsigned_8'Asm_Input ("a", Value),
                    Unsigned_16'Asm_Input ("dN", Port)),
         Volatile => True);
   end Write_Port;
   pragma Inline (Write_Port);
   procedure Write_Port (Port : in Unsigned_16;
                  Value : in Unsigned_16) is
   begin
      Asm ("outw %0, %1",
         Inputs => (Unsigned_16'Asm_Input ("a", Value),
                    Unsigned_16'Asm_Input ("dN", Port)),
         Volatile => True);
   end Write_Port;
   pragma Inline (Write_Port);
   function Read_Port (Port : in Unsigned_16) return Unsigned_8 is
      Return_Value : Unsigned_8;
   begin
      Asm ("inb %1, %0",
         Inputs => Unsigned_16'Asm_Input ("dN", Port),
         Outputs => Unsigned_8'Asm_Output ("=a", Return_Value),
         Volatile => True);
      return Return_Value;
   end Read_Port;
   pragma Inline (Read_Port);
   function Read_Port (Port : in Unsigned_16) return Unsigned_16 is
      Return_Value : Unsigned_16;
   begin
      Asm ("inw %1, %0",
         Inputs => Unsigned_16'Asm_Input ("dN", Port),
         Outputs => Unsigned_16'Asm_Output ("=a", Return_Value),
         Volatile => True);
      return Return_Value;
   end Read_Port;
   pragma Inline (Read_Port);

   procedure IO_Wait is
   begin
      Asm ("outb %%al, $0x80",
         Volatile => True);
   end IO_Wait;
end X86_IO;