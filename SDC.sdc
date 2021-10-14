
#комментить для КТЦ электроинки
#derive_clock_uncertainty 
#------------------------------



# клок АЦП 100 МГц
create_clock -period 10 \
	-name {CLKFromADC} \
	[get_ports {CLKFromADC}]
	
# клок генератора 100 МГц
create_clock -period 10 \
	-name {CLKFromGen} \
	[get_ports {CLKFromGen}]
	
set_clock_groups -exclusive -group {CLKFromADC} -group {CLKFromGen}  



create_generated_clock -source [get_ports {CLKFromGen}] \
	-divide_by 2 \
	[get_registers {MainPar:inst1|ClockGen:inst2|CLKDividedCount~I}]

	create_generated_clock -source [get_ports {CLKFromADC}] \
	-divide_by 2 \
	[get_registers {MainPar:inst1|ClockGen:inst2|ClockPosHalf~I}]	
	
create_generated_clock -source [get_registers {MainPar:inst1|ClockGen:inst2|CLKDividedCount~I}] \
	-divide_by 2 \
	[get_registers {MainPar:inst1|ClockGen:inst2|CLKDividedPos~I}]	

	
	