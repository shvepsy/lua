local ck = require "resty.cookie"
local cookie, err = ck:new()

local uri = ngx.var.request_uri
local field, err = cookie:get("__ddg")                                                                                   --Get cookie

if uri == "/nocookies" then
  return ngx.say("Your browser does not support cookies")                                                               --If no cookies after check and redirected to "nocookies"
end

if not field then                                                                                                       -- If not cookie
  local uricheck = string.match(uri, "?uri=(.+)$")
  if uricheck then                                                                                                      --  If uri contain redirect flag 501 error
    return ngx.redirect(ngx.var.scheme .. "://" .. ngx.var.http_host .. "/nocookies")
  end
  local tohash = ngx.var.remote_addr
  tohash = tohash .. (ngx.var.http_user_agent)
  tohash = tohash .. "12bgv1gv321"
  local ghash = ngx.md5(tohash)

  local ok, err = cookie:set({                                                                                          --  Set cookie
    key = "__ddg", value = ghash, max_age = 15, path = "/"
  })

        local uri = ngx.var.request_uri                                                                                 --  Redirect to hashuri
        ghash = ghash .. "?uri=" .. uri
        local hashuri = "/" .. ghash
        return ngx.redirect(ngx.var.scheme .. "://" .. ngx.var.http_host .. hashuri,302)
else                                                                                                                    -- If exist cookie
  if ngx.var.request_uri ~=  field then
  local touri = string.match(uri, "?uri=(.+)$")
    if touri then
      return ngx.redirect(ngx.var.scheme .. "://" .. ngx.var.http_host .. touri)                                        --   Redirect to uri from hash uri
    end
  end
end
