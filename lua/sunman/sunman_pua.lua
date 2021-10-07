-- encoding: utf-8

local function is_pua_basic(char) return char >= 0xE815 and char <= 0xE86F end

local function is_pua(char)
    return (char >= 0xE000 and char <= 0xF8FF) or
               (char >= 0xF0000 and char <= 0xFFFFD) or
               (char >= 0x100000 and char <= 0x10FFFD)
end

local function only_contain_pua_basic(text)
    for i, c in utf8.codes(text) do
        if is_pua(c) and not is_pua_basic(c) then return false end
    end
    return true
end


--- charset comment filter
local function pua_filter(input, env)
    local b = env.engine.context:get_option("pua_filter") -- 开关状态
    if not b then
        for cand in input:iter() do
            local cand_gen = cand:get_genuine()
            if only_contain_pua_basic(cand_gen.text) then
                yield(cand)
            end
        end
    else
        for cand in input:iter() do yield(cand) end
    end
    -- for cand in input:iter() do
    --     yield(cand)
    -- end
end

return pua_filter
