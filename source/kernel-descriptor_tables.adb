package body Kernel.Descriptor_Tables is

   procedure Gdt_Flush;
   pragma Import
     (Convention => C,
      Entity => Gdt_Flush,
      External_Name => "gdtflush");

   procedure Install_GDT (Gdtp : out GDT_Pointer;
                         Table : out GDT) is
   begin
      Gdtp := (Size => Global_Descriptor'Size * 3 - 1,
               Offset => To_Unsigned_32 (Table'Address));

      Set_GDT_Gate (0, Null_GDT_Entry, Table);
      Set_GDT_Gate (1, Code_Segment, Table);
      Set_GDT_Gate (2, Data_Segment, Table);

      Gdt_Flush;

      return;
   end Install_GDT;

   procedure Set_GDT_Gate (Gate : in GDT_Length;
                           Segment_Descriptor : in Global_Descriptor;
                           Table : in out GDT) is
   begin
      Table (Gate) := Segment_Descriptor;
   end Set_GDT_Gate;

end Kernel.Descriptor_Tables;
