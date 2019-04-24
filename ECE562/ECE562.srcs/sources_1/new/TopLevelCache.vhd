----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2019 05:40:47 PM
-- Design Name: 
-- Module Name: TopLevelCache - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopLevelCache is
    Port ( CLK,Read,Write : in STD_LOGIC;
           DataIn : in STD_LOGIC_VECTOR (31 downto 0);
           Address : in STD_LOGIC_VECTOR (9 downto 0);
           DataOut : out STD_LOGIC_VECTOR (31 downto 0);
           Ready: out STD_LOGIC);
end TopLevelCache;

architecture Behavioral of TopLevelCache is
component CacheController
     Port ( CLK,Wren,Hit,Evict,Ren,RamDone,Dirty : in STD_LOGIC;
            Write,Read,RamWr,RamRead,DirtyOut,RamSel,CacheSel,Cache_Ready: out STD_LOGIC);
end component;

component MainMemory
     port(CLK, Wren:in STD_LOGIC;
       
         Address:in STD_LOGIC_VECTOR(9 downto 0);
         data_in:in STD_LOGIC_VECTOR(31 downto 0);
         data_out:out STD_LOGIC_VECTOR(31 downto 0);
         ram_ready:out STD_LOGIC := '0'
     );
end component;

component CacheStruct
     Port ( Address : in STD_LOGIC_VECTOR (9 downto 0);
           CLK: in STD_LOGIC;
           ren,CacheDirty : in STD_LOGIC;
           evict,Dirty: out STD_LOGIC;
           wren: in STD_LOGIC;
           Cache_in: in STD_LOGIC_VECTOR(31 downto 0);
           Cache_out: out STD_LOGIC_VECTOR (31 downto 0);
           hit : out STD_LOGIC);
end component;
signal addTemp: STD_LOGIC_VECTOR(9 downto 0);
signal hit,evict,RamDone,Dirty,CacheWrite,CacheRead,RamWrite,RamRead,CacheDirty,RamSel,CacheWriteSel: STD_LOGIC;
signal CacheOutData: STD_LOGIC_VECTOR(31 downto 0);
signal RamData,RamIn: STD_LOGIC_VECTOR(31 downto 0);
signal CacheIn: STD_LOGIC_VECTOR(31 downto 0);
begin



UnitOne: CacheController port map(CLK => CLK,
                                  Wren => Write,
                                  Hit => hit,
                                  evict => evict,
                                  Ren => Read, 
                                  RamDone=>RamDone,
                                  Dirty => Dirty,
                                  Write => CacheWrite,
                                  Read => CacheRead,
                                  RamWr=>RamWrite,
                                  RamRead=>RamRead,
                                  DirtyOut => CacheDirty,
                                  RamSel=>RamSel,
                                  CacheSel => CacheWriteSel,
                                  Cache_Ready => Ready);
                                  
UnitTwo: MainMemory port map(CLK => CLK,
                             Wren => RamWrite,
                             Address => Address,
                             data_in => RamIn,
                             data_out => RamData,
                             ram_ready => RamDone);
                             
UnitThree: CacheStruct port map(Address => Address,
                                CLK => CLK,
                                ren => CacheRead,
                                CacheDirty => CacheDirty,
                                evict => evict,
                                Dirty => Dirty,
                                wren => CacheWrite,
                                Cache_in => CacheIn,
                                Cache_out => CacheOutData,
                                hit => hit);
                                
                                
with CacheWriteSel select CacheIn <=
        DataIn when '0',
        RamData when '1',
        (OTHERS => 'Z') when OTHERS;
                                          



process(CLK,RamSel)

begin

if(RamSel = '0') then
      DataOut <= CacheOutData;
else
      RamIn <= CacheOutData;
end if;


end process;                         
                                  
                                  
                                  
                                  
  



end Behavioral;
