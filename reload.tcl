proc reload {{mol {top}}} {

    if {$mol == "top"} {set mol [molinfo top]}

    set newmol -1

    ## Save represenations and viewpoints
    save_rep 99999 $mol
    save_viewpoint 99999 $mol

    ## Get filenames
    set fnames {*}[molinfo $mol get filename]

    lassign $fnames f1
    ## Load the first file
    if {[catch {mol new $f1 waitfor all} newmol]} {
        vmdcon -err "Reload: $newmol"
    }

    ## Load the remaining files
    foreach f [lrange $fnames 1 end] {
        if {[catch {mol addfile $f waitfor all molid $newmol} err]} {
            vmdcon -err "Reload: $err"
        }
    }

    restore_rep 99999 0 $newmol
    cpy_viewpoint 99999 $mol $newmol

    ## Delete old mol
    mol delete $mol

    return $newmol

}
