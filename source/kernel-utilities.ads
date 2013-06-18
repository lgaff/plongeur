--  Module      : Kernel.Utilities
--  Description : Utility functions for data conversions and raw IO
--  Author      : Lindsay Gaff
--  Email       : lindsaygaff@gmail.com
--  License     : Unrestricted
-------------------------------------------------------------------------------
with Kernel.Data_Structures; use Kernel.Data_Structures;
with Ada.Unchecked_Conversion;
with System;

package Kernel.Utilities is
   function To_Global_Descriptor is new Ada.Unchecked_Conversion
     (Source => Unsigned_64,
      Target => Global_Descriptor);

   function To_Unsigned_32 is new Ada.Unchecked_Conversion
     (Source => System.Address,
      Target => Unsigned_32);

   function To_Page_Table_Entry is new Ada.Unchecked_Conversion
     (Source => Unsigned_32,
      Target => Page_Table_Entry);

   function Align_Address (Physical_Address : Unsigned_32)
                                return Page_Address;

--  private
--     type Page_Conversion_Median is record
--        Virtual_Address : Page_Address;
--        Padding : Unsigned_12;
--     end record;
end Kernel.Utilities;
