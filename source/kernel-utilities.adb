package body Kernel.Utilities is
   function Physical_To_Virtual (Physical_Address : System.Address)
                                return Page_Address is
      Temp : Unsigned_32 := 0;
   begin
      Temp := To_Unsigned_32 (Physical_Address);
      return Page_Address (Temp mod 2 ** 20);
   end Physical_To_Virtual;
end Kernel.Utilities;
