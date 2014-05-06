with System.Machine_Code; use System.Machine_Code;
with Kernel; use Kernel;
with Kernel.Descriptor_Tables; use Kernel.Descriptor_Tables;
with Kernel.Initialisation; use Kernel.Initialisation;
with Text_Console; use Text_Console;
with VGA.Text_Mode; use VGA.Text_Mode;
with Multiboot; use Multiboot;
with Kernel.ASCII; use Kernel.ASCII;
use type Multiboot.Magic_Values;

procedure Plongeur is
begin
   Go_To_Higher_Half (Kernel_Page_Directory, Identity_Mapped_Table);
   Install_GDT (Gp, Global_Descriptor_Table);
   Blank;
   Put_Line ("Hello, World!");
   if Magic = Magic_Value then
      Put_Line ("Magic value is correct and readable.");
   else
      Put_Line ("Magic value incorrect.");
   end if;
   Put_Line (1);
   Put_Line (123);
   Put_Line (15, Hexadecimal);
   Put_Line (5, Binary);
   Put_Line ("One" & TAB & "Two" & TAB & "Three");
   Put_Line ("Four" & TAB & "Five" & TAB & "Six");
   Put_Line ("Seven" & TAB & "Eight" & TAB & "Nine");
   Asm ("mov %%eax, %0",
         Inputs => Magic_Values'Asm_Input ("g", Magic),
         Volatile => True);
   loop
      Asm ("nop",
           Volatile => True);
   end loop;
end Plongeur;
pragma No_Return (Plongeur);