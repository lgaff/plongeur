package body PIC is
   procedure Initialise_Pics (Offset : in Unsigned_8) is
      Slave_Offset : constant Unsigned_8 := Offset + 8;
      Master_Mask : constant Unsigned_8 := Read_Port (Master_PIC.Data_Read);
      Slave_Mask : constant Unsigned_8 := Read_Port (Slave_PIC.Data_Read);
   begin
      Write_Port (Master_PIC.Command, Command_Initialise);
      IO_Wait;
      Write_Port (Master_PIC.Data_Write, Offset);
      IO_Wait;
      Write_Port (Master_PIC.Data_Write, Slave_At_IRQ2);
      IO_Wait;
      Write_Port (Master_PIC.Data_Write, Is_8086);
      IO_Wait;
      Write_Port (Master_PIC.Data_Write, Master_Mask);

      Write_Port (Slave_PIC.Command, Command_Initialise);
      IO_Wait;
      Write_Port (Slave_PIC.Data_Write, Slave_Offset);
      IO_Wait;
      Write_Port (Slave_PIC.Data_Write, Slave_ID);
      IO_Wait;
      Write_Port (Slave_PIC.Data_Write, Is_8086);
      IO_Wait;
      Write_Port (Slave_PIC.Data_Write, Slave_Mask);
   end Initialise_Pics;

   procedure Send_EOI (IRQ : in Interrupt_Request) is
   begin
      if IRQ >= 8 then
         Write_Port (Slave_PIC.Command, End_Of_Interrupt);
      end if;
      Write_Port (Master_PIC.Command, End_Of_Interrupt);
   end Send_EOI;
end PIC;