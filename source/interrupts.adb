with PIC;
with System.Machine_Code; use System.Machine_Code;

package body Interrupts is
   procedure Register_Interrupt_Handler (Index : in Unsigned_32;
                                         Handler : in Interrupt_Handler) is
   begin
      ISR_Register (Index) := Handler;
   end Register_Interrupt_Handler;

   procedure Fault_Handler (Registers : in CPU.Interrupt_Register_File) is
   pragma Unreferenced (Registers);
   begin
      loop
         Asm ("nop", Volatile => True);
      end loop;
   end Fault_Handler;

   procedure Irq_Handler (Registers : in CPU.Interrupt_Register_File) is
      Handler : Interrupt_Handler;
   begin
      --  We need to signal the PIC's that the interrupt is being handled.
      PIC.Send_EOI (Unsigned_8 (Registers.Interrupt_Number mod 16));

      Handler := ISR_Register (Registers.Interrupt_Number);
      Handler (Registers);

   end Irq_Handler;
end Interrupts;