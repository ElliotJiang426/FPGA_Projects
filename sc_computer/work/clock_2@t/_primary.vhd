library verilog;
use verilog.vl_types.all;
entity clock_2T is
    port(
        inclk           : in     vl_logic;
        outclk          : out    vl_logic
    );
end clock_2T;
