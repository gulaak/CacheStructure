----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2019 09:29:19 PM
-- Design Name: 
-- Module Name: CacheStruct - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CacheStruct is
    Port ( Address : in STD_LOGIC_VECTOR (9 downto 0);
           CLK: in STD_LOGIC;
           ren : in STD_LOGIC;
           evict: out STD_LOGIC;
           wren: in STD_LOGIC;
           Cache_in: in STD_LOGIC_VECTOR(31 downto 0);
           Cache_out: out STD_LOGIC_VECTOR (31 downto 0);
           Write : out STD_LOGIC;
           hit : out STD_LOGIC);
end CacheStruct;

architecture Behavioral of CacheStruct is
-- Cache data LRU bit + Dirty Bit + Valid + Tag(4 bits) + CacheData(32 bits) = 
type cache_one is array (63 downto 0) of STD_LOGIC_VECTOR (38 downto 0);
type cache_two is array (63 downto 0) of STD_LOGIC_VECTOR (38 downto 0);
type cache_three is array (63 downto 0) of STD_LOGIC_VECTOR (38 downto 0);
type cache_four is array (63 downto 0) of STD_LOGIC_VECTOR (38 downto 0);
signal cacheone: cache_one:= (OTHERS=>(OTHERS=>'0'));
signal cachetwo: cache_two:= (OTHERS=>(OTHERS=>'0'));
signal cachethree: cache_three:=(OTHERS=>(OTHERS=>'0'));
signal cachefour: cache_four:=(OTHERS=>(OTHERS=>'0'));
signal tag: STD_LOGIC_VECTOR(3 downto 0):= (OTHERS => '0');
signal index: STD_LOGIC_VECTOR(5 downto 0):= (OTHERS=>'0');

signal missFlag: STD_LOGIC:='0';
signal temp: STD_LOGIC:='0';
begin

tag <= Address(9 downto 6);
index <= Address(5 downto 0);

process(CLK,ren)
variable curr: INTEGER := 0;
begin
    curr:= to_integer(unsigned(index));
    if(rising_edge(CLK)) then
       if(ren = '1') then
           temp <= not(cacheone(curr)(36) or cachetwo(curr)(36) or cachethree(curr)(36) or cachefour(curr)(36));
           if(temp = '1') then
                hit <= '0';
           
           else
              
                if(cacheone(curr)(36)='1' and tag = cacheone(curr)(35 downto 32)) then
                    hit <= '1';
                    cache_out <= cacheone(curr)(31 downto 0);
                elsif(cachetwo(curr)(36) = '1' and tag = cachetwo(curr)(35 downto 32)) then
                    cache_out <= cachetwo(curr)(31 downto 0);
                    hit <= '1';
                elsif(cachethree(curr)(36) = '1' and tag = cachetwo(curr)(35 downto 32)) then
                    cache_out <= cachethree(curr)(31 downto 0);
                    hit <= '1';
                else
                    cache_out <= cachefour(curr)(31 downto 0);
                    hit <= '1';
                end if;
           end if;
                    
       end if;
            
                    
            
    end if;

end process;

process(CLK,wren)
variable curr: INTEGER:=0;
begin
    curr:= to_integer(unsigned(index));
    if(rising_edge(CLK)) then 
            if(wren = '1') then
                temp <= (cacheone(curr)(36) and cachetwo(curr)(36) and cachethree(curr)(36) and cachefour(curr)(36));
                if(temp = '1') then
                    evict <= '1';
                else
                    if(cacheone(curr)(36)='0') then
                        cacheone(curr)(31 downto 0) <= cache_in;
                        cacheone(curr)(36) <= '1';
                    elsif(cachetwo(curr)(36)='0') then
                        cachetwo(curr)(31 downto 0) <= cache_in;
                         cachetwo(curr)(36) <= '1';
                    elsif(cachethree(curr)(36)='0') then
                        cachethree(curr)(31 downto 0) <= cache_in;
                        cachethree(curr)(36) <= '1';
                    else
                        cachefour(curr)(31 downto 0) <= cache_in;
                        cacheone(curr)(36) <= '1';
                    end if;
                end if;
             end if;
     end if;
                    
            
    
end process;



end Behavioral;
