pragma Restrictions (No_Obsolescent_Features);
--  TODO: This needs to be expanded and repackaged as a set of conversions.
with System.Machine_Code; use System.Machine_Code;
with Ada.Unchecked_Conversion;

package body Kernel is

   function To_Unsigned_32 is new Ada.Unchecked_Conversion
     (Source => System.Address,
      Target => Unsigned_32);

end Kernel;
