local sb = {}; Soulbound = sb;

function sb.PrintCategories()
   
   local categories = GetCategoryList();
   
   for _, category in ipairs(categories) do
      
      local tags = sb.GetCategoryTags(category);
      
      print(table.concat(tags, ', '));
   end
   
end

function sb.GetCategoryTags(categoryId)
   
   local tags = {}
   
   repeat
      
      name, categoryId = GetCategoryInfo(categoryId);
      
      table.insert(tags, 1, name);
      
   until (categoryId < 0)
   
   return tags;
   
end