with System.Machine_Code; use System.Machine_Code;
with Interfaces; use Interfaces;
with Kernel; use Kernel;
with Kernel.Descriptor_Tables; use Kernel.Descriptor_Tables;
with Kernel.Initialisation; use Kernel.Initialisation;
with Kernel.Utilities; use Kernel.Utilities;

procedure Plongeur is
begin
   Go_To_Higher_Half (Kernel_Page_Directory, Identity_Mapped_Table);
   Install_GDT (Gp, Global_Descriptor_Table);
   Asm ("xchg %%bx, %%bx",
        Volatile => True);
   Asm ("mov %%ebx, %0",
        Inputs => Unsigned_32'Asm_Input ("a", Cksum),
        Volatile => True);
   Asm ("mov %%ecx, %0",
        Inputs => Unsigned_32'Asm_Input ("b",
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
