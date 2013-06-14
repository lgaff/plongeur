with Kernel.Data_Structures; use Kernel.Data_Structures;
with Kernel.Utilities; use Kernel.Utilities;

package Kernel.Descriptor_Tables is
   Gp : GDT_Pointer;
   Global_Descriptor_Table : GDT (0 .. 2);

   procedure Install_GDT (Gdtp : out GDT_Pointer;
                          Table : out GDT);

   procedure Set_GDT_Gate (Gate                 : in GDT_Length;
                           Segment_Descriptor   : in Global_Descriptor;
                           Table                : in out GDT);
   pragma Export (C, Gp);

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
      Direction => 1,
      Readable => 0);

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
      Direction => 1,
      Readable => 0);
end Kernel.Descriptor_Tables;
