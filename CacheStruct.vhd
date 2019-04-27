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
           ren,CacheDirty : in STD_LOGIC;
           evict,Dirty: out STD_LOGIC;
           wren: in STD_LOGIC;
           Cache_in: in STD_LOGIC_VECTOR(31 downto 0);
           Cache_out: out STD_LOGIC_VECTOR (31 downto 0);
           hit : out STD_LOGIC);
end CacheStruct;

architecture Behavioral of CacheStruct is
-- Cache data LRU bit + Dirty Bit + Valid + Tag(4 bits) + CacheData(32 bits) = 
type cache_data is array (63 downto 0) of STD_LOGIC_VECTOR (37 downto 0);
type lru_count is array(63 downto 0) of INTEGER range 0 to 3;
signal cacheone: cache_data:= (OTHERS=>(OTHERS=>'0'));
signal cachetwo: cache_data:= (OTHERS=>(OTHERS=>'0'));
signal cachethree: cache_data:=(OTHERS=>(OTHERS=>'0'));
signal cachefour: cache_data:=(OTHERS=>(OTHERS=>'0'));
signal lruOne: lru_count:=(OTHERS=> 0 );
signal lruTwo: lru_count:=(OTHERS=> 1);
signal lruThree: lru_count:=(OTHERS=> 2);
signal lruFour : lru_count:=(OTHERS=> 3);
signal tag: STD_LOGIC_VECTOR(3 downto 0):= (OTHERS => '0');
signal index: STD_LOGIC_VECTOR(5 downto 0):= (OTHERS=>'0');
signal counterVal: INTEGER range 0 to 3:=0;
signal missFlag: STD_LOGIC:='0';
signal temp,temp2: STD_LOGIC:='0';
signal curr: INTEGER range 0 to 64:=0;
begin

tag <= Address(9 downto 6);
index <= Address(5 downto 0);
temp <= not(cacheone(curr)(36) or cachetwo(curr)(36) or cachethree(curr)(36) or cachefour(curr)(36));
temp2 <= cacheone(curr)(36) and cachetwo(curr)(36) and cachethree(curr)(36) and cachefour(curr)(36);
process(CLK,ren,wren)

begin
    
    curr <= to_integer(unsigned(index));
    if(rising_edge(CLK)) then
       evict <= '0';
       hit <= '0';
       dirty <= '0';
       if(ren = '1') then
           
           if(temp = '1') then
                hit <= '0';
                evict <= '0';
                dirty <= '0';
           else
                if(cacheone(curr)(36)='1' and tag = cacheone(curr)(35 downto 32)) then
                    if(lruOne(curr)= 0) then
                        lruOne(curr) <= 3;
                        lruTwo(curr) <= lruTwo(curr)-1;
                        lruThree(curr) <= lruThree(curr)-1;
                        lruFour(curr) <= lruFour(curr)-1;
                    elsif(lruOne(curr) = 1 or lruOne(curr)=2) then
                        counterVal <= lruOne(curr);
                        lruOne(curr) <= 3;
                        if(lruTwo(curr) > counterVal) then
                            lruTwo(curr) <= lruTwo(curr)-1;
                        end if;
                        if(lruThree(curr) > counterVal) then
                            lruThree(curr) <= lruThree(curr)-1;
                        end if;
                        if(lruFour(curr) > counterVal) then
                            lruFour(curr) <= lruFour(curr)-1;
                        end if;
                    end if;
                    hit <= '1';
                    cache_out <= cacheone(curr)(31 downto 0);
                elsif(cachetwo(curr)(36) = '1' and tag = cachetwo(curr)(35 downto 32)) then
                    if(lruTwo(curr)= 0) then
                        lruOne(curr) <= lruOne(curr)-1;
                        lruTwo(curr) <= 3;
                        lruThree(curr) <= lruThree(curr)-1;
                        lruFour(curr) <= lruFour(curr)-1;
                    elsif(lruTwo(curr) = 1 or lruTwo(curr)=2) then
                        counterVal <= lruTwo(curr);
                        lruTwo(curr) <= 3;
                        if(lruOne(curr) > counterVal) then
                            lruOne(curr) <= lruOne(curr)-1;
                        end if;
                        if(lruThree(curr) > counterVal) then
                            lruThree(curr) <= lruThree(curr)-1;
                        end if;
                        if(lruFour(curr) > counterVal) then
                            lruFour(curr) <= lruFour(curr)-1;
                        end if;
                    end if;
                    cache_out <= cachetwo(curr)(31 downto 0);
                    hit <= '1';
                elsif(cachethree(curr)(36) = '1' and tag = cachetwo(curr)(35 downto 32)) then
                    if(lruThree(curr)= 0) then
                        lruOne(curr) <= lruOne(curr)-1;
                        lruTwo(curr) <= lruTwo(curr)-1;
                        lruThree(curr) <= 3;
                        lruFour(curr) <= lruFour(curr)-1;
                    elsif(lruThree(curr) = 1 or lruThree(curr)=2) then
                        counterVal <= lruThree(curr);
                        lruThree(curr) <= 3;
                        if(lruTwo(curr) > counterVal) then
                            lruTwo(curr) <= lruTwo(curr)-1;
                        end if;
                        if(lruOne(curr) > counterVal) then
                            lruOne(curr) <= lruOne(curr)-1;
                        end if;
                        if(lruFour(curr) > counterVal) then
                            lruFour(curr) <= lruFour(curr)-1;
                        end if;
                    end if;
                    cache_out <= cachethree(curr)(31 downto 0);
                    hit <= '1';
                else
                        if(lruFour(curr)= 0) then
                            lruOne(curr) <= lruOne(curr)-1;
                            lruTwo(curr) <= lruTwo(curr)-1;
                            lruThree(curr) <= lruThree(curr)-1;
                            lruFour(curr) <= 3;
                        elsif(lruFour(curr) = 1 or lruFour(curr)=2) then
                            counterVal <= lruFour(curr);
                            lruFour(curr) <= 3;
                            if(lruTwo(curr) > counterVal) then
                                lruTwo(curr) <= lruTwo(curr)-1;
                            end if;
                            if(lruThree(curr) > counterVal) then
                                lruThree(curr) <= lruThree(curr)-1;
                            end if;
                            if(lruOne(curr) > counterVal) then
                                lruOne(curr) <= lruOne(curr)-1;
                            end if;
                    cache_out <= cachefour(curr)(31 downto 0);
                    hit <= '1';
                end if;
           end if;
          end if;
       end if;
          if(wren = '1') then
                
                if(temp2 = '1') then
                   
                    evict <= '1';
                    if(lruOne(curr) = 0 ) then
                        dirty <= cacheone(curr)(37);
                        Cache_out <= cacheone(curr)(31 downto 0);
                        cacheone(curr)(36) <= '0';
                    elsif(lruTwo(curr) = 0) then
                        dirty <= cachetwo(curr)(37);
                        Cache_out <= cachetwo(curr)(31 downto 0);
                        cachetwo(curr)(36) <= '0';
                    elsif(lruThree(curr) =0) then
                        dirty <= cachethree(curr)(37);
                        Cache_out <= cachethree(curr)(31 downto 0);
                        cachethree(curr)(36) <= '0';
                    else
                        dirty <= cachefour(curr)(37);
                        Cache_out <= cachefour(curr)(31 downto 0);
                        cachethree(curr)(36) <= '0';
                    end if;
                else
                    evict <= '0';
                    dirty <= '0';
                    if(lruOne(curr) =0) then
                        lruOne(curr) <= 3;
                        lruTwo(curr) <= lruTwo(curr)-1;
                        lruThree(curr) <= lruThree(curr) -1;
                        lruFour(curr) <= lruFour(curr)-1;
                        cacheone(curr)(31 downto 0) <= cache_in;
                        cacheone(curr)(36) <= '1';
                        cacheone(curr)(35 downto 32) <= tag;
                        if(CacheDirty = '1') then
                            cacheone(curr)(37) <= '1'; --dirty bit
                        end if;
                    elsif(lruTwo(curr) =0) then
                        lruTwo(curr) <= 3;
                        lruOne(curr) <= lruOne(curr)-1;
                        lruThree(curr) <= lruThree(curr) -1;
                        lruFour(curr) <= lruFour(curr)-1;
                        cachetwo(curr)(31 downto 0) <= cache_in;
                        cachetwo(curr)(36) <= '1';
                        cachetwo(curr)(35 downto 32) <= tag;
                        if(CacheDirty = '1') then
                            cachetwo(curr)(37) <= '1'; --dirty bit
                        end if;
                    elsif(lruThree(curr) =0) then
                        lruTwo(curr) <= lruTwo(curr)-1;
                        lruOne(curr) <= lruOne(curr)-1;
                        lruThree(curr) <= 3;
                        lruFour(curr) <= lruFour(curr)-1;
                        cachethree(curr)(31 downto 0) <= cache_in;
                        cachethree(curr)(36) <= '1';
                        cachethree(curr)(35 downto 32) <= tag;
                        if(CacheDirty = '1') then
                            cachethree(curr)(37) <= '1'; --dirty bit
                        end if;
                    else
                        lruTwo(curr) <= lruTwo(curr)-1;
                        lruOne(curr) <= lruOne(curr)-1;
                        lruThree(curr) <= lruThree(curr) -1;
                        lruFour(curr) <= 3;
                        cachefour(curr)(31 downto 0) <= cache_in;
                        cachefour(curr)(36) <= '1';
                        cachefour(curr)(35 downto 32) <= tag;
                        if(CacheDirty = '1') then
                            cachefour(curr)(37) <= '1'; --dirty bit
                        end if;
                    end if;
                end if;
             end if;
                    
       
            
                    
            
    end if;

end process;



end Behavioral;
