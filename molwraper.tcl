## Wrap the mol command with some convenient
## options

proc moll { args } {

    set retval -1

    set cmd [lindex $args 0]
    set newargs [lrange $args 1 end]

    switch -- $cmd {

        new {
            set filename [lindex $newargs 0]
            catch {mol new [file normalize [glob $filename]]\
                       {*}[lrange $newargs 1 end]} retval
        }

        addfile {

            lappend newargs waitfor all

            set filename [lindex $newargs 0]
            catch {mol addfile [file normalize [glob $filename]]\
                       {*}[lrange $newargs 1 end]} retval
        }

        -f {

            set retval [moll new [lindex $newargs 0]]

            ## Check for wildcards..
            foreach filename [lrange $newargs 1 end] {
                foreach f [striplist [lsort -dictionary [glob $filename]]] {
                    moll addfile $f
                }
            }
        }

        reload {
            if {[lsearch -ascii [info procs] reload] < 0} {
                return -code 1 "Reload command currently unavailable"
            }

            set retval [reload {*}$newargs]
        }

        default {set retval [mol {*}$args]}

    }

    return $retval
}
