LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MainMemory is
    port(CLK, Wren,Ren:in STD_LOGIC;
       
         Address:in STD_LOGIC_VECTOR(9 downto 0);
         data_in:in STD_LOGIC_VECTOR(31 downto 0);
         data_out:out STD_LOGIC_VECTOR(31 downto 0);
         ram_ready:out STD_LOGIC := '0'
     );
end MainMemory;

architecture behavorial_data_array of MainMemory is
    type array_data is array (0 to 1023) of STD_LOGIC_VECTOR (31 downto 0);
    signal data : array_data:=(OTHERS=>(OTHERS=>'1'));
    signal counter: integer range 0 to 20:=0;
begin
    
   

    process(clk,Wren)
    begin
        ram_ready <= '0';
        if(Wren = '1' and counter = 20) then
            data(to_integer(unsigned(Address))) <= data_in;
            ram_ready <= '1';
            counter <= 0;
        elsif(Ren = '1' and counter=20) then
            data_out <= data(to_integer(unsigned(address)));
            ram_ready <= '1';
            counter <= 0;
        elsif(Wren = '1' or Ren = '1') then
            counter <= counter+1;
        end if;

        

    end process;

end behavorial_data_array;
