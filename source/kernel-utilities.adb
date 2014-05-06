with Interfaces;
with System.Machine_Code; use System.Machine_Code;

package body Kernel.Utilities is
   function Align_Address (Physical_Address : Unsigned_32)
                          return Page_Address is
      Temp : Unsigned_32 := 0;
   begin
      Temp := Interfaces.Shift_Right
        (Value => Physical_Address,
         Amount => 12);
      return Page_Address (Temp mod 2 ** 20);
   end Align_Address;

   procedure Magic_Break is
   begin
      Asm ("xchg %%bx, %%bx",
         Volatile => True);
   end Magic_Break;
   pragma Inline (Magic_Break);
end Kernel.Utilities;
