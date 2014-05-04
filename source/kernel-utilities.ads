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
   type Double_Word is record
      High_Word : Unsigned_16;
      Low_Word : Unsigned_16;
   end record;
   for Double_Word'Size use 32;

   type Double_Byte is record
      High_Byte : Unsigned_8;
      Low_Byte : Unsigned_8;
   end record;
   for Double_Byte'Size use 16;

   function To_Double_Word is new Ada.Unchecked_Conversion
      (Source => Unsigned_32,
       Target => Double_Word);

   function To_Double_Word is new Ada.Unchecked_Conversion
      (Source => Standard.Integer,
       Target => Double_Word);

   function To_Double_Byte is new Ada.Unchecked_Conversion
      (Source => Unsigned_16,
       Target => Double_Byte);

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
   procedure Write_Port (Port : Unsigned_16;
                  Value : Unsigned_8);
   procedure Write_Port (Port : in Unsigned_16;
                  Value : in Unsigned_16);
   function Read_Port (Port : in Unsigned_16) return Unsigned_16;
   function Read_Port (Port : in Unsigned_16) return Unsigned_8;
   procedure Magic_Break;
end Kernel.Utilities;
