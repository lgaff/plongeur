with Kernel.Data_Structures; use Kernel.Data_Structures;
with CPU;
use type CPU.Interrupt_Register_File;

package Kernel.Initialisation is
   Kernel_Page_Directory : Page_Directory;
   Identity_Mapped_Table : Page_Table;
   P_To_V_Map : Page_Table;

   procedure Trap_Interrupt;
   pragma Import (C, Trap_Interrupt, "trap_interrupt");

   procedure Go_To_Higher_Half (Directory : in out Page_Directory;
                               Table : out Page_Table);

   procedure Default_Interrupt_Handler
      (Registers : in CPU.Interrupt_Register_File);

   procedure Initialise_Interrupts;

private
   Page_Is_Present : constant Flag := 16#1#;
   Page_Is_Writable : constant Flag := 16#1#;
   Kernel_Fake_Base : constant Unsigned_32 := 16#40000000#;
end Kernel.Initialisation;
