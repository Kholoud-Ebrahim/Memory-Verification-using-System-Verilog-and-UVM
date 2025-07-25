`include "utils_pkg.sv"

package memory_pkg;
	import utils_pkg::*;
	export utils_pkg::*;

	`include "memory_seq_item.svh"
  `include "memory_sqr.svh"
  `include "memory_drv.svh"
  `include "memory_mon.svh"
  `include "memory_scb.svh"
	`include "memory_env.svh"
endpackage:memory_pkg