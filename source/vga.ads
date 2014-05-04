--  Module: VGA
--  Description: Data types for the VGA display device
--  Author: Lindsay Gaff <lindsaygaff@gmail.com>
-------------------------------------------------------------------
with Interfaces; use Interfaces;

package VGA is
   --  These ports are constant.
   Attribute_Address_Register : constant Unsigned_16 := 16#3C0#;
   Attribute_Data_Write_Register : constant Unsigned_16 := 16#3C0#;
   Attribute_Data_Read_Register : constant Unsigned_16 := 16#3C1#;
   Input_Status_0_Register : constant Unsigned_16 := 16#3C2#;
   Miscellaneous_Output_Register : constant Unsigned_16 := 16#3C2#;
   Sequencer_Address_Register : constant Unsigned_16 := 16#3C4#;
   Sequencer_Data_Register : constant Unsigned_16 := 16#3C5#;
   DAC_State_Register : constant Unsigned_16 := 16#3C7#;
   DAC_Address_Read_Mode_Register : constant Unsigned_16 := 16#3C7#;
   DAC_Address_Write_Mode_Register : constant Unsigned_16 := 16#3C8#;
   DAC_Data_Register : constant Unsigned_16 := 16#3C9#;
   Feature_Control_Read_Register : constant Unsigned_16 := 16#3CA#;
   Miscellaneous_Output_Read_Register : constant Unsigned_16 := 16#3CC#;
   Graphics_Controller_Address_Register : constant Unsigned_16 := 16#3CE#;
   Graphics_Controller_Data_Register : constant Unsigned_16 := 16#3CF#;

   --  The locations of these ports are dependent on the mode.
   CRTC_Controller_Address_Register : Unsigned_16 := 16#3D4#;
   CRTC_Controller_Data_Register : Unsigned_16 := 16#3D5#;
   Input_Status_1_Register : Unsigned_16 := 16#3DA#;
   Feature_Control_Register : Unsigned_16 := 16#3DA#;

   --  VGA Controller address indices
   CRTC_Cursor_Location_High : constant Unsigned_8 := 16#E#;
   CRTC_Cursor_Location_Low : constant Unsigned_8 := 16#F#;

end VGA;