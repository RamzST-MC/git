RewardsModule = RewardsModule or {}
RewardsModule.Reward = RewardsModule.Reward or {}

--$Сколько будет давать кредитов за выполнение задания
RewardsModule.Reward.SteamGroup = 0
RewardsModule.Reward.SteamName = 0
RewardsModule.SteamNameTag = "0--0-"

term.Add("AlreadyInSteamGroup", "Вы уже вступили в группу Steam и получили бонус!")
term.Add("AlreadySteamTag", "Вы уже установили тэг '"..RewardsModule.SteamNameTag.."' в свой ник и получили бонус!")
