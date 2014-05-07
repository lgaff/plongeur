--  Module      : PIC
--  Description : Driver and installation of the 8259 PICs.
--  Useful data here: http://www.thesatya.com/8259.html
--  Author      : Lindsay Gaff
--  Email       : lindsaygaff@gmail.com
--  License     : Unrestricted
-------------------------------------------------------------------------------
with X86_IO; use X86_IO;
with Interfaces; use Interfaces;

package PIC is
   Command_Initialise : constant Unsigned_8 := 16#11#;
   End_Of_Interrupt : constant Unsigned_8 := 16#20#;
   Slave_At_IRQ2 : constant Unsigned_8 := 16#04#;
   Slave_ID : constant Unsigned_8 := 16#02#;
   Is_8086 : constant Unsigned_8 := 16#01#;

   subtype Interrupt_Request is Unsigned_8 range 0 .. 15;

   type PIC is record
      Command : Output_Port;
      Data_Read : Input_Port;
      Data_Write : Output_Port;
   end record;

   Master_PIC : PIC :=
      (Command => Output_Port (16#20#),
       Data_Read => Input_Port (16#21#),
       Data_Write => Output_Port (16#21#));

   Slave_PIC : PIC :=
      (Command => Output_Port (16#A0#),
       Data_Read => Input_Port (16#A1#),
       Data_Write => Output_Port (16#A1#));

   procedure Initialise_Pics (Offset : in Unsigned_8);

--    procedure Disable_Pics;

   procedure Send_EOI (IRQ : in Interrupt_Request);

end PIC;