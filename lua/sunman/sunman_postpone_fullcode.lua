-- sunman_postpone_fullcode.lua
-- 出现重码时，将全码匹配且有简码的「单字」「适当」后置。
-- 目前的实现方式，原理适用于所有使用规则简码的形码方案。



local function init(env)
  local config = env.engine.schema.config
  local code_rvdb = config:get_string('lua_reverse_db/code')
  env.code_rvdb = ReverseDb('build/' .. code_rvdb .. '.reverse.bin')
  env.delimiter = config:get_string('speller/delimiter')
  env.max_index = config:get_int('sunman_postpone_fullcode/lua/max_index')
      or 4
  env.dict_lib = require('sunman/lib/dict')
end


local function filter(input, env)
  local context = env.engine.context
  if not context:get_option("sunman_postpone_fullcode") then
    for cand in input:iter() do yield(cand) end
  else
    -- 具体实现不是后置目标候选，而是前置非目标候选
    local dropped_cands = {}
    local done_drop
    local pos = 1
    -- Todo: 计算 pos 时考虑可能存在的重复候选被 uniquifier 合并的情况。
    for cand in input:iter() do
      if done_drop then
        yield(cand)
      else
        -- 后置不越过 env.max_index 和以下几类候选：
        -- 1) 顶功方案使用 script_translator 导致的匹配部分输入的候选，例如输入
        -- otu 且光标在 u 后时会出现编码为 ot 的候选。不过通过填满码表的三码和
        -- 四码的位置，能消除这类候选。2) 顶功方案的造词翻译器允许出现的
        -- completion 类型候选。3) 顶功方案的补空候选——全角空格（ U+3000）。
        local is_bad_script_cand = cand._end < context.caret_pos
        local drop, is_comp = env.dict_lib.has_short_and_is_full(cand, env, env.code_rvdb, env.delimiter)
        if pos >= env.max_index
            or is_bad_script_cand or is_comp or cand.text == '　' then
          for i, cand in ipairs(dropped_cands) do yield(cand) end
          done_drop = true
          yield(cand)
        -- 精确匹配的词组不予后置
        elseif not drop or utf8.len(cand.text) > 1 then
          yield(cand)
          pos = pos + 1
        else table.insert(dropped_cands, cand)
        end
      end
    end
    for i, cand in ipairs(dropped_cands) do yield(cand) end
  end
end


return { init = init, func = filter }


--[[ 测试例字：
我	箋	pffg
出	艸 糾 ⾋	aau
在	黄土	hkjv
地	軐	jbe
是	鶗	kglu
道	单身汉	xtzd
以	(多个词组)	cwuu
同	同路	mgov
只	叭	otu
渐	浙	zfrj
资	盗	xqms
--]]
