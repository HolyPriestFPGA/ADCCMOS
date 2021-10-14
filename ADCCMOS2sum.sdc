
#derive_clock_uncertainty #комментить для ПО КТЦ Электроинки, раскоменчивать для TimeQuest

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
	-divide_by 4			\
	-source [get_ports {CLKFromGen}] \
	-name {Fast}	\
	
create_generated_clock	\
	-divide_by 2			\
	-source [get_registers {MainControlNew:inst10|CLKDividedCount~I}] \
	-name {Pos}	\
	[get_registers {MainControlNew:inst10|CLKDividedPos~I}]
	

	
#set_max_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[1]~I}] 5
#set_min_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[1]~I}] 5
	
#set_max_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[2]~I}] 5
#set_min_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[2]~I}] 5

#set_max_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[3]~I}] 5
#set_min_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[3]~I}] 5

#set_max_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[4]~I}] 5
#set_min_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[4]~I}] 5

#set_max_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[5]~I}] 5
#set_min_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[5]~I}] 5

#set_max_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[6]~I}] 5
#set_min_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[6]~I}] 5

#set_max_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[7]~I}] 5
#set_min_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[7]~I}] 5

#set_max_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[8]~I}] 5
#set_min_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[8]~I}] 5

#set_max_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[9]~I}] 5
#set_min_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[9]~I}] 5

#set_max_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[10]~I}] 5
#set_min_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[10]~I}] 5

#set_max_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[11]~I}] 5
#set_min_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[11]~I}] 5

#set_max_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[12]~I}] 5
#set_min_delay -from [get_registers {MainControlNew:inst10|AddrWrite[0]~I}] -to [get_registers {MainControlNew:inst10|AddrWrite[12]~I}] 5