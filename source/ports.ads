--  Module      : Ports
--  Description : Utility functions for data conversions and raw IO
--  Author      : Lindsay Gaff
--  Email       : lindsaygaff@gmail.com
--  License     : Unrestricted
-------------------------------------------------------------------------------
package Ports is
   procedure Out (Port : Unsigned_16;
                  Value : Unsigned_8);
   procedure Out (Port : in Unsigned_16;
                  Value : in Unsigned_16);
   function In (Port : in Unsigned_16) return Unsigned_16;
   function In (Port : in Unsigned_16) return Unsigned_8;
end Ports;