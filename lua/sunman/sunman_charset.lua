local chinese_charset = {
    {first = 0x4E00, last = 0x9FEF}, -- 基本汉字+补充
    {first = 0x3400, last = 0x4DB5}, -- 扩A
    {first = 0x20000, last = 0x2A6D6}, -- 扩B
    {first = 0x2A700, last = 0x2B734}, -- 扩C
    {first = 0x2B740, last = 0x2B81D}, -- 扩D
    {first = 0x2B820, last = 0x2CEA1}, -- 扩E
    {first = 0x2CEB0, last = 0x2EBE0}, -- 扩F
    {first = 0x30000, last = 0x3134F}, -- 扩G
    {first = 0x2E80, last = 0x2EF3}, -- 部首扩展
    {first = 0x2F00, last = 0x2FD5}, -- 康熙部首
    {first = 0xF900, last = 0xFAD9}, -- 兼容汉字
    {first = 0x2F800, last = 0x2FA1D}, -- 兼容扩展
    {first = 0xE815, last = 0xE86F}, -- PUA(GBK)部件
    {first = 0xE400, last = 0xE5E8}, -- 部件扩展
    {first = 0xE600, last = 0xE6CF}, -- PUA增补
    {first = 0x31C0, last = 0x31E3}, -- 汉字笔画
    {first = 0x2FF0, last = 0x2FFB}, -- 汉字结构
    {first = 0x3105, last = 0x312F}, -- 汉语注音
    {first = 0x31A0, last = 0x31BA}, -- 注音扩展
    {first = 0x3007, last = 0x3007} -- 〇

}

local function read_charset(name) return require('sunman/charset/' .. name) end

local function init(env)
    env.charsets = {
        ['Standard'] = read_charset('Standard'),
        ['Big5'] = read_charset('Big5'),
        ['GBK'] = read_charset('GBK')
    }
end

local function get_enabled_option(env)
    if env.engine.context:get_option('standard') then return 'Standard' end
    if env.engine.context:get_option('big5') then return 'Big5' end
    if env.engine.context:get_option('gbk') then return 'GBK' end
    return 'UTF8'
end

local function is_chinese(char)
    for index, value in ipairs(chinese_charset) do
        if char >= value.first and char <= value.last then return true end
    end
    return false
end

local function is_in_charset(char, charset) return charset[char] end

local function filter_chinese(string, charset)
    for index, code in utf8.codes(string) do
        if is_chinese(code) and (not is_in_charset(utf8.char(code), charset)) then
            return false
        end
    end
    return true
end

local function charset_filter(input, env)
    local option = get_enabled_option(env)
    if not (option == 'UTF8') then
        for cand in input:iter() do
            local cand_gen = cand:get_genuine()
            if filter_chinese(cand_gen.text, env.charsets[option]) then
                yield(cand)
            end
        end
    else
        for cand in input:iter() do yield(cand) end
    end
end

return {init = init, func = charset_filter}
