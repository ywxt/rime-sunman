-- encoding: utf-8

local pua_basic = {
    '','','','','','','','','','','','','','','','','','','','','','','',
    '','','','','','','','','','','','','','','','','','','','','','','',
    '','','','','','','','','','','','','','','','','','','','','','','',
    '','','','','','','','','','',''
}

local function exists(filter, text)
    for i in utf8.codes(text) do
        local c = utf8.codepoint(text, i)
        if filter(c) then
            return true
        end
    end
    return false
end

local function all(filter1, filter2, text)
    for i in utf8.codes(text) do
        local c = utf8.codepoint(text, i)
        if filter1(c) then
            if (not filter2(c)) then
                return false
            end
        end
    end
    return true
end

local function is_pua_basic(char)
    for _i, c in ipairs(pua_basic) do
        if char == utf8.codepoint(c) then
            return true
        end
    end
    return false
end

local function is_pua(char)
    return (char >= 0xE000 and char <= 0xF8FF) or
    (char >= 0xF0000 and char <= 0xFFFFD) or
    (char >= 0x100000 and char <= 0x10FFFD)
end

local function is_fisrst_pua(char)
    return char >= 0xE000 and char <= 0xF8FF
end

--- charset comment filter
local function pua_filter(input, env)
    local b = env.engine.context:get_option("pua_filter")--开关状态
    if not b then
        for cand in input:iter() do
            if exists(is_pua, cand.text) then
                if all(is_pua, is_fisrst_pua, cand.text) then
                    if all(is_fisrst_pua, is_pua_basic, cand.text) then
                        yield(cand) -- 只有只包含基本PUA的才会显示
                    end
                end
            else
                yield(cand)
            end
        end
    else
        for cand in input:iter() do
            yield(cand)
        end
    end
    -- for cand in input:iter() do
    --     yield(cand)
    -- end
end


return pua_filter
