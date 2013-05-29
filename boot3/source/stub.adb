with System.Machine_Code; use System.Machine_Code;

procedure Stub is
begin
   Asm ("xchg %%bx, %%bx",
        Volatile => True);
   loop
      Asm ("nop",
           Volatile => True);
   end loop;
end Stub;
pragma No_Return (Stub);
