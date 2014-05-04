--  Module: kernel.initialisation
--  Description: Procedures and data relating to initialisation of
--  the plongeur system environment
--  Author: Lindsay Gaff <lindsaygaff@gmail.com>
--------------------------------------------------------------------
with Kernel; use Kernel;
with Kernel.Utilities; use Kernel.Utilities;

with System.Machine_Code; use System.Machine_Code;

package body Kernel.Initialisation is

   procedure Go_To_Higher_Half (Directory : in out Page_Directory;
                                  Table : out Page_Table) is
      Page_K : Page_Address := 0;
      Fake_Address : Unsigned_32 := 0;
      Page_Aligned_Address : Page_Address := 0;
      Page_Directory_Address : Unsigned_32 := 0;
      use ASCII;
   begin
      for K in Table_Range loop
         Page_K := Page_Address (K);
         Table (K) := (VAddress => Page_K,
                       Metadata => 0,
                       Global => 0,
                       Dirty => 0,
                       Access_Bit => 0,
                       Cache_Disable => 0,
                       Write_Through => 0,
                       Ring_Access => 0,
                       Read_Write => Page_Is_Writable,
                       Page_Present => Page_Is_Present);
      end loop;

      Fake_Address := Kernel_Fake_Base + To_Unsigned_32 (Table'Address);
      Page_Aligned_Address := Align_Address (Fake_Address);
      --  Entries 0 and 768 correspond to physical blocks 0-4MiB and
      --  3072 - 3076 MiB in the virtual space. All of our kernel code
      --  is physically in the first 4 MiB, so we need to Identity map
      --  this, and place the identical page entry at 3 GiB to get us to
      --  the higher half. After this, we invalidate the zeroth entry.
      Directory (0) := (VAddress => Page_Aligned_Address,
                        Metadata => 0,
                        Page_Size => 0,
                        Access_Bit => 0,
                        Cache_Disable => 0,
                        Write_Through => 0,
                        Ring_Access => 0,
                        Page_Present => Page_Is_Present,
                        Read_Write => Page_Is_Writable);
      Directory (768) := (VAddress => Page_Aligned_Address,
                          Metadata => 0,
                          Page_Size => 0,
                          Access_Bit => 0,
                          Cache_Disable => 0,
                          Write_Through => 0,
                          Ring_Access => 0,
                          Page_Present => Page_Is_Present,
                          Read_Write => Page_Is_Writable);

      Page_Directory_Address := Kernel_Fake_Base +
        To_Unsigned_32 (Directory'Address);

      Asm ("mov %0, %%eax" & LF & HT &
           "mov %%eax, %%cr3" & LF & HT &
           "mov %%cr0, %%eax" & LF & HT &
           "orl $0x80000000, %%eax" & LF & HT &
           "mov %%eax, %%cr0",
          Inputs => Unsigned_32'Asm_Input ("m",
                    Page_Directory_Address),
          Volatile => True);
   end Go_To_Higher_Half;
end Kernel.Initialisation;
