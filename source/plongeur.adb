with System.Machine_Code; use System.Machine_Code;
with Kernel; use Kernel;
with Kernel.Descriptor_Tables; use Kernel.Descriptor_Tables;
with Kernel.Initialisation; use Kernel.Initialisation;
with Kernel.Utilities; use Kernel.Utilities;
with Text_Console; use Text_Console;
with VGA.Text_Mode; use VGA.Text_Mode;
with Multiboot; use Multiboot;
with Kernel.ASCII; use Kernel.ASCII;
with PIC; use PIC;
use type Multiboot.Magic_Values;

procedure Plongeur is
   Memory_Map_Ptr : Memory_Map_Entry_Pointer;
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

   if Get_Binary_Format = ELF then
      Put ("Multiboot header includes Elf header at ");
      Put_Line (To_Integer (System_Map.Symbol_Table.Elf_Address), Hexadecimal);
   end if;

   Put ("Checking for memory map: ");
   if System_Map.Features.Memory_Map_Present then
      Put_Line ("Yes.");
   else
      Put_Line ("No.");
   end if;
   Put (To_Integer (System_Map.Memory_Size.Upper -
                    System_Map.Memory_Size.Lower));
   Put_Line (" bytes available memory");
   Put ("Lower: ");
   Put_Line (To_Integer (System_Map.Memory_Size.Lower));
   Put ("Upper: ");
   Put_Line (To_Integer (System_Map.Memory_Size.Upper));

   Put_Line ("Memory Map");
   Put_Line ("Size" & TAB & "Address" & TAB & "Length" & TAB & "Type");
   Put_Line (Horizontal_Line);
   Memory_Map_Ptr := First_Memory_Map_Entry;

   Memory_Map_Loop :
   loop
      Put (To_Integer (Memory_Map_Ptr.Size));
      Put (TAB);
      Put (To_Integer (Memory_Map_Ptr.Address_Low), Hexadecimal);
      Put (TAB);
      Put (Memory_Map_Ptr.Length, Decimal);
      Put (TAB);
      case Memory_Map_Ptr.Usage is
         when Available =>
            Put ("Available");
         when Reserved =>
            Put ("Reserved");
         when ACPI_Reclaimable =>
            Put ("ACPI Reclaimable");
         when Non_Volatile =>
            Put ("Non volatile");
         when Bad_Memory =>
            Put ("Bad memory");
         when others =>
            Put ("Unrecognised type: ");
            Put (To_Integer (Memory_Map_Ptr.Usage));
      end case;
      Put_Line;
      Memory_Map_Ptr := Next_Memory_Map_Entry (Memory_Map_Ptr);
      exit Memory_Map_Loop when Memory_Map_Ptr = null;
   end loop Memory_Map_Loop;

   Initialise_Pics (32);

   loop
      Asm ("nop",
           Volatile => True);
   end loop;
end Plongeur;
pragma No_Return (Plongeur);