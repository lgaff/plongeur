--  Module: kernel.initialisation
--  Description: Procedures and data relating to initialisation of
--               the plongeur system environment
--  Author: Lindsay Gaff <lindsaygaff@gmail.com>
--------------------------------------------------------------------

with Paging; use Paging;
with Interfaces; use Interfaces;
with Kernel;

package body Kernel.Initialisation is
   
   procedure Paging_Install is
      
