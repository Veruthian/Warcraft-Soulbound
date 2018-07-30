local sb = {}; Soulbound = sb;

local printf = print

local function print(...)

   local result = ''

   for i = 1, select('#', ...) do

      local item = select(i, ...);

      if (item) then result = result .. item; end

   end

   printf(result);
end

local GetCategoryList = GetCategoryList;

local GetCategoryInfo = GetCategoryInfo;

local GetCategoryNumAchievements = GetCategoryNumAchievements;

local GetAchievementInfo = GetAchievementInfo;


function sb.GetAchievementData()

   local categories = {};

   local achievements = {};   


   local categoryIds = GetCategoryList();
   
   for index, categoryId in ipairs(categoryIds) do
      
      local name, parentId = GetCategoryInfo(categoryId);
      
      local category = {
            Id = categoryId, 
            Name = name, 
            ParentId = parentId, 
            Achievements = sb.GetAchievements(categoryId, achievements)
      };

      message(name);

      categories[categoryId] = category;      

   end  

   return categories, achievements;

end
  
function sb.GetAchievements(categoryId, totalAchievements)

   local achievementCount = GetCategoryNumAchievements(categoryId, true);

   local achievements = {};

   for index = 1, achievementCount do

      local id, name, points, completed, month, day, year, description, flags, icon, rewardText, isGuildAch, wasEarnedByMe, earnedBy = GetAchievementInfo(categoryId, index) 
      
      if (id) then

         local achievement = {
               Id = id, 
               Name = name, 
               Points = points, 
               Completed = completed, 
               Month = month, 
               Day = day, 
               Year = year, 
               Description = description, 
               IconPath = icon, 
               RewardText = rewardText, 
               WasEarnedByMe = wasEarnedByMe, 
               EarnedBy = earnedby 
         };

         
         tinsert(achievements, achievement);

         totalAchievements[id] = achievement;

      end
   end

   return achievements;

end


local function Repeat(value, times)

   local result = '';

   for i = 1, times do
      result = result .. value;
   end

   return result;

end

local function PrintTree(category, level, sigil)

   level = level or 0;

   sigil = sigil or '';

   print(Repeat('   ', level), sigil, "Id: ", category.Id, "; Name: '", category.Name, "'");

   if (category.Achievements) then
      for _, achievement in ipairs(category.Achievements) do
         PrintTree(achievement, level + 1, '*');
      end
   end

   if (category.Children) then
      for _, child in ipairs(category.Children) do
         PrintTree(child, level + 1);
      end
   end
end

function sb.PrintCategories()

   local categories = sb.LoadData();

   for _, category in pairs(categories) do

      -- print("id: ", category.Id,"; path: '", category.FullName, "'");
      if (not category.Parent) then
         
         PrintTree(category);

      end

   end

end



local function LoadAchievements(categoryId, achievements)

   local childAchievements  = {};

   local achievementCount = GetCategoryNumAchievements(categoryId, true);

   for index = 1, achievementCount do

      local id, name, points, _, _, _, _, description = GetAchievementInfo(categoryId, index) 

      if (id or name) then

         local achievement = {
            Id = id,
            Name = name,
            Points = points,
            Description = description   
         };

         tinsert(childAchievements, achievement);
         
         printf(id, name, achievements);
         achievements[id] = achievement;

      end
      
   end

   return childAchievements;

end

local function AddChild(category, parent)

   if (parent) then
      if (not parent.Children) then 
         parent.Children = {} 
      end

      tinsert(parent.Children, category);
   end
end

local function LoadCategory(id, categories, achievements)

   if (not categories[id]) then

      local name, parentId = GetCategoryInfo(id);
            
      if (name) then
      
         local fullname = name;
         
         if (parentId > 0) then

            LoadCategory(parentId, categories);
            
         end
         
         local parent = categories[parentId];

         local categoryAchievements = LoadAchievements(id, achievements);

         local category = {Id = id, Name = name, Parent = parent, Achievements = categoryAchievements};
   
         AddChild(category, parent)

         categories[id] = category;         
         
         return fullname;

      end

   else

      return categories[id].FullName;

   end

end


function sb.LoadData()

   local ids = GetCategoryList();

   local categories = {};

   local achievements = {};
   
   for _, id in pairs(ids) do

      LoadCategory(id, categories, achievements);

   end

   return categories;

end
