with Interfaces; use Interfaces;

package X86_IO is
   subtype Input_Port is Unsigned_16
      range Unsigned_16'First .. Unsigned_16'Last;

   subtype Output_Port is Unsigned_16
      range Unsigned_16'First .. Unsigned_16'Last;

   subtype IO_Port is Unsigned_16
      range Unsigned_16'First .. Unsigned_16'Last;

   procedure Write_Port (Port : Output_Port;
                  Value : Unsigned_8);
   procedure Write_Port (Port : in Output_Port;
                  Value : in Unsigned_16);
   function Read_Port (Port : in Input_Port) return Unsigned_16;
   function Read_Port (Port : in Input_Port) return Unsigned_8;

   procedure IO_Wait;
   pragma Inline (IO_Wait);
end X86_IO;