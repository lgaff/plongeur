--  Last chance handler for exception handling. According to osdev wiki, this
--  is the minimum requirement for exceptions, and also the best we'll get
--  without a full runtime

with System;

procedure Last_Chance_Handler
  (Source_Location : System.Address; Line : Integer);
pragma Export (C, Last_Chance_Handler, "__gnat_last_chance_handler");
