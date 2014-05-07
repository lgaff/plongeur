with Kernel.Data_Structures; use Kernel.Data_Structures;
with Kernel.Utilities; use Kernel.Utilities;
with System;
--  with Interfaces; use Interfaces;

package Kernel.Descriptor_Tables is
   Gp : GDT_Pointer;
   Global_Descriptor_Table : GDT (0 .. 2);
   Ip : IDT_Pointer;
   Interrupt_Descriptor_Table : IDT (0 .. 255);

   procedure Install_GDT (Gdtp : out GDT_Pointer;
                          Table : out GDT);

   procedure Set_GDT_Gate (Gate                 : in GDT_Length;
                           Segment_Descriptor   : in Global_Descriptor;
                           Table                : in out GDT);

   procedure Install_IDT (Idtp : out IDT_Pointer;
                          Table : out IDT);

   procedure Set_Idt_Gate (Index : in IDT_Length;
                           Handler : in System.Address;
                           Selector : in Unsigned_16 := 16#08#;
                           Gate_Type : in Gates := Interrupt_Gate_386;
                           Segment : in Flag := 0;
                           Privilege : in DPL := 0);

   pragma Export (C, Gp);
   pragma Export (C, Ip);

private
   Null_Segment : constant Unsigned_64 := 0;
   Null_GDT_Entry : constant Global_Descriptor :=
     To_Global_Descriptor (Null_Segment);

   Code_Segment : Global_Descriptor :=
     (Base_Low => 0,
      Base_Mid => 0,
      Base_High => 0,
      Limit_Low => 16#FFFF#,
      Limit_High => 16#F#,
      Granularity => Page,
      Always_One => 1,
      Size => Thirtytwo_Bit,
      Present => Present,
      Privilege => 0,
      Executable => Code,
      Accessed => Not_Accessed,
      Direction => 0,
      Readable => 1);

   Data_Segment : Global_Descriptor :=
     (Base_Low => 0,
      Base_Mid => 0,
      Base_High => 0,
      Limit_Low => 16#FFFF#,
      Limit_High => 16#F#,
      Granularity => Page,
      Always_One => 1,
      Size => Thirtytwo_Bit,
      Present => Present,
      Privilege => 0,
      Executable => Data,
      Accessed => Not_Accessed,
      Direction => 0,
      Readable => 1);

--  --------------- IDT Handler -----------------------
   type IDT_Entry is access Interrupt_Descriptor;
   pragma No_Strict_Aliasing (IDT_Entry);

   procedure Isr_0;
   pragma Import (C, Isr_0, "isr0");
   procedure Isr_1;
   pragma Import (C, Isr_1, "isr1");
   procedure Isr_2;
   pragma Import (C, Isr_2, "isr2");
   procedure Isr_3;
   pragma Import (C, Isr_3, "isr3");
   procedure Isr_4;
   pragma Import (C, Isr_4, "isr4");
   procedure Isr_5;
   pragma Import (C, Isr_5, "isr5");
   procedure Isr_6;
   pragma Import (C, Isr_6, "isr6");
   procedure Isr_7;
   pragma Import (C, Isr_7, "isr7");
   procedure Isr_8;
   pragma Import (C, Isr_8, "isr8");
   procedure Isr_9;
   pragma Import (C, Isr_9, "isr9");
   procedure Isr_10;
   pragma Import (C, Isr_10, "isr10");
   procedure Isr_11;
   pragma Import (C, Isr_11, "isr11");
   procedure Isr_12;
   pragma Import (C, Isr_12, "isr12");
   procedure Isr_13;
   pragma Import (C, Isr_13, "isr13");
   procedure Isr_14;
   pragma Import (C, Isr_14, "isr14");
   procedure Isr_15;
   pragma Import (C, Isr_15, "isr15");
   procedure Isr_16;
   pragma Import (C, Isr_16, "isr16");
   procedure Isr_17;
   pragma Import (C, Isr_17, "isr17");
   procedure Isr_18;
   pragma Import (C, Isr_18, "isr18");
   procedure Isr_19;
   pragma Import (C, Isr_19, "isr19");
   procedure Isr_20;
   pragma Import (C, Isr_20, "isr20");
   procedure Isr_21;
   pragma Import (C, Isr_21, "isr21");
   procedure Isr_22;
   pragma Import (C, Isr_22, "isr22");
   procedure Isr_23;
   pragma Import (C, Isr_23, "isr23");
   procedure Isr_24;
   pragma Import (C, Isr_24, "isr24");
   procedure Isr_25;
   pragma Import (C, Isr_25, "isr25");
   procedure Isr_26;
   pragma Import (C, Isr_26, "isr26");
   procedure Isr_27;
   pragma Import (C, Isr_27, "isr27");
   procedure Isr_28;
   pragma Import (C, Isr_28, "isr28");
   procedure Isr_29;
   pragma Import (C, Isr_29, "isr29");
   procedure Isr_30;
   pragma Import (C, Isr_30, "isr30");
   procedure Isr_31;
   pragma Import (C, Isr_31, "isr31");

   procedure Irq_0;
   pragma Import (C, Irq_0, "irq0");
   procedure Irq_1;
   pragma Import (C, Irq_1, "irq1");
   procedure Irq_2;
   pragma Import (C, Irq_2, "irq2");
   procedure Irq_3;
   pragma Import (C, Irq_3, "irq3");
   procedure Irq_4;
   pragma Import (C, Irq_4, "irq4");
   procedure Irq_5;
   pragma Import (C, Irq_5, "irq5");
   procedure Irq_6;
   pragma Import (C, Irq_6, "irq6");
   procedure Irq_7;
   pragma Import (C, Irq_7, "irq7");
   procedure Irq_8;
   pragma Import (C, Irq_8, "irq8");
   procedure Irq_9;
   pragma Import (C, Irq_9, "irq9");
   procedure Irq_10;
   pragma Import (C, Irq_10, "irq10");
   procedure Irq_11;
   pragma Import (C, Irq_11, "irq11");
   procedure Irq_12;
   pragma Import (C, Irq_12, "irq12");
   procedure Irq_13;
   pragma Import (C, Irq_13, "irq13");
   procedure Irq_14;
   pragma Import (C, Irq_14, "irq14");
   procedure Irq_15;
   pragma Import (C, Irq_15, "irq15");

end Kernel.Descriptor_Tables;
