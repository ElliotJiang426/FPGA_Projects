library verilog;
use verilog.vl_types.all;
entity clock_mem is
    generic(
        N               : integer := 2
    );
    port(
        clk_50M         : in     vl_logic;
        resetn          : in     vl_logic;
        memclk          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
end clock_mem;
