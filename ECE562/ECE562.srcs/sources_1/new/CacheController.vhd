----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2019 11:24:25 PM
-- Design Name: 
-- Module Name: CacheController - Behavioral
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

entity CacheController is
    Port ( CLK,Wren,Hit,Evict,Ren,RamDone,Dirty : in STD_LOGIC;
            Write,Read,RamWr,RamRead,DirtyOut,RamSel,CacheSel,cache_ready: out STD_LOGIC);
end CacheController;

architecture Behavioral of CacheController is
type state is (WaitForLow,Standby,CacheWrite,CacheRead,CacheDirty,BlockMemory);
signal next_state: state:=Standby;
signal miss_status: STD_LOGIC;
begin

process(CLK,Wren,Ren)

begin

if(falling_edge(CLK)) then
    
    case next_state is 
    
        when WaitForLow =>
            if(Wren = '0' and Ren ='0') then
                cache_ready <= '0';
                next_state <= Standby;
            end if;
        

        when Standby =>
            if(Wren = '0' and Ren = '0') then
                next_state <= Standby;
            elsif(Evict = '1' and Dirty = '1') then
                RamWr <= '1';
                RamSel <= '1';
                next_state <= CacheDirty;
         
            elsif(Evict = '1') then
                next_state <= CacheWrite;
            else
                if(Wren = '1') then
                    Write<= '1';
                    next_state <= CacheWrite;
                    DirtyOut <= '1';
                    CacheSel <= '0';
                else
                    Read <= '1';
                    next_state <= CacheRead;
                end if;
            end if;
        when CacheWrite =>
            Write <= '0';
            DirtyOut <= '0';
            CacheSel <= '0';
            if(Evict = '1' and Dirty = '1') then
                RamWr <= '1';
                RamSel <= '1';
                next_state <= CacheDirty;
            elsif(Evict = '1') then
                Write <= '1';
                next_state <= CacheWrite;
            elsif(miss_status = '1') then
                miss_status <= '0';
                Read <= '1';
                next_state <= CacheRead;
            else
                next_state <= WaitForLow;
            end if;
        
      
            
       
       
            
        when CacheRead =>
            Read <= '0';
            RamSel <= '0';
            if(hit='1') then
                cache_ready <= '1';
                next_state <= WaitForLow;
            else
                RamRead <= '1';
                CacheSel <= '1';
                next_state <= BlockMemory;
            end if;
              

 

    when BlockMemory =>
        if(RamDone = '1') then
           Write <= '1'; 
           next_state <= CacheWrite;
           CacheSel <= '1';
           miss_status <= '1';
        else
            next_state <= BlockMemory;
        end if;
           
        
--    when Eviction =>
--            if(Dirty = '1') then

--            else
--                next_state <= CacheWrite;
--            end if;
            
       
    when CacheDirty =>
            if(RamDone = '1') then
                Write <= '1';
                next_state <= CacheWrite;
                RamWr <= '0';
                RamSel <= '0';
            else
                next_state <= CacheDirty;
            end if;
      
               
   

    end case;
end if;


end process;


end Behavioral;
