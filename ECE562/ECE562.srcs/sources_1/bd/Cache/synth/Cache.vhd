--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
--Date        : Sat Mar  9 13:35:19 2019
--Host        : DESKTOP-T2T1KVN running 64-bit major release  (build 9200)
--Command     : generate_target Cache.bd
--Design      : Cache
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Cache is
  port (
    Add : in STD_LOGIC_VECTOR ( 18 downto 0 );
    CLK : in STD_LOGIC;
    DOut : out STD_LOGIC_VECTOR ( 31 downto 0 );
    Din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    Ena : in STD_LOGIC;
    Wea : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of Cache : entity is "Cache,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=Cache,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of Cache : entity is "Cache.hwdef";
end Cache;

architecture STRUCTURE of Cache is
  component Cache_blk_mem_gen_0_2 is
  port (
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 );
    addra : in STD_LOGIC_VECTOR ( 18 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 31 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component Cache_blk_mem_gen_0_2;
  signal Add_1 : STD_LOGIC_VECTOR ( 18 downto 0 );
  signal CLK_1 : STD_LOGIC;
  signal Din_1 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Ena_1 : STD_LOGIC;
  signal Wea_1 : STD_LOGIC;
  signal blk_mem_gen_0_douta : STD_LOGIC_VECTOR ( 31 downto 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of CLK : signal is "xilinx.com:signal:clock:1.0 CLK.CLK CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of CLK : signal is "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN Cache_CLK, FREQ_HZ 100000000, PHASE 0.000";
  attribute X_INTERFACE_INFO of Din : signal is "xilinx.com:signal:data:1.0 DATA.DIN DATA";
  attribute X_INTERFACE_PARAMETER of Din : signal is "XIL_INTERFACENAME DATA.DIN, LAYERED_METADATA undef";
begin
  Add_1(18 downto 0) <= Add(18 downto 0);
  CLK_1 <= CLK;
  DOut(31 downto 0) <= blk_mem_gen_0_douta(31 downto 0);
  Din_1(31 downto 0) <= Din(31 downto 0);
  Ena_1 <= Ena;
  Wea_1 <= Wea;
blk_mem_gen_0: component Cache_blk_mem_gen_0_2
     port map (
      addra(18 downto 0) => Add_1(18 downto 0),
      clka => CLK_1,
      dina(31 downto 0) => Din_1(31 downto 0),
      douta(31 downto 0) => blk_mem_gen_0_douta(31 downto 0),
      ena => Ena_1,
      wea(0) => Wea_1
    );
end STRUCTURE;
