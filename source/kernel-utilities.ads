--  Module      : Kernel.Utilities
--  Description : Utility functions for data conversions and raw IO
--  Author      : Lindsay Gaff
--  Email       : lindsaygaff@gmail.com
--  License     : Unrestricted
-------------------------------------------------------------------------------
with Kernel.Data_Structures; use Kernel.Data_Structures;
with Ada.Unchecked_Conversion;

package Kernel.Utilities is
   function To_Global_Descriptor is new Ada.Unchecked_Conversion
     (Source => Unsigned_64,
      Target => Global_Descriptor);
end Kernel.Utilities;
