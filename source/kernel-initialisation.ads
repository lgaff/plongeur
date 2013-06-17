with Kernel.Data_Structures; use Kernel.Data_Structures;

package Kernel.Initialisation is

   Kernel_Page_Directory : Page_Directory;
   Identity_Mapped_Table : Page_Table;

   procedure Go_To_Higher_Half (Directory : in out Page_Directory;
                               Table : out Page_Table);

private
   Page_Is_Present : constant Flag := 16#1#;
   Page_Is_Writable : constant Flag := 16#1#;
   Kernel_Fake_Base : constant Page_Address := 2#10000000000000000000#;
end Kernel.Initialisation;
