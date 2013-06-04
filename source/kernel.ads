with Interfaces; use Interfaces;
with System;
with Ada.Unchecked_Conversion;

package Kernel is
      function To_Unsigned_32 is new Ada.Unchecked_Conversion
     (Source => System.Address,
      Target => Unsigned_32);

   Cksum : Unsigned_32 := 16#DEAD#;
end Kernel;
