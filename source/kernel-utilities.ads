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
   type Double_Double is record
      Low_Double : Unsigned_32;
      High_Double : Unsigned_32;
   end record;
   for Double_Double'Size use 64;

   type Double_Word is record
      Low_Word : Unsigned_16;
      High_Word : Unsigned_16;
   end record;
   for Double_Word'Size use 32;

   type Double_Byte is record
      Low_Byte : Unsigned_8;
      High_Byte : Unsigned_8;
   end record;
   for Double_Byte'Size use 16;

   function To_Double_Double is new Ada.Unchecked_Conversion
      (Source => Unsigned_64,
       Target => Double_Double);

   function To_Double_Word is new Ada.Unchecked_Conversion
      (Source => Unsigned_32,
       Target => Double_Word);

   function To_Double_Word is new Ada.Unchecked_Conversion
      (Source => Standard.Integer,
       Target => Double_Word);

   function To_Double_Word is new Ada.Unchecked_Conversion
      (Source => System.Address,
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

   function To_Address is new Ada.Unchecked_Conversion
      (Source => Unsigned_32,
       Target => System.Address);

   function To_Integer is new Ada.Unchecked_Conversion
      (Source => System.Address,
       Target => Integer);

   function To_Integer is new Ada.Unchecked_Conversion
      (Source => Unsigned_32,
       Target => Integer);

   function To_Page_Table_Entry is new Ada.Unchecked_Conversion
     (Source => Unsigned_32,
      Target => Page_Table_Entry);

   function PDE_To_PTE is new Ada.Unchecked_Conversion
      (Source => Page_Directory_Entry,
       Target => Page_Table_Entry);

   function Align_Address (Physical_Address : Unsigned_32)
                                return Page_Address;

--  private
--     type Page_Conversion_Median is record
--        Virtual_Address : Page_Address;
--        Padding : Unsigned_12;
--     end record;
   procedure Magic_Break;
end Kernel.Utilities;
