--  Module      : Kernel.Data_Structures
--  Description : Specification for kernel data types and structures
--  Author      : Lindsay Gaff
--  Email       : lindsaygaff@gmail.com
--  License     : Unrestricted
-------------------------------------------------------------------------------
package Kernel.Data_Structures is

-- ----------  Useful primitives  --------------
   type Flag is range 0 .. 1;
   for Flag'Size use 1;

   type Unsigned_2 is mod 2 ** 2;
   for Unsigned_2'Size use 2;

   type Unsigned_4 is mod 2 ** 4;
   for Unsigned_4'Size use 4;

   type Unsigned_12 is mod 2 ** 12;
   for Unsigned_12'Size use 12;

-- ----------  Table pointers  -----------------

   type GDT_Pointer is record
      Size : Unsigned_16;
      Offset : Unsigned_32;
   end record;
   for GDT_Pointer'Size use 48;

   for GDT_Pointer use record
      Size      at 0 range 0 .. 15;
      Offset    at 0 range 16 .. 47;
   end record;

-- ---------  Page directory structures  ------
   type Page_Address is mod 2 ** 20;
   for Page_Address'Size use 20;

   type Page_Metadata is mod 2 ** 3;
   for Page_Metadata'Size use 3;

   type Page_Directory_Entry is
      record
         VAddress           : Page_Address;
         Metadata          : Page_Metadata;
         Page_Size         : Flag;
         Access_Bit        : Flag;
         Cache_Disable     : Flag;
         Write_Through     : Flag;
         Ring_Access       : Flag;
         Read_Write        : Flag;
         Page_Present      : Flag;
      end record;

   for Page_Directory_Entry use
      record
         Page_Present    at 0 range 0 .. 0;
         Read_Write      at 0 range 1 .. 1;
         Ring_Access     at 0 range 2 .. 2;
         Write_Through   at 0 range 3 .. 3;
         Cache_Disable   at 0 range 4 .. 4;
         Access_Bit      at 0 range 5 .. 5;
         Page_Size       at 0 range 7 .. 7;
         Metadata        at 1 range 1 .. 3;
         VAddress         at 1 range 4 .. 23;
      end record;

   type Page_Table_Entry is
      record
         VAddress           : Page_Address;
         Metadata          : Page_Metadata;
         Global            : Flag;
         Dirty             : Flag;
         Access_Bit        : Flag;
         Cache_Disable     : Flag;
         Write_Through     : Flag;
         Ring_Access       : Flag;
         Read_Write        : Flag;
         Page_Present      : Flag;
      end record;

   for Page_Table_Entry use
      record
         Page_Present    at 0 range 0 .. 0;
         Read_Write      at 0 range 1 .. 1;
         Ring_Access     at 0 range 2 .. 2;
         Write_Through   at 0 range 3 .. 3;
         Cache_Disable   at 0 range 4 .. 4;
         Access_Bit      at 0 range 5 .. 5;
         Dirty           at 0 range 7 .. 7;
         Global          at 1 range 0 .. 0;
         Metadata        at 1 range 1 .. 3;
         VAddress         at 1 range 4 .. 23;
      end record;

   Table_Size : constant Natural := 1024;

   subtype Table_Range is Natural range 0 .. (Table_Size - 1);

   type Page_Table is array (Table_Range) of Page_Table_Entry;

   type Page_Directory is array (Table_Range) of Page_Directory_Entry;
   for Page_Directory'Alignment use 16#1000#;

-- ----------  Descriptor tables  ---------------------

   type Granularity_Bit is (Byte, Page);
   for Granularity_Bit use (Byte => 0, Page => 1);
   for Granularity_Bit'Size use 1;

   type Size_Bit is (Sixteen_Bit, Thirtytwo_Bit);
   for Size_Bit use (Sixteen_Bit => 0, Thirtytwo_Bit => 1);
   for Size_Bit'Size use 1;

   type Privilege_Field is range 0 .. 3;
   for Privilege_Field'Size use 2;

   type Present_Bit is (Not_Present, Present);
   for Present_Bit use (Not_Present => 0, Present => 1);
   for Present_Bit'Size use 1;

   type Executable_Bit is (Data, Code);
   for Executable_Bit use (Data => 0, Code => 1);
   for Executable_Bit'Size use 1;

   type Direction_Bit is (Grow_Down, Grow_Up);

   for Direction_Bit use (Grow_Down => 0,
                          Grow_Up => 1);
   for Direction_Bit'Size use 1;

   type Conform_Bit is (Current_Privilege, Lower_Privilege);
   for Conform_Bit use (Current_Privilege => 0,
                        Lower_Privilege => 1);
   for Conform_Bit'Size use 1;

   type Read_Bit is (No, Yes);
   for Read_Bit use (No => 0,
                     Yes => 1);
   for Read_Bit'Size use 1;

   type Write_Bit is (No, Yes);
   for Write_Bit use (No => 0,
                      Yes => 1);
   for Write_Bit'Size use 1;

   type Access_Bit is (Accessed, Not_Accessed);
   for Access_Bit use (Accessed => 0,
                       Not_Accessed => 1);
   for Access_Bit'Size use 1;

   --  type Access_Field (Segment_Type : Executable_Bit) is
   --     record
   --        Present : Present_Bit;
   --        Privilege : Privilege_Field;
   --        Always_One : Flag := 1;
   --        Executable : Executable_Bit;
   --        Accessed : Access_Bit;
   --        case Segment_Type is
   --           when Code =>
   --              Conformity : Conform_Bit;
   --              Readable : Read_Bit;
   --           when Data =>
   --              Direction : Direction_Bit;
   --              Writable : Write_Bit;
   --        end case;
   --     end record;

   --  for Access_Field use
   --     record
   --        Present at 0 range 7 .. 7;
   --        Privilege at 0 range 5 .. 6;
   --        Always_One at 0 range 4 .. 4;
   --        Executable at 0 range 3 .. 3;
   --        Direction at 0 range 2 .. 2;
   --        Conformity at 0 range 2 .. 2;
   --        Readable at 0 range 1 .. 1;
   --        Writable at 0 range 1 .. 1;
   --        Accessed at 0 range 0 .. 0;
   --     end record;
   --  for Access_Field'Size use 8;

   type Global_Descriptor is
      record
         Base_Low : Unsigned_16;
         Base_Mid : Unsigned_8;
         Base_High : Unsigned_8;
         Limit_Low : Unsigned_16;
         Limit_High : Unsigned_4;
         Granularity : Granularity_Bit;
         Size : Size_Bit;
         Present : Present_Bit;
         Privilege : Privilege_Field;
         Always_One : Flag := 1;
         Executable : Executable_Bit;
         Accessed : Access_Bit;
         Direction : Flag;
         Readable : Flag;
         --  case Segment_Type is
         --     when Code =>
         --        Conformity : Conform_Bit;
         --        Readable : Read_Bit;
         --     when Data =>
         --        Direction : Direction_Bit;
         --        Writable : Write_Bit;
         --  end case;
      end record;

   for Global_Descriptor use
      record
         Limit_Low      at 0 range 0 .. 15;
         Base_Low       at 2 range 0 .. 15;
         Base_Mid       at 4 range 0 .. 7;
         Accessed       at 5 range 0 .. 0;
         Readable       at 5 range 1 .. 1;
--       Writable       at 5 range 1 .. 1;
         Direction      at 5 range 2 .. 2;
--       Conformity     at 5 range 2 .. 2;
         Executable     at 5 range 3 .. 3;
         Always_One     at 5 range 4 .. 4;
         Privilege      at 5 range 5 .. 6;
         Present        at 5 range 7 .. 7;
         Limit_High     at 6 range 0 .. 3;

         Size           at 6 range 6 .. 6;
         Granularity    at 6 range 7 .. 7;
         Base_High      at 7 range 0 .. 7;
      end record;
   for Global_Descriptor'Size use 64;
   for Global_Descriptor'Alignment use 8;

   type GDT_Length is range 0 .. 8191;
   type GDT is array (GDT_Length range <>) of Global_Descriptor;

end Kernel.Data_Structures;
