
#derive_clock_uncertainty #комментить для КТЦ электроинки

# клок АЦП 100 МГц
create_clock -period 10 \
	-name {CLKFromADC} \
	[get_ports {CLKFromADC}]
	
# клок генератора 100 МГц
create_clock -period 10 \
	-name {CLKFromGen} \
	[get_ports {CLKFromGen}]
	
set_clock_groups -exclusive -group {CLKFromADC} -group {CLKFromGen}  


create_generated_clock	\
	-divide_by 14			\
	-source [get_ports {CLKFromGen}] \
	-name {Fast}	\
	[get_registers {MainHalfControl:inst7|CLKDividedCount~I}]
	
create_generated_clock	\
	-divide_by 2			\
	-source [get_ports {CLKFromADC}] \
	-name {PosHalf}	\
	[get_registers {DividerHalf:inst3|ClockPosHalf~I}]
	
create_generated_clock	\
	-divide_by 2			\
	-source [get_registers {MainHalfControl:inst7|CLKDividedCount~I}] \
	-name {Pos}	\
	[get_registers {MainHalfControl:inst7|CLKDividedPos~I}]
	
	

	