--  Module      : Memory.paging
--  Description : Provides utilities and data structures for manipulating
--  the page table structure.
--  Author      : Lindsay Gaff
--  Email       : lindsaygaff@gmail.com
--  License     : Unrestricted
-------------------------------------------------------------------------------

package Paging is
   pragma Preelaborate (Paging);

   type Flag is range 0 .. 1;
   for Flag'Size use 1;

   type Page_Address is mod 2 ** 20;
   for Page_Address'Size use 20;

   type Page_Metadata is mod 2 ** 3;
   for Page_Metadata'Size use 3;

   type Page_Directory_Entry is
      record
         Address           : Page_Address;
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
         Address         at 1 range 4 .. 23;
      end record;

   type Page_Table_Entry is
      record
         Address           : Page_Address;
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
         Address         at 1 range 4 .. 23;
      end record;

   Table_Size : constant Natural := 1024;

   subtype Table_Range is Natural range 1 .. Table_Size;

   type Page_Table is array (Table_Range) of Page_Table_Entry;

   type Page_Directory is array (Table_Range) of Page_Table;
   for Page_Directory'Alignment use 16#1000#;

   Kernel_Page_Directory : Page_Directory;

   --  TODO:
   --  * Initialise paging (need to implement at least some of multiboot)
   --  * Identity paging for higher-half.
   --  * Page fault handler
   --  * Page invalidation
   --  * Page allocation
   --------------------------

end Paging;
