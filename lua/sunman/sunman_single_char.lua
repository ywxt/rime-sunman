local function single_char_first_filter(input, env)
   -- for cand in input:iter() do
   --    cand.comment = cand.comment..cand
   --    yield(cand)
   -- end
   -- 完全匹配单字
   local single = {}
   -- 完全匹配多字
   local multi = {}
   local table_end = false
   for cand in input:iter() do
      local cand_gen = cand:get_genuine()
      if string.find(cand_gen.type,'table') then
         if (utf8.len(cand.text)==1) then
             table.insert(single, cand)
         else
            table.insert(multi, cand)
         end
      elseif string.find(cand_gen.type,'completion') then
         if not table_end then
            for i, cand in ipairs(single) do
               yield(cand)
            end
            for i, cand in ipairs(multi) do
               yield(cand)
            end
            table_end = true
         end
         yield(cand)
      else
         yield(cand)
      end
   end
   -- 可能是自造词状态
   if not table_end then
      for i, cand in ipairs(single) do
         yield(cand)
      end
      for i, cand in ipairs(multi) do
         yield(cand)
      end
      table_end = true
   end
end



return single_char_first_filter
