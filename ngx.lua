local ck = require "resty.cookie"
local cookie, err = ck:new()

uri = ngx.var.request_uri
local field, err = cookie:get("__ddg")                --Get cookie

function hashcalc()
  local tohash = ngx.var.remote_addr
  tohash = tohash .. (ngx.var.http_user_agent)
  tohash = tohash .. "12bgv1gv321"
  local ghash = ngx.md5(tohash)
  return ghash
end

function cookieset(ghash)
  local ok, err = cookie:set({
    key = "__ddg", value = ghash, max_age = 15, path = "/"
  })
end

function redtohash(ghash)
  local ghash = ghash .. "?uri=" .. uri
  local hashuri = "/" .. ghash
  return ngx.redirect(ngx.var.scheme .. "://" .. ngx.var.http_host .. hashuri,302)
end

function redtouri(touri)
  return ngx.redirect(ngx.var.scheme .. "://" .. ngx.var.http_host .. touri)
end

function redtonoc()
  local uricheck = string.match(uri, "?uri=(.+)$")
  if uricheck then
    return ngx.redirect(ngx.var.scheme .. "://" .. ngx.var.http_host .. "/nocookies")
  end
end

function nocookies()
    return ngx.say("Your browser does not support cookies")
end

if uri == "/nocookies" then
  return nocookies()                             --If no cookies after check and redirected to "nocookies"
end

if not field then                                --If not cookie
  redtonoc()                                     -- If uri contain redirect flag 501 error
  hash = hashcalc()                              -- Calc hash for cookie
  cookieset(hash)                                -- Set cookie
  redtohash(hash)                                -- Redirect to hashuri or nocookies
else                                             --If exist cookie
  if ngx.var.request_uri ~=  field then
  local suri = string.match(uri, "?uri=(.+)$")
    if suri then
      redtouri(suri)                             --  Redirect to uri from hash uri
    end
  end
end
