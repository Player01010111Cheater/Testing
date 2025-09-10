local old
old = hookfunction(warn, newcclosure(function (mesg)
    return old(mesg)
end))
