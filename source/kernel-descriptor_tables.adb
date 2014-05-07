--  with System.Address_To_Access_Conversions;
--  with Ada.Unchecked_Conversion;

package body Kernel.Descriptor_Tables is

   procedure Gdt_Flush;
   pragma Import
     (Convention => C,
      Entity => Gdt_Flush,
      External_Name => "gdtflush");
   procedure Idt_Flush;
   pragma Import
      (Convention => C,
      Entity => Idt_Flush,
      External_Name => "idtflush");

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

   procedure Install_IDT (Idtp : out IDT_Pointer;
                          Table : out IDT) is
   begin
      Idtp := (Size => Interrupt_Descriptor'Size * 256 - 1,
               Offset => To_Unsigned_32 (Table'Address));

      Set_Idt_Gate (0, Isr_0'Address);
      Set_Idt_Gate (1, Isr_1'Address);
      Set_Idt_Gate (2, Isr_2'Address);
      Set_Idt_Gate (3, Isr_3'Address);
      Set_Idt_Gate (4, Isr_4'Address);
      Set_Idt_Gate (5, Isr_5'Address);
      Set_Idt_Gate (6, Isr_6'Address);
      Set_Idt_Gate (7, Isr_7'Address);
      Set_Idt_Gate (8, Isr_8'Address);
      Set_Idt_Gate (9, Isr_9'Address);
      Set_Idt_Gate (10, Isr_10'Address);
      Set_Idt_Gate (11, Isr_11'Address);
      Set_Idt_Gate (12, Isr_12'Address);
      Set_Idt_Gate (13, Isr_13'Address);
      Set_Idt_Gate (14, Isr_14'Address);
      Set_Idt_Gate (15, Isr_15'Address);
      Set_Idt_Gate (16, Isr_16'Address);
      Set_Idt_Gate (17, Isr_17'Address);
      Set_Idt_Gate (18, Isr_18'Address);
      Set_Idt_Gate (19, Isr_19'Address);
      Set_Idt_Gate (20, Isr_20'Address);
      Set_Idt_Gate (21, Isr_21'Address);
      Set_Idt_Gate (22, Isr_22'Address);
      Set_Idt_Gate (23, Isr_23'Address);
      Set_Idt_Gate (24, Isr_24'Address);
      Set_Idt_Gate (25, Isr_25'Address);
      Set_Idt_Gate (26, Isr_26'Address);
      Set_Idt_Gate (27, Isr_27'Address);
      Set_Idt_Gate (28, Isr_28'Address);
      Set_Idt_Gate (29, Isr_29'Address);
      Set_Idt_Gate (30, Isr_30'Address);
      Set_Idt_Gate (31, Isr_31'Address);
      Set_Idt_Gate (32, Irq_0'Address);
      Set_Idt_Gate (33, Irq_1'Address);
      Set_Idt_Gate (34, Irq_2'Address);
      Set_Idt_Gate (35, Irq_3'Address);
      Set_Idt_Gate (36, Irq_4'Address);
      Set_Idt_Gate (37, Irq_5'Address);
      Set_Idt_Gate (38, Irq_6'Address);
      Set_Idt_Gate (39, Irq_7'Address);
      Set_Idt_Gate (40, Irq_8'Address);
      Set_Idt_Gate (41, Irq_9'Address);
      Set_Idt_Gate (42, Irq_10'Address);
      Set_Idt_Gate (43, Irq_11'Address);
      Set_Idt_Gate (44, Irq_12'Address);
      Set_Idt_Gate (45, Irq_13'Address);
      Set_Idt_Gate (46, Irq_14'Address);
      Set_Idt_Gate (47, Irq_15'Address);
      Idt_Flush;
   end Install_IDT;

   procedure Set_Idt_Gate (Index : in IDT_Length;
                           Handler : in System.Address;
                           Selector : in Unsigned_16 := 16#08#;
                           Gate_Type : in Gates := Interrupt_Gate_386;
                           Segment : in Flag := 0;
                           Privilege : in DPL := 0) is
      Address : constant Double_Word := To_Double_Word (Handler);
   begin
      Interrupt_Descriptor_Table (Index)
         .Offset_Low := Address.Low_Word;
      Interrupt_Descriptor_Table (Index)
         .Offset_High := Address.High_Word;
      Interrupt_Descriptor_Table (Index)
         .Gate_Type := Gate_Type;
      Interrupt_Descriptor_Table (Index)
         .Segment := Segment;
      Interrupt_Descriptor_Table (Index)
         .Privilege_Level := Privilege;
      Interrupt_Descriptor_Table (Index)
         .Present := 1;
      Interrupt_Descriptor_Table (Index)
         .Selector := Selector;
   end Set_Idt_Gate;
end Kernel.Descriptor_Tables;
