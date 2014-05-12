with Interfaces; use Interfaces;

package CPU is
   type Register_File is record
      DS : Unsigned_32;
      EDI : Unsigned_32;
      ESI : Unsigned_32;
      EBP : Unsigned_32;
      ESP : Unsigned_32;
      EDX : Unsigned_32;
      ECX : Unsigned_32;
      EBX : Unsigned_32;
      EAX : Unsigned_32;
   end record;

   --  The Interrupt register file has a few extensions
   --  that are pushed by the processor, plus
   --  some extra data that we're pushing in our interrupt vector code.
   type Interrupt_Register_File is record
      DS : Unsigned_32;
      EDI : Unsigned_32;
      ESI : Unsigned_32;
      EBP : Unsigned_32;
      ESP : Unsigned_32;
      EDX : Unsigned_32;
      ECX : Unsigned_32;
      EBX : Unsigned_32;
      EAX : Unsigned_32;
      Interrupt_Number : Unsigned_32;
      Error_Code : Unsigned_32;
      EIP : Unsigned_32;
      CS : Unsigned_32;
      EFLAGS : Unsigned_32; --  TODO : Implement FLAGS record for this.
      UserESP : Unsigned_32;
      SS : Unsigned_32;
   end record;
end CPU;