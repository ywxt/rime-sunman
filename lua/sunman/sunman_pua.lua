-- encoding: utf-8

local function init(env)
  local config = env.engine.schema.config
  local code_rvdb = config:get_string('sunman_pua_filter/dictionary')
  env.code_rvdb = ReverseDb('build/' .. code_rvdb .. '.reverse.bin')
end

local function exists(filter, text)
    for i,c in utf8.codes(text) do
        if filter(c) then
            return true
        end
    end
    return false
end

local function all(filter1, filter2, text)
    for i,c in utf8.codes(text) do
        if filter1(c) then
            if (not filter2(c)) then
                return false
            end
        end
    end
    return true
end

local function is_pua_basic(env)
    return function (char)
        return utf8.len(env.code_rvdb:lookup(utf8.char(char)))>0
    end
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
            local cand_gen = cand:get_genuine()
            if exists(is_pua, cand_gen.text) then
                if all(is_pua, is_fisrst_pua, cand_gen.text) then
                    if all(is_fisrst_pua, is_pua_basic(env), cand.text) then
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


return {init = init, func = pua_filter}
