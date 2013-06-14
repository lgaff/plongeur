with Kernel.Data_Structures; use Kernel.Data_Structures;
with Interfaces; use Interfaces;

package Kernel.Initialisation is

   Boot_Page_Directory : Page_Directory;

   procedure Paging_Install;

   procedure GDT_Install;
   
private
   Kernel_Fake_Base : constant Natural := 0x40000000;
end Kernel.Initialisation;
