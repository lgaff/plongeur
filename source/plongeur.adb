with System.Machine_Code; use System.Machine_Code;
with Interfaces; use Interfaces;

procedure Plongeur is
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
end Plongeur;
pragma No_Return (Plongeur);
