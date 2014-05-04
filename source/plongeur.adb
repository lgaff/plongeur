with System.Machine_Code; use System.Machine_Code;
with Kernel; use Kernel;
with Kernel.Descriptor_Tables; use Kernel.Descriptor_Tables;
with Kernel.Initialisation; use Kernel.Initialisation;
with Kernel.Utilities; use Kernel.Utilities;
with Console; use Console;

procedure Plongeur is
begin
   Go_To_Higher_Half (Kernel_Page_Directory, Identity_Mapped_Table);
   Install_GDT (Gp, Global_Descriptor_Table);
   Blank;
   Magic_Break;
   Write ("Hello, World!");
   loop
      Asm ("nop",
           Volatile => True);
   end loop;
end Plongeur;
pragma No_Return (Plongeur);