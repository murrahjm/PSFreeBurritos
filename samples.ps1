. .\Get-FreeBurritos.ps1

get-freeburritos -answerfile .\sampleformdata.json -ReceiptCode 12200310006221001149 -Verbose

#region survey
Get-FreeBurritos -ReceiptCode 12200310006221001149 `
-OverallExperience 5 `
-ReasonForScore 'Chipotle is Awesome!' `
-LikelihoodtoReturnwithin30days 5 `
-ExperienceType 'Dine-In' `
-OrderType 'In-Person' `
-EaseofPlacingOrder 5 `
-SpeedofService 5 `
-TasteofFood 5 `
-FriendlinessofStaff 5 `
-CleanlinessofRestaurant 5 `
-FoodQuantity 'Just What I wanted' `
-OrderAssembledtoyourLiking yes `
-RestaurantEnvironmentPleasant yes `
-FoodItemsUnavailable no `
-ExperiencedProblem no `
-AccurateOrder no `
-OrdersinLast6Months '6+' `
-AgeGroup '35-49' `
-EnterSweepstakes yes `
-FirstName 'Jeremy' `
-LastName 'Murrah' `
-EmailAddress 'murrahjm@gmail.com' `
-ExportAnswerFile
#endregion
