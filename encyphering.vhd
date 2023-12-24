library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity encyphering is
    port (
        PC : IN INTEGER;
        KEY : in std_logic_vector(55 downto 0); -- Initial key for encryption
        CODE : in std_logic_vector(63 downto 0);
        CYPHERTEXT : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
end entity encyphering;

architecture rtl of encyphering is
    SIGNAL C_TEMP : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL D_TEMP : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL C : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL D : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL K : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL LPT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL RPT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL RE : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL KEY_COUNTER : INTEGER := 0;

    PROCEDURE SHIFT(SIGNAL C : INOUT STD_LOGIC_VECTOR(27 DOWNTO 0);
                            SIGNAL D : INOUT STD_LOGIC_VECTOR(27 DOWNTO 0);
                            SIGNAL C_TEMP : INOUT STD_LOGIC_VECTOR(27 DOWNTO 0);
                            SIGNAL D_TEMP : INOUT STD_LOGIC_VECTOR(27 DOWNTO 0);
                            SIGNAL KEY_COUNTER : INOUT INTEGER) IS
    BEGIN
        IF KEY_COUNTER = 1 THEN 
            C <= C_TEMP(26 DOWNTO 0) & C_TEMP(27);
            D <= D_TEMP(26 DOWNTO 0) & D_TEMP(27);
        ELSIF KEY_COUNTER = 2 THEN 
            C <= C_TEMP(26 DOWNTO 0) & C_TEMP(27);
            D <= D_TEMP(26 DOWNTO 0) & D_TEMP(27);
        ELSIF KEY_COUNTER = 9 THEN 
            C <= C_TEMP(26 DOWNTO 0) & C_TEMP(27);
            D <= D_TEMP(26 DOWNTO 0) & D_TEMP(27);
        ELSIF KEY_COUNTER = 16 THEN 
            C <= C_TEMP(26 DOWNTO 0) & C_TEMP(27);
            D <= D_TEMP(26 DOWNTO 0) & D_TEMP(27);
        ELSE
            C <= C_TEMP(25 DOWNTO 0) & C_TEMP(27 DOWNTO 26);
            D <= D_TEMP(25 DOWNTO 0) & D_TEMP(27 DOWNTO 26);
        END IF;
    END PROCEDURE;

    PROCEDURE KEY_EXPANSION(SIGNAL C : INOUT STD_LOGIC_VECTOR(27 DOWNTO 0);
                            SIGNAL D : INOUT STD_LOGIC_VECTOR(27 DOWNTO 0);
                            SIGNAL K : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0)) IS
    BEGIN
        K <= C(13) & C(16) & C(10) & C(23) & C(0) & C(4) & C(2) & C(27) & C(14) & C(5) & C(20) & C(9)
            & C(22) & C(18) & C(11) & C(3) & C(25) & C(7) & C(15) & C(6) & C(26) & C(19) & C(12) & C(1)
            & D(12) & D(23) & D(2) & D(8) & D(18) & D(26) & D(1) & D(11) & D(22) & D(16) & D(4) & D(19)
            & D(15) & D(20) & D(10) & D(27) & D(5) & D(24) & D(17) & D(13) & D(21) & D(7) & D(0) & D(3);
    END PROCEDURE;

    PROCEDURE R_EXPANSION(SIGNAL RPT : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                            SIGNAL RE : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0)) IS
    BEGIN
        RE <= RPT(31) & RPT(0) & RPT(1) & RPT(2) & RPT(3) & RPT(4) & RPT(3) & RPT(4) & RPT(5) & RPT(6) & RPT(7) & RPT(8)
            & RPT(7) & RPT(8) & RPT(9) & RPT(10) & RPT(11) & RPT(12) & RPT(11) & RPT(12) & RPT(13) & RPT(14) & RPT(15) & RPT(16)
            & RPT(15) & RPT(16) & RPT(17) & RPT(18) & RPT(19) & RPT(20) & RPT(19) & RPT(20) & RPT(21) & RPT(22) & RPT(23) & RPT(24)
            & RPT(23) & RPT(24) & RPT(25) & RPT(26) & RPT(27) & RPT(28) & RPT(27) & RPT(28) & RPT(29) & RPT(30) & RPT(31) & RPT(0);
    END PROCEDURE;

    PROCEDURE XORR(SIGNAL K : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
                            SIGNAL RE : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0)) IS
    BEGIN
        RE <= RE XOR K;
    END PROCEDURE;

    PROCEDURE PARSING(SIGNAL LPT : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        SIGNAL RPT : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        SIGNAL RE : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0)) IS
    BEGIN
        RPT <= LPT;
        LPT <= RE(31 DOWNTO 0);
    END PROCEDURE;

begin
    PROC : PROCESS (PC)
    BEGIN
        C_TEMP <= KEY(55 DOWNTO 28);
        D_TEMP <= KEY(27 DOWNTO 0);
        LPT <= CODE(63 DOWNTO 32);
        RPT <= CODE(31 DOWNTO 0);

        FOR I IN 1 TO 16 LOOP
            SHIFT(C, D, C_TEMP, D_TEMP, KEY_COUNTER);
            KEY_EXPANSION(C, D, K);
            R_EXPANSION(RPT, RE);
            XORR(K, RE);
            PARSING(LPT, RPT, RE);
            KEY_COUNTER <= KEY_COUNTER + 1;
        END LOOP;
        CYPHERTEXT <= LPT & RPT;
    END PROCESS;
    

end architecture rtl;