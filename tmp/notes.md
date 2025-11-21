[Open Sdc.tcl line 324](file:///Users/advaysingh/Documents/Silimate/OpenSTA/sdc/Sdc.tcl#L324)

return patternMatch(pattern\_, str)

(lldb) expr name(child)
(const char _) $1 = 0x0000000154e37440 "blk_u1"
(lldb) expr pathName(child)
(const char _) $2 = 0x0000000154e377e0 "u_blk1/blk_u1"

void
Network::findInstancesHierMatching1(const Instance *instance,
const PatternMatch *pattern,
InstanceSeq &matches) const
{
InstanceChildIterator *child_iter = childIterator(instance);
while (child_iter->hasNext()) {
Instance *child = child_iter->next();
if (pattern->match(name(child)))
matches.push_back(child);
if (!isLeaf(child))
findInstancesHierMatching1(child, pattern, matches);
}
delete child_iter;
}

returns false

proc get_cells { args } {
global hierarchy_separator

parse_key_args "get_cells" args keys {-hsc -filter -of_objects} \
 flags {-hierarchical -regexp -nocase -quiet}
check_nocase_flag flags

set regexp [info exists flags(-regexp)]
set nocase [info exists flags(-nocase)]
set hierarchical [info exists flags(-hierarchical)]
set quiet [info exists flags(-quiet)]

# Copy backslashes that will be removed by foreach.

if { $args == {} } {
    set patterns "*"
  } else {
    set patterns [string map {\\ \\\\} [lindex $args 0]]
  }
  set divider $hierarchy_separator
  if [info exists keys(-hsc)] {
    set divider $keys(-hsc)
    check_path_divider $divider
  }
  set insts {}
  if [info exists keys(-of_objects)] {
    if { $args != {} } {
      sta_warn 348 "patterns argument not supported with -of_objects."
    }
    parse_port_pin_net_arg $keys(-of_objects) pins nets
    foreach pin $pins {
      if { [$pin is_top_level_port] } {
set net [get_nets [get_name $pin]]
if { $net != "NULL" } {
	  lappend nets $net
	}
      } else {
	lappend insts [$pin instance]
}
}
foreach net $nets {
      set pin_iter [$net pin_iterator]
while { [$pin_iter has_next] } {
set pin [$pin_iter next]
lappend insts [$pin instance]
}
$pin_iter finish
    }
  } else {
    check_argc_eq0or1 "get_cells" $args
    foreach pattern $patterns {
      if { [is_object $pattern] } {
	if { [object_type $pattern] != "Instance" } {
	  sta_error 326 "object '$pattern' is not an instance."
}
set insts [concat $insts $pattern]
} else {
if { $divider != $hierarchy_separator } {
	  regsub $divider $pattern $hierarchy_separator pattern
	}
	if { $hierarchical } {
	  set matches [find_instances_hier_matching $pattern $regexp $nocase]
	} else {
	  set matches [find_instances_matching $pattern $regexp $nocase]
	}
	if { $matches == {} && !$quiet} {
sta_warn 349 "instance '$pattern' not found."
}
set insts [concat $insts $matches]
}
}
}
if [info exists keys(-filter)] {
set insts [filter_objs $keys(-filter) $insts filter_insts "instance"]
}
return $insts
}

debugger output:

- thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 2.1
  - frame #0: 0x000000010072587c sta`sta::PatternMatch::match(this=0x000000016fdfe738, str="in2") const at PatternMatch.cc:146:7
frame #1: 0x000000010042e3a8 sta`sta::Network::findPortsMatching(this=0x000000015270ee70, cell=0x0000000143fce9b0, pattern=0x000000016fdfe738) const at Network.cc:125:20
    frame #2: 0x000000010044fae8 sta`sta::SdcNetwork::findPortsMatching(this=0x0000000152711ba0, cell=0x0000000143fce9b0, pattern=0x000000016fdfe738) const at SdcNetwork.cc:707:31
frame #3: 0x000000010000655c sta`find_port_pins_matching(pattern="clk1", regexp=false, nocase=false) at StaAppTCL_wrap.cxx:3373:28
    frame #4: 0x00000001000797c8 sta`_wrap_find_port_pins_matching(clientData=0x0000000000000000, interp=0x000000015301e010, objc=4, objv=0x0000000153022f00) at StaAppTCL_wrap.cxx:20437:16
frame #5: 0x0000000102470680 libtcl8.6.dylib`TclNRRunCallbacks + 80
    frame #6: 0x0000000102471424 libtcl8.6.dylib`TclEvalEx + 1668
frame #7: 0x0000000102471da4 libtcl8.6.dylib`Tcl_Eval + 40
    frame #8: 0x0000000100172a98 sta`sta::sourceTclFile(filename="./tmp/test/preCommands.tcl", echo=false, verbose=false, interp=0x000000015301e010) at StaMain.cc:105:14
frame #9: 0x0000000100004b9c sta`staTclAppInit(argc=2, argv=0x000000016fdfefc8, init_filename=".sta", interp=0x000000015301e010) at Main.cc:160:15
    frame #10: 0x0000000100004964 sta`tclAppInit(interp=0x000000015301e010) at Main.cc:111:10
frame #11: 0x0000000102517070 libtcl8.6.dylib`Tcl_MainEx + 708
    frame #12: 0x000000010000484c sta`main(argc=2, argv=0x000000016fdfefc8) at Main.cc:102:5
frame #13: 0x000000018bbd50e0 dyld`start + 2360

Where the cells are being called

(lldb) image lookup -rn cells
14 matches found in /Users/advaysingh/Documents/Silimate/OpenSTA/build/sta:
Address: sta[0x00000001000acc3c] (sta.**TEXT.**text + 689380)
Summary: sta`_wrap_filter_lib_cells(void*, Tcl_Interp*, int, Tcl_Obj* const*) at StaAppTCL_wrap.cxx:32437        Address: sta[0x0000000100045c30] (sta.__TEXT.__text + 267480)
        Summary: sta`\_wrap_Library_find_cells_matching(void*, Tcl_Interp*, int, Tcl_Obj* const*) at StaAppTCL_wrap.cxx:15572 Address: sta[0x000000010000ff50] (sta.**TEXT.**text + 47096)
Summary: sta`filter_lib_cells(char const*, sta::Vector<sta::LibertyCell*>*, bool) at StaAppTCL_wrap.cxx:5412        Address: sta[0x0000000100005aa0] (sta.__TEXT.__text + 4936)
        Summary: sta`find_cells_matching(char const*, bool, bool) at StaAppTCL_wrap.cxx:3275 Address: sta[0x0000000100073950] (sta.**TEXT.**text + 455160)
Summary: sta`\_wrap_equiv_cells(void*, Tcl_Interp*, int, Tcl_Obj* const*) at StaAppTCL_wrap.cxx:15028 Address: sta[0x000000010007331c] (sta.**TEXT.**text + 453572)
Summary: sta`\_wrap_make_equiv_cells(void*, Tcl_Interp*, int, Tcl_Obj* const*) at StaAppTCL_wrap.cxx:14945 Address: sta[0x000000010003e364] (sta.**TEXT.**text + 236556)
Summary: sta`\_wrap_LibertyLibrary_find_liberty_cells_matching(void*, Tcl_Interp*, int, Tcl_Obj* const*) at StaAppTCL_wrap.cxx:11191 Address: sta[0x0000000100005660] (sta.**TEXT.**text + 3848)
Summary: sta`equiv_cells(sta::LibertyCell*, sta::LibertyCell*) at StaAppTCL_wrap.cxx:2976 Address: sta[0x0000000100073624] (sta.**TEXT.**text + 454348)
Summary: sta`\_wrap_find_equiv_cells(void*, Tcl_Interp*, int, Tcl_Obj* const*) at StaAppTCL_wrap.cxx:14985 Address: sta[0x0000000100077700] (sta.**TEXT.**text + 470952)
Summary: sta`\_wrap_find_cells_matching(void*, Tcl_Interp*, int, Tcl_Obj* const*) at StaAppTCL_wrap.cxx:20033 Address: sta[0x00000001000054ec] (sta.**TEXT.**text + 3476)
Summary: sta`make_equiv_cells(sta::LibertyLibrary*) at StaAppTCL_wrap.cxx:2961 Address: sta[0x0000000100005638] (sta.**TEXT.**text + 3808)
Summary: sta`find_equiv_cells(sta::LibertyCell*) at StaAppTCL_wrap.cxx:2969        Address: sta[0x000000010003faac] (sta.__TEXT.__text + 242516)
        Summary: sta`LibertyLibrary_find_liberty_cells_matching(sta::LibertyLibrary*, char const*, bool, bool) at StaAppTCL_wrap.cxx:2726 Address: sta[0x00000001000462d8] (sta.**TEXT.**text + 269184)
Summary: sta`Library_find_cells_matching(sta::Library*, char const*, bool, bool) at StaAppTCL_wrap.cxx:3048

842 Network::findChildrenMatching(const Instance *parent,
843 const PatternMatch *pattern,
844 InstanceSeq &matches) const
845 {
846 if (pattern->hasWildcards()) {
(lldb) frame
Commands for selecting and examing the current thread's stack frames.

Syntax: frame <subcommand> [<subcommand-options>]

The following subcommands are supported:

      diagnose   -- Try to determine what path the current stop location used to get to a
                    register or address
      info       -- List information about the current stack frame in the current thread.
      recognizer -- Commands for editing and viewing frame recognizers.
      select     -- Select the current stack frame by index from within the current thread
                    (see 'thread backtrace'.)
      variable   -- Show variables for the current stack frame. Defaults to all arguments
                    and local variables in scope. Names of argument, local, file static and
                    file global variables can be specified.

For more help on any particular subcommand, type 'help <command> <subcommand>'.
(lldb) frame list
invalid command 'frame list'.
(lldb) frame select 0
frame #0: 0x000000010510987c sta`sta::PatternMatch::match(this=0x000000016b41aaf0, str="blk*u1") const at PatternMatch.cc:146:7
143 bool
144 PatternMatch::match(const char \*str) const
145 {
-> 146 if (regexp*)
147 return Tcl*RegExpExec(nullptr, regexp*, str, str) == 1;
148 else
149 return patternMatch(pattern\_, str)
(lldb) p str
(const char _) 0x0000000154e370e0 "blk_u1"
(lldb) expr str = "u_blk1/blk_u1"
(const char _) $3 = 0x00000001068dc600 "u_blk1/blk_u1"
(lldb) c
Process 12362 resuming
Process 12362 stopped

- thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.2
  frame #0: 0x000000010510987c sta`sta::PatternMatch::match(this=0x000000016b41aaf0, str="u*blk2") const at PatternMatch.cc:146:7
  143 bool
  144 PatternMatch::match(const char \*str) const
  145 {
  -> 146 if (regexp*)
  147 return Tcl*RegExpExec(nullptr, regexp*, str, str) == 1;
  148 else
  149 return patternMatch(pattern\_, str)
  Target 0: (sta) stopped.
  (lldb)  
  Process 12362 resuming
  Process 12362 stopped
- thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.2
  frame #0: 0x000000010510987c sta`sta::PatternMatch::match(this=0x000000016b41aaf0, str="blk*r3") const at PatternMatch.cc:146:7
  143 bool
  144 PatternMatch::match(const char \*str) const
  145 {
  -> 146 if (regexp*)
  147 return Tcl*RegExpExec(nullptr, regexp*, str, str) == 1;
  148 else
  149 return patternMatch(pattern\_, str)
  Target 0: (sta) stopped.
  (lldb)  
  Process 12362 resuming
  Process 12362 stopped
- thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.2
  frame #0: 0x000000010510987c sta`sta::PatternMatch::match(this=0x000000016b41aaf0, str="blk*u2") const at PatternMatch.cc:146:7
  143 bool
  144 PatternMatch::match(const char \*str) const
  145 {
  -> 146 if (regexp*)
  147 return Tcl*RegExpExec(nullptr, regexp*, str, str) == 1;
  148 else
  149 return patternMatch(pattern\_, str)
  Target 0: (sta) stopped.
