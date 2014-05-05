with System.Machine_Code; use System.Machine_Code;
with Kernel; use Kernel;
with Kernel.Descriptor_Tables; use Kernel.Descriptor_Tables;
with Kernel.Initialisation; use Kernel.Initialisation;
with Console; use Console;
with Multiboot; use Multiboot;

use type Multiboot.Magic_Values;

procedure Plongeur is
begin
   Go_To_Higher_Half (Kernel_Page_Directory, Identity_Mapped_Table);
   Install_GDT (Gp, Global_Descriptor_Table);
   Blank;
   Write ("Hello, World!");
   if Magic = Magic_Value then
      Write ("Magic value is correct and readable.");
   else
      Write ("Magic value incorrect.");
   end if;
   Asm ("mov %%eax, %0",
         Inputs => Magic_Values'Asm_Input ("g", Magic),
         Volatile => True);
   loop
      Asm ("nop",
           Volatile => True);
   end loop;
end Plongeur;
pragma No_Return (Plongeur);