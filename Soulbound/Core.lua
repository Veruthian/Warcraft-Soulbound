local sb = {}; Soulbound = sb;

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


