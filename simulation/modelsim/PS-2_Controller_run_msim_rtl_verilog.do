transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Chris/Documents/TEC/Taller/Proyecto/PS-2_Controller {C:/Users/Chris/Documents/TEC/Taller/Proyecto/PS-2_Controller/keyboard_controller.sv}
vlog -sv -work work +incdir+C:/Users/Chris/Documents/TEC/Taller/Proyecto/PS-2_Controller {C:/Users/Chris/Documents/TEC/Taller/Proyecto/PS-2_Controller/kb_controller_tb.sv}

