set BURST_SIZE 256

proc poke_hex {ADDR DATA} {
            create_hw_axi_txn wr_txn [get_hw_axis hw_axi_1] -address $ADDR -data $DATA -type write -force 
            run_hw_axi wr_txn
}

proc peek_hex {ADDR} {
        create_hw_axi_txn rd_txn [get_hw_axis hw_axi_1] -address $ADDR -type read -force 
        run_hw_axi rd_txn
        set length_v [string length [get_property DATA [get_hw_axi_txns rd_txn]]]
        set ret_val 0x[format "%0.8X" 0x[string range [get_property DATA [get_hw_axi_txns rd_txn]] 0 [expr $length_v - 1] ]]
        #puts "DBG:: SRAI : $ret_val"
        return $ret_val
}

proc fpoke_hex {ADDR in_file_name} {
    global BURST_SIZE
    set fp_r [open $in_file_name r]
    set data_list {}
    set count 0 
    set transaction_count 0
    set ADDR_wr $ADDR
    while {[gets $fp_r line] >= 0} {
        lappend data_list 0x[format "%0.8X" [expr $line]]
        incr transaction_count
        if {$count < [expr $BURST_SIZE - 1] } {
            incr count
        } else {
            #puts "DBG :: $ADDR_wr :: $data_list"
            create_hw_axi_txn wr_txn [get_hw_axis hw_axi_1] -address $ADDR_wr -data $data_list -len $BURST_SIZE -type write -force 
            set ADDR_wr 0x[format "%0.8X" [expr $ADDR_wr + ($BURST_SIZE * 4)]]
            run_hw_axi wr_txn
            set data_list {}
            set count 0 
        }
    }
    if {$count != 0 } {
        #puts "DBG :: $ADDR_wr"
        create_hw_axi_txn wr_txn [get_hw_axis hw_axi_1] -address $ADDR_wr -data $data_list -len $count -type write -force 
        set ADDR_wr 0x[format "%0.8X" [expr $ADDR_wr + ($count * 4)]]
        run_hw_axi wr_txn
    }
    puts "$transaction_count transactions written"
    close $fp_r
}
proc fpoke_int {ADDR in_file_name} {
    global BURST_SIZE
    set fp_r [open $in_file_name r]
    set data_list {}
    set count 0 
    set transaction_count 0
    set ADDR_wr $ADDR
    while {[gets $fp_r line] >= 0} {
        lappend data_list 0x[format "%0.8X" $line]
        incr transaction_count
        if {$count < [expr $BURST_SIZE - 1] } {
            incr count
        } else {
            #puts "DBG :: $ADDR_wr :: $data_list"
            create_hw_axi_txn wr_txn [get_hw_axis hw_axi_1] -address $ADDR_wr -data $data_list -len $BURST_SIZE -type write -force 
            set ADDR_wr 0x[format "%0.8X" [expr $ADDR_wr + ($BURST_SIZE * 4)]]
            run_hw_axi wr_txn
            set data_list {}
            set count 0 
        }

    }
    if {$count != 0 } {
        #puts "DBG :: $ADDR_wr"
        create_hw_axi_txn wr_txn [get_hw_axis hw_axi_1] -address $ADDR_wr -data $data_list -len $count -type write -force 
        set ADDR_wr 0x[format "%0.8X" [expr $ADDR_wr + ($count * 4)]]
        run_hw_axi wr_txn
    }
    puts "$transaction_count transactions written"
    close $fp_r
}
proc fpeek_int {ADDR num_transations out_file_name} {
    global BURST_SIZE
    set fp_w [open $out_file_name w]
    set count $num_transations
    set ADDR_rd $ADDR

    while {$count > $BURST_SIZE } {
        #puts "DBG :: $ADDR_rd"
        create_hw_axi_txn rd_txn [get_hw_axis hw_axi_1] -address $ADDR_rd -len $BURST_SIZE -type read -force 
        set ADDR_rd 0x[format "%0.8X" [expr $ADDR_rd + ($BURST_SIZE * 4)]]
        run_hw_axi rd_txn
        set length_v [string length [get_property DATA [get_hw_axi_txns rd_txn]]]
        for {set i [expr $length_v-1] } { $i > 0} {set i [expr $i - 8] } {
            set ret_val [format "%d" 0x[string range [get_property DATA [get_hw_axi_txns rd_txn]] [expr $i-7] $i] ]
            puts $fp_w $ret_val
        }
        set count [expr $count - $BURST_SIZE] 
    }
    if {$count != 0 } {
        #puts "DBG :: $ADDR_rd"
        create_hw_axi_txn rd_txn [get_hw_axis hw_axi_1] -address $ADDR_rd -len $count -type read -force 
        set ADDR_rd 0x[format "%0.8X" [expr $ADDR_rd + ($count * 4)]]
        run_hw_axi rd_txn
        set length_v [string length [get_property DATA [get_hw_axi_txns rd_txn]]]
        for {set i [expr $length_v-1] } { $i > 0} {set i [expr $i - 8] } {
            set ret_val [format "%d" 0x[string range [get_property DATA [get_hw_axi_txns rd_txn]] [expr $i-7] $i] ]
            puts $fp_w $ret_val
        }
    }
    puts "$num_transations transactions read"
    close $fp_w
}
proc fpeek_hex {ADDR num_transations out_file_name} {
    global BURST_SIZE
    set fp_w [open $out_file_name w]
    set count $num_transations
    set ADDR_rd $ADDR

    while {$count > $BURST_SIZE } {
        #puts "DBG :: $ADDR_rd"
        create_hw_axi_txn rd_txn [get_hw_axis hw_axi_1] -address $ADDR_rd -len $BURST_SIZE -type read -force 
        set ADDR_rd 0x[format "%0.8X" [expr $ADDR_rd + ($BURST_SIZE * 4)]]
        run_hw_axi rd_txn
        set length_v [string length [get_property DATA [get_hw_axi_txns rd_txn]]]
        for {set i [expr $length_v-1] } { $i > 0} {set i [expr $i - 8] } {
            set ret_val 0x[format "%0.8X" 0x[string range [get_property DATA [get_hw_axi_txns rd_txn]] [expr $i-7] $i] ]
            puts $fp_w $ret_val
        }
        set count [expr $count - $BURST_SIZE] 
    }
    if {$count != 0 } {
        #puts "DBG :: $ADDR_rd"
        create_hw_axi_txn rd_txn [get_hw_axis hw_axi_1] -address $ADDR_rd -len $count -type read -force 
        set ADDR_rd 0x[format "%0.8X" [expr $ADDR_rd + ($count * 4)]]
        run_hw_axi rd_txn
        set length_v [string length [get_property DATA [get_hw_axi_txns rd_txn]]]
        for {set i [expr $length_v-1] } { $i > 0} {set i [expr $i - 8] } {
            set ret_val 0x[format "%0.8X" 0x[string range [get_property DATA [get_hw_axi_txns rd_txn]] [expr $i-7] $i] ]
            puts $fp_w $ret_val
        }
    }
    puts "$num_transations transactions read"
    close $fp_w
}

proc fpoke_bin {ADDR in_file_name} {
    global BURST_SIZE
    set fp_r [open $in_file_name r]
    set data_list {}
    set transaction_count 0
    set count 0 
    set ADDR_wr $ADDR
    fconfigure $fp_r -translation binary -encoding binary -buffering full -buffersize 16384

    while { 1 } {
        # __SRAI read 4 bytes at a time
        set s [read $fp_r 4]
        if { [string length $s] == 0 } {
            break
        } else {
            # __SRAI scan a HEX string with 8 hex characters 
            binary scan $s H* hex
            set hex_string 0x[string range $hex 0 8]
            lappend data_list 0x[format "%0.8X" $hex_string]
            incr transaction_count
            #puts "DBG ::: $hex_string"
            if {$count < [expr $BURST_SIZE - 1] } {
                incr count
            } else {
                #puts "DBG :: $ADDR_wr :: $data_list"
                create_hw_axi_txn wr_txn [get_hw_axis hw_axi_1] -address $ADDR_wr -data $data_list -len $BURST_SIZE -type write -force 
                set ADDR_wr 0x[format "%0.8X" [expr $ADDR_wr + ($BURST_SIZE * 4)]]
                run_hw_axi wr_txn
                set data_list {}
                set count 0 
            }
        }
    }
    if {$count != 0 } {
        #puts "DBG :: $ADDR_wr"
        create_hw_axi_txn wr_txn [get_hw_axis hw_axi_1] -address $ADDR_wr -data $data_list -len $count -type write -force 
        set ADDR_wr 0x[format "%0.8X" [expr $ADDR_wr + ($count * 4)]]
        run_hw_axi wr_txn
    }
    puts "$transaction_count transactions written"
    close $fp_r
}

proc fpeek_bin {ADDR num_transations out_file_name} {
    global BURST_SIZE
    set fp_w [open $out_file_name w]
    set data_list {}
    set count $num_transations
    set ADDR_rd $ADDR
    fconfigure $fp_w -translation binary -encoding binary -buffering full -buffersize 16384

    while {$count > $BURST_SIZE } {
        #puts "DBG :: $ADDR_rd"
        create_hw_axi_txn rd_txn [get_hw_axis hw_axi_1] -address $ADDR_rd -len $BURST_SIZE -type read -force 
        set ADDR_rd 0x[format "%0.8X" [expr $ADDR_rd + ($BURST_SIZE * 4)]]
        run_hw_axi rd_txn
        set length_v [string length [get_property DATA [get_hw_axi_txns rd_txn]]]
        for {set i [expr $length_v-1] } { $i > 0} {set i [expr $i - 8] } {
            set ret_val [string range [get_property DATA [get_hw_axi_txns rd_txn]] [expr $i-7] $i]
            #puts "DBG : $ret_val"
            puts -nonewline $fp_w [binary format H8 $ret_val]
        }
        set count [expr $count - $BURST_SIZE] 
    }
    if {$count != 0 } {
        #puts "DBG :: $ADDR_rd"
        create_hw_axi_txn rd_txn [get_hw_axis hw_axi_1] -address $ADDR_rd -len $count -type read -force 
        set ADDR_rd 0x[format "%0.8X" [expr $ADDR_rd + ($count * 4)]]
        run_hw_axi rd_txn
        set length_v [string length [get_property DATA [get_hw_axi_txns rd_txn]]]
        for {set i [expr $length_v-1] } { $i > 0} {set i [expr $i - 8] } {
            set ret_val [string range [get_property DATA [get_hw_axi_txns rd_txn]] [expr $i-7] $i]
            #puts "DBG : $ret_val"
            puts -nonewline $fp_w [binary format H8 $ret_val]
        }
    }

    puts "$num_transations transactions read"
    close $fp_w
}
