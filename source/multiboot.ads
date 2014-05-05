--  Module      : Multiboot
--  Description : Constants and data structures provided by the multiboot
--  specification.
--  Author      : Lindsay Gaff
--  Email       : lindsaygaff@gmail.com
--  License     : Unrestricted
-------------------------------------------------------------------------------
with System;
with Interfaces; use Interfaces;

package Multiboot is
   Search : constant Unsigned_32 := 8192;
   Header_Align : constant Unsigned_32 := 4;

   type Multiboot_Flag is
      (Not_Set,
       Set);
   for Multiboot_Flag use
      (Not_Set => 0,
       Set => 1);
   for Multiboot_Flag'Size use 1;

   type Header_Flags is record
      Page_Align  : Multiboot_Flag;
      Memory_Info : Multiboot_Flag;
      Video_Mode  : Multiboot_Flag;
      Unused_3    : Multiboot_Flag;
      Unused_4    : Multiboot_Flag;
      Unused_5    : Multiboot_Flag;
      Unused_6    : Multiboot_Flag;
      Unused_7    : Multiboot_Flag;
      Unused_8    : Multiboot_Flag;
      Unused_9    : Multiboot_Flag;
      Unused_10   : Multiboot_Flag;
      Unused_11   : Multiboot_Flag;
      Unused_12   : Multiboot_Flag;
      Unused_13   : Multiboot_Flag;
      Unused_14   : Multiboot_Flag;
      Unused_15   : Multiboot_Flag;
      Aout_Kludge : Multiboot_Flag;
      Unused_17   : Multiboot_Flag;
      Unused_18   : Multiboot_Flag;
      Unused_19   : Multiboot_Flag;
      Unused_20   : Multiboot_Flag;
      Unused_21   : Multiboot_Flag;
      Unused_22   : Multiboot_Flag;
      Unused_23   : Multiboot_Flag;
      Unused_24   : Multiboot_Flag;
      Unused_25   : Multiboot_Flag;
      Unused_26   : Multiboot_Flag;
      Unused_27   : Multiboot_Flag;
      Unused_28   : Multiboot_Flag;
      Unused_29   : Multiboot_Flag;
      Unused_30   : Multiboot_Flag;
      Unused_31   : Multiboot_Flag;
   end record;
   for Header_Flags'Size use 32;
   for Header_Flags use record
      Page_Align  at 0 range 0 .. 0;
      Memory_Info at 0 range 1 .. 1;
      Video_Mode  at 0 range 2 .. 2;
      Unused_3    at 0 range 3 .. 3;
      Unused_4    at 0 range 4 .. 4;
      Unused_5    at 0 range 5 .. 5;
      Unused_6    at 0 range 6 .. 6;
      Unused_7    at 0 range 7 .. 7;
      Unused_8    at 1 range 0 .. 0;
      Unused_9    at 1 range 1 .. 1;
      Unused_10   at 1 range 2 .. 2;
      Unused_11   at 1 range 3 .. 3;
      Unused_12   at 1 range 4 .. 4;
      Unused_13   at 1 range 5 .. 5;
      Unused_14   at 1 range 6 .. 6;
      Unused_15   at 1 range 7 .. 7;
      Aout_Kludge at 2 range 0 .. 0;
      Unused_17   at 2 range 1 .. 1;
      Unused_18   at 2 range 2 .. 2;
      Unused_19   at 2 range 3 .. 3;
      Unused_20   at 2 range 4 .. 4;
      Unused_21   at 2 range 5 .. 5;
      Unused_22   at 2 range 6 .. 6;
      Unused_23   at 2 range 7 .. 7;
      Unused_24   at 3 range 0 .. 0;
      Unused_25   at 3 range 1 .. 1;
      Unused_26   at 3 range 2 .. 2;
      Unused_27   at 3 range 3 .. 3;
      Unused_28   at 3 range 4 .. 4;
      Unused_29   at 3 range 5 .. 5;
      Unused_30   at 3 range 6 .. 6;
      Unused_31   at 3 range 7 .. 7;
   end record;

   type Multiboot_Header is record
      Magic            : Unsigned_32;
      Flags            : Header_Flags;
      Checksum         : Unsigned_32;
      Header_Address   : Unsigned_32;
      Load_Address     : Unsigned_32;
      Load_End_Address : Unsigned_32;
      BSS_End_Address  : Unsigned_32;
      Entry_Address    : Unsigned_32;
      Mode_Type        : Unsigned_32;
      Video_Width      : Unsigned_32;
      Video_Height     : Unsigned_32;
      Video_Depth      : Unsigned_32;
   end record;
   for Multiboot_Header use record
      Magic            at 0  range 0 .. 31;
      Flags            at 4  range 0 .. 31;
      Checksum         at 8  range 0 .. 31;
      Header_Address   at 12 range 0 .. 31;
      Load_Address     at 16 range 0 .. 31;
      Load_End_Address at 20 range 0 .. 31;
      BSS_End_Address  at 24 range 0 .. 31;
      Entry_Address    at 28 range 0 .. 31;
      Mode_Type        at 32 range 0 .. 31;
      Video_Width      at 36 range 0 .. 31;
      Video_Height     at 40 range 0 .. 31;
      Video_Depth      at 44 range 0 .. 31;
   end record;
   for Multiboot_Header'Alignment use Header_Align;

   type Binary_Formats is (Aout, ELF);
   type Info_Symbol_Table (Variant : Binary_Formats := ELF) is record
      case Variant is
      when Aout =>
         Table_Size   : Unsigned_32;
         Str_Size     : Unsigned_32;
         Aout_Address : System.Address;
         Reserved     : Unsigned_32;
      when ELF =>
         Number      : Unsigned_32;
         Size        : Unsigned_32;
         Elf_Address : System.Address;
         Shndx       : Unsigned_32;
      end case;
   end record;
   pragma Convention (C, Info_Symbol_Table);
   pragma Unchecked_Union (Info_Symbol_Table);

   type Info_Flags is record
      Memory_Info_Present       : Multiboot_Flag;
      Boot_Device_Present       : Multiboot_Flag;
      Command_Line_Present      : Multiboot_Flag;
      Modules_Present           : Multiboot_Flag;
      Aout_Symbols_Present      : Multiboot_Flag;
      Elf_Header_Present        : Multiboot_Flag;
      Memory_Map_Present        : Multiboot_Flag;
      Drive_Info_Present        : Multiboot_Flag;
      Config_Table_Present      : Multiboot_Flag;
      Bootloader_Name_Present   : Multiboot_Flag;
      APM_Table_Present         : Multiboot_Flag;
      VBE_Info_Present          : Multiboot_Flag;
      FB_Info_Present           : Multiboot_Flag;
      Reserved                  : Unsigned_16;
   end record;

   for Info_Flags use record
      Memory_Info_Present       at 0 range 0 .. 0;
      Boot_Device_Present       at 0 range 1 .. 1;
      Command_Line_Present      at 0 range 2 .. 2;
      Modules_Present           at 0 range 3 .. 3;
      Aout_Symbols_Present      at 0 range 4 .. 4;
      Elf_Header_Present        at 0 range 5 .. 5;
      Memory_Map_Present        at 0 range 6 .. 6;
      Drive_Info_Present        at 0 range 7 .. 7;
      Config_Table_Present      at 1 range 0 .. 0;
      Bootloader_Name_Present   at 1 range 1 .. 1;
      APM_Table_Present         at 1 range 2 .. 2;
      VBE_Info_Present          at 1 range 3 .. 3;
      FB_Info_Present           at 1 range 4 .. 4;
      Reserved                  at 2 range 0 .. 15;
   end record;
   for Info_Flags'Size use 32;
   pragma Convention (C, Info_Flags);

   --  This structure is valid in the info structure
   --  if Memory_Info is set

   type Info_Available_Memory is record
      Lower : Unsigned_32;
      Upper : Unsigned_32;
   end record;

   --  This structure is valid in the info structure
   --  if Boot_Device is set
   type Info_Boot_Device is record
      Drive       : Unsigned_8;
      Partition_1 : Unsigned_8;
      Partition_2 : Unsigned_8;
      Partition_3 : Unsigned_8;
   end record;
   for Info_Boot_Device use record
      Drive       at 0 range 0 .. 7;
      Partition_1 at 1 range 0 .. 7;
      Partition_2 at 2 range 0 .. 7;
      Partition_3 at 3 range 0 .. 7;
   end record;
   for Info_Boot_Device'Size use 32;
   pragma Convention (C, Info_Boot_Device);

--  -----------------------------------
--  Modules information and structs
--  -----------------------------------

   type Module is record
      Module_Start : System.Address;
      Module_End : System.Address;
      Data : System.Address;
      Reserved : Unsigned_32;
   end record;

   type Module_List is array (Unsigned_32 range <>) of Module;
   pragma Convention (C, Module_List);

   type Info_Modules is record
      Count : Unsigned_32;
      Address : System.Address;
   end record;
   for Info_Modules'Size use 64;
   for Info_Modules use record
      Count   at 0 range 0 .. 31;
      Address at 4 range 0 .. 31;
   end record;

--  -----------------------------------
--  Memory map information and structs
--  -----------------------------------

   type Memory_Type is new Unsigned_32 range 0 .. 5;

   Available        : constant Memory_Type := 16#1#;
   Reserved         : constant Memory_Type := 16#2#;
   ACPI_Reclaimable : constant Memory_Type := 16#3#;
   Non_Volatile     : constant Memory_Type := 16#4#;
   Bad_Memory       : constant Memory_Type := 16#5#;

   type Memory_Map_Entry is record
      Size     : Unsigned_32;
      Address  : Unsigned_64;
      Length   : Unsigned_64;
      Usage    : Memory_Type;
   end record;

   type Info_Memory is record
      Length : Unsigned_32;
      Address : System.Address;
   end record;

   pragma Convention (C, Info_Memory);

--  -----------------------------------
--  Drive information and structs
--  -----------------------------------

   type Info_Drives is record
      Length : Unsigned_32;
      Address : System.Address;
   end record;
   for Info_Drives'Size use 64;
   pragma Convention (C, Info_Drives);
   --  TODO: Implement the drive table structure

--  -----------------------------------
--  APM information and structs
--  -----------------------------------
   type APM_Flags is record
      Graphics_Table_Available : Multiboot_Flag;
   end record;
   for APM_Flags'Size use 16;
   for APM_Flags use record
      Graphics_Table_Available at 0 range 11 .. 11;
   end record;

   type APM_Table is record
      Version                : Unsigned_16;
      Code_Segment           : Unsigned_16;
      Offset                 : Unsigned_32;
      Code_Segment_16        : Unsigned_16;
      Data_Segment           : Unsigned_16;
      Flags                  : APM_Flags;
      Code_Segment_Length    : Unsigned_16;
      Code_Segment_16_Length : Unsigned_16;
      Data_Segment_Length    : Unsigned_16;
   end record;
   for APM_Table'Size use 160;
   pragma Convention (C, APM_Table);

--  -----------------------------------
--  VBE information and structs
--  TODO: Revise this once VBE package is implemented
--  -----------------------------------

   type Info_VBE is record
      Control_Info      : Unsigned_32;
      Mode_Info         : Unsigned_32;
      Mode              : Unsigned_32;
      Interface_Segment : Unsigned_16;
      Interface_Offset  : Unsigned_16;
      Interface_Length  : Unsigned_16;
   end record;
   for Info_VBE'Size use 144;
   pragma Convention (C, Info_VBE);

--  TODO : Framebuffer structures

   type Multiboot_Info is record
      Features         : Info_Flags;
      Memory_Size      : Info_Available_Memory;
      Boot_Device      : Info_Boot_Device;
      Command_Line     : System.Address;
      Modules          : Info_Modules;
      Symbol_Table     : Info_Symbol_Table;
      Memory_Map       : Info_Memory;
      Drives           : Info_Drives;
      ROM_Config_Table : System.Address;
      Bootloader_Name  : System.Address;
      APM              : System.Address;
      VBE              : Info_VBE;
   end record;
   pragma Convention (C, Multiboot_Info);

   Multiboot_Info_Address : constant Unsigned_32;
   pragma Import (C, Multiboot_Info_Address, "mbd");

   System_Map : Multiboot_Info;
   for System_Map'Address
   use System'To_Address (Multiboot_Info_Address);
   pragma Volatile (System_Map);
   pragma Import (C, System_Map);

   subtype Magic_Values is Unsigned_32;
   Magic_Value : constant Magic_Values := 16#2BADB002#;
   Magic : constant Magic_Values;
   pragma Import (Assembly, Magic, "magic");
end Multiboot;
