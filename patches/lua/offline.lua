local shell = require("shell")

local status, out, err = shell.execute("rm -fr /tmp/online.txt")
local status, out, err = shell.execute("wget http://redpitaya.com/robots.txt -O /tmp/online.txt 2> /dev/null")

fh,err = io.open("/tmp/online.txt", "r")
if not fh then
    ngx.status = 404
    fh:close()
    return ngx.exit(ngx.HTTP_NOT_FOUND)
end
line = fh:read()
if line == nil then
    ngx.status = 404
    fh:close()
    return ngx.exit(ngx.HTTP_NOT_FOUND)
else
    if line:find("agent") ~= nil then
        line2 = fh:read()
        if line2 ~= nil and line2:find("Disallow") ~= nil then
            ngx.say("OK")
        else
            ngx.status = 404
            fh:close()
            return ngx.exit(ngx.HTTP_NOT_FOUND)
        end
    else
        ngx.status = 404
        fh:close()
        return ngx.exit(ngx.HTTP_NOT_FOUND)
    end
end

