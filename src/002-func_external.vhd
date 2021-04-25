library IEEE;
use IEEE.STD_LOGIC_1164.all;

package func_external is

function log2(input : integer) return integer;

end func_external;

package body func_external is
--------------------------------------------------------------------------------
--                    Implement function to calculate log2                    --
--------------------------------------------------------------------------------
function log2(input : integer) return integer is
	
variable temp,log:integer;
	begin
		temp:=input;
		log:=0;
		while(temp /= 0) loop
			temp:=temp/2;
			log:=log+1;
		end loop;

	return log;

end function log2;

end func_external;
