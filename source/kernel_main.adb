with System.Machine_Code; use System.Machine_Code;
with Ada.Unchecked_Conversion;

package body Kernel_Main is

   function To_Unsigned_32 is new Ada.Unchecked_Conversion
     (Source => System.Address,
      Target => Unsigned_32);

   procedure Stub is
   begin
      Asm ("xchg %%bx, %%bx",
           Volatile => True);
      Asm ("mov %%eax, %0",
           Inputs => Unsigned_32'Asm_Input ("a", Cksum),
           Volatile => True);
      Asm ("mov %%ebx, %0",
           Inputs => Unsigned_32'Asm_Input ("a",
                                 To_Unsigned_32 (Cksum'Address)),
           Volatile => True);
      Asm ("xchg %%bx, %%bx",
           Volatile => True);
      loop
         Asm ("nop",
              Volatile => True);
      end loop;
   end Stub;
   pragma No_Return (Stub);
end Kernel_Main;
