with System.Machine_Code; use System.Machine_Code;

procedure Stub is
begin
   Asm ("xchg %%ebx, %%ebx",
       Volatile => True);
end Stub;
pragma No_Return (Stub);
