with Interfaces; use Interfaces;
with System;
with Ada.Unchecked_Conversion;

package Kernel is

      Cksum : Unsigned_32 := 16#DEAD#;
      Kernel_Fake_Base : constant Natural := 0x40000000;
end Kernel;
