with System.Address_To_Access_Conversions;
with Ada.Unchecked_Conversion;
with Kernel.Utilities; use Kernel.Utilities;

package body Multiboot is
   package Multiboot_Convert is new System.Address_To_Access_Conversions
      (Object => Multiboot_Info_Access);

   function To_Info_Access is new Ada.Unchecked_Conversion
     (Source => Multiboot_Convert.Object_Pointer,
      Target => Multiboot_Info_Access);

   function Get_System_Map (Info_Address : System.Address)
      return Multiboot_Info_Access is
   begin
      return To_Info_Access
         (Multiboot_Convert.To_Pointer (Info_Address));
   end Get_System_Map;

   package MMap_Convert is new  System.Address_To_Access_Conversions
     (Object => Memory_Map_Entry_Pointer);

   function To_Entry_Pointer is new Ada.Unchecked_Conversion
     (Source => MMap_Convert.Object_Pointer,
      Target => Memory_Map_Entry_Pointer);

   function To_Object_Pointer is new Ada.Unchecked_Conversion
     (Source => Memory_Map_Entry_Pointer,
      Target => MMap_Convert.Object_Pointer);

   function Get_Binary_Format (System_Map : Multiboot_Info_Access)
      return Binary_Formats is
   begin
      if System_Map.Features.Aout_Symbols_Present
      and not System_Map.Features.Elf_Header_Present
      then
         return Aout;
      elsif System_Map.Features.Elf_Header_Present then
         return ELF;
      else
         raise Program_Error;
      end if;
   end Get_Binary_Format;

   function First_Memory_Map_Entry (System_Map : Multiboot_Info_Access)
      return Memory_Map_Entry_Pointer is
   begin
      return To_Entry_Pointer
         (MMap_Convert.To_Pointer (System_Map.Memory_Map.Address));
   end First_Memory_Map_Entry;

   function Next_Memory_Map_Entry
      (Current : Memory_Map_Entry_Pointer;
       System_Map : Multiboot_Info_Access)
      return Memory_Map_Entry_Pointer is
      --  Next memory map entry is at Current + Current.Size.
      --  We need to convert Current's address into an Unsigned_32
      --  in order to add Size to it. This needs to be converted back
      --  before returning.
      --  We also need to perform a bounds check on
      --  System_Map.Memory_Map.Length. If SM.MM.Size + Length is
      --  less than Next's address, we're at the end of the memory map.
      --  Return Null if so.
      Current_Address : Unsigned_32 := Unsigned_32'First;
      Map_Bounds : Unsigned_32 := Unsigned_32'First;
   begin
      Current_Address := To_Unsigned_32
         (MMap_Convert.To_Address (To_Object_Pointer (Current)));
      Current_Address := Current_Address + Current.Size
                       + (Unsigned_32'Size / System.Storage_Unit);
      Map_Bounds := To_Unsigned_32 (System_Map.Memory_Map.Address)
                  + System_Map.Memory_Map.Length;
      if Current_Address >= Map_Bounds then
         return null;
      else
         return To_Entry_Pointer
            (MMap_Convert.To_Pointer (To_Address (Current_Address)));
      end if;
   end Next_Memory_Map_Entry;
end Multiboot;