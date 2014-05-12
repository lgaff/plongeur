--  with Ada.Unchecked_Conversion;
--  with System.Address_To_Access_Conversions;
with CPU;
with Interfaces; use Interfaces;

use type CPU.Interrupt_Register_File;

package Interrupts is

   type Interrupt_Handler is access procedure
      (Registers : in CPU.Interrupt_Register_File);

   type ISR_Register_Type is
      array (Unsigned_32 range 0 .. 255) of Interrupt_Handler;

   procedure Register_Interrupt_Handler (Index : in Unsigned_32;
                                         Handler : in Interrupt_Handler);

--   package Convert is new  System.Address_To_Access_Conversions
--        (Object => Interrupt_Handler);
--   function To_Handler is new Ada.Unchecked_Conversion
--     (Source => Convert.Object_Pointer,
--      Target => Interrupt_Handler);

   procedure Fault_Handler (Registers : in CPU.Interrupt_Register_File);
   procedure Irq_Handler (Registers : in CPU.Interrupt_Register_File);

   pragma Export (C, Fault_Handler, "fault_handler");
   pragma Export (C, Irq_Handler, "irq_handler");

private
   ISR_Register : ISR_Register_Type;
end Interrupts;
