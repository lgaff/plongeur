with Kernel.Data_Structures; use Kernel.Data_Structures;

package Kernel.Initialisation is
   Kernel_Page_Directory : Page_Directory;
   Identity_Mapped_Table : Page_Table;
   P_To_V_Map : Page_Table;

   --  These don't belong here, but I want to satisfy the linker for now
   procedure Fault_Handler;
   procedure Irq_Handler;
   procedure Trap_Interrupt;
   pragma Import (C, Trap_Interrupt, "trap_interrupt");
   pragma Export (C, Fault_Handler, "fault_handler");
   pragma Export (C, Irq_Handler, "irq_handler");
   procedure Go_To_Higher_Half (Directory : in out Page_Directory;
                               Table : out Page_Table);
   procedure PDE_As_PTE (Directory : in out Page_Directory;
                         Table : out Page_Table);
private
   Page_Is_Present : constant Flag := 16#1#;
   Page_Is_Writable : constant Flag := 16#1#;
   Kernel_Fake_Base : constant Unsigned_32 := 16#40000000#;
end Kernel.Initialisation;
