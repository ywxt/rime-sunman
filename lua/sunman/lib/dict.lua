
local radstr = '\z
    一不了人之大上也子而生自其行十用发天方日\z
    三小二心又长已月力文王西手工门身由儿入己\z
    山曰世水立走女言马金口几气比白非夫未士且\z
    目电八九七石车千干火臣广古早母乃亦示土片\z
    音止食黑衣革巴户木米田毛永习耳雨皮甲凡丁\z
    鱼牛申川鬼刀牙予骨末辛尤厂丰乌麻贝乙鸟辰\z
    羊瓦虫尸鼻壬羽戊寸巳舟夕甫矛酉亥卜戈鼠鹿\z
    弓瓜穴欠巾兀矢犬爪歹禾夭禺匕豕臼匚弋皿缶\z
    髟钅攵幺卅艮耒隹殳攴長見風彡門貝車飛巛馬\z
    魚齒頁鹵鳥丂丄丅丆丌丨丩丬丱丶丷丿乀乁乂\z
    乚乛亅亠亻僉冂冊冎冖冫凵刂勹匸卄卌卝卩厶\z
    吅囗夂夊宀屮巜廴廾彐彳忄戶扌朩氵氺灬為烏\z
    爫爾爿牜犭疒癶礻糸糹纟罒耂艹虍衤覀訁讠豸\z
    辶釒镸阝韋飠饣鬥黽\z
    兀㐄㐅㔾䒑'

local function get_short(codestr)
  local s = ' ' .. codestr
  for code in s:gmatch('%l+') do
    if s:find(' ' .. code .. '%l+') then
      return code
    end
  end
end

local function has_short_and_is_full(cand, env, rvdb, delimiter)
  -- completion 和 sentence 类型不属于精确匹配，但要通过 cand:get_genuine() 判
  -- 断，因为 simplifier 会覆盖类型为 simplified。先行判断 type 并非必要，只是
  -- 为了轻微的性能优势。
  local cand_gen = cand:get_genuine()
  if cand_gen.type == 'completion' or cand_gen.type == 'sentence' then
    return false, true
  end
  local input = env.engine.context.input
  local cand_input = input:sub(cand.start + 1, cand._end)
  -- 去掉可能含有的 delimiter。
  cand_input = cand_input:gsub('[' .. delimiter .. ']', '')
  -- 字根可能设置了特殊扩展码，不视作全码，不予后置。
  if cand_input:len() > 2 and radstr:find(cand_gen.text, 1, true) then
    return
  end
  local codestr = rvdb:lookup(cand_gen.text)
  local is_comp = not
    string.find(' ' .. codestr .. ' ', ' ' .. cand_input .. ' ', 1, true)
  local short = not is_comp and get_short(codestr)
  -- cand.comment = tostring(is_comp)..tostring(short)..tostring(cand_input:find('^' .. short .. '%l*'))
  -- 注意排除有简码但是输入的是不规则编码的情况
  return short and cand_input:find('^' .. short .. '%l+'), is_comp
end

return { has_short_and_is_full = has_short_and_is_full}
