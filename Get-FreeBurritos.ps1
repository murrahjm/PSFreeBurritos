function get-FreeBurritos {
    [cmdletbinding(DefaultParameterSetName='byQuestions')]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName='byanswerfile')]
        [ValidateScript({test-path $_})]
        [String]$answerfile,

        [Parameter(Mandatory=$True,
        HelpMessage='Enter Receipt code with no spaces, numbers only')]
        [ValidatePattern({^\d{20,20}$})]
        [String]$ReceiptCode,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='How satisfied are you with your overall experience at Chipotle?'
        )]
        [ValidateSet('1','2','3','4','5')]
        [String]$OverallExperience,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='What is the primary reason for the score you just gave?')]
        [String]$ReasonForScore,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='How likely are you to recommend Chipotle to a friend or colleague? '
        )]
        [ValidateSet('1','2','3','4','5')]
        [String]$LikelihoodtoReturnwithin30Days,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='What type of experience did you have?'
        )]
        [ValidateSet('Dine-In','Carry-Out','Catering','Delivery')]
        [String]$ExperienceType,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='How did you place your order?'
        )]
        [ValidateSet('In-Person','Chipotle.com','Chipotle app','Delivery app','Other')]
        [String]$OrderType,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Ease of Placing your Order'
        )]
        [ValidateSet('1','2','3','4','5')]
        [String]$EaseofPlacingOrder,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Speed of Service'
        )]
        [ValidateSet('1','2','3','4','5')]
        [String]$SpeedofService,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Taste of your food'
        )]
        [ValidateSet('1','2','3','4','5')]
        [String]$TasteofFood,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Friendliness of our staff'
        )]
        [ValidateSet('1','2','3','4','5')]
        [String]$FriendlinessofStaff,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Cleanliness of the Restaurant'
        )]
        [ValidateSet('1','2','3','4','5')]
        [String]$CleanlinessofRestaurant,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Describe the amount of food in your entree'
        )]
        [ValidateSet('Less than I wanted','Just What I wanted','More than I wanted')]
        [String]$FoodQuantity,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Was your order assembled to your liking?'
        )]
        [ValidateSet('yes','no')]
        [String]$OrderAssembledtoyourLiking,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Was the restaurant environment pleasant?'
        )]
        [ValidateSet('yes','no')]
        [String]$RestaurantEnvironmentPleasant,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Were any food items unavailable when you ordered/received your meal?'
        )]
        [ValidateSet('yes','no')]
        [String]$FoodItemsUnavailable,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Did you experience a problem on your visit?'
        )]
        [ValidateSet('yes','no')]
        [String]$ExperiencedProblem,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Was your order accurate?'
        )]
        [ValidateSet('yes','no')]
        [String]$AccurateOrder,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Including this visit how many times have you ordered from Chipotle in the last 6 months?'
        )]
        [ValidateSet('First visit','1','2-3','4-5','6+')]
        [String]$OrdersinLast6Months,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Please indicate your age group.'
        )]
        [ValidateSet('Under 18','18-24','25-34','35-49','50-64','65 and older','Prefer not to answer')]
        [String]$AgeGroup,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Would you like to enter our sweepstakes?'
        )]
        [ValidateSet('yes','no')]
        [String]$EnterSweepstakes,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='First Name'
        )]
        [String]$FirstName,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Last Name'
        )]
        [String]$LastName,

        [Parameter(Mandatory=$True,
            ParameterSetName='byQuestions',
            HelpMessage='Email Address'
        )]
        [String]$EmailAddress,

        [Parameter(ParameterSetName='byQuestions')]
        [Switch]$ExportAnswerFile
        )
    $formattedReceiptCode = $ReceiptCode.insert(3,' ').insert(7,' ').insert(11,' ').insert(15,' ').insert(19,' ').insert(23,' ')
    if ($answerfile){
        $formdata = get-content $answerfile | convertfrom-json
        $formdata[0].spl_q_chipotle_receipt_code_txt = $formattedReceiptCode
    } else {
        #start with sample form data and modify values based on parameters
        $formdata = get-content "$PSScriptRoot\sampleformdata.json" | convertfrom-json
        $formdata[0].spl_q_chipotle_receipt_code_txt = $formattedReceiptCode
        $formdata[1].onf_q_chipotle_overall_experience_5ptscale = $OverallExperience
        $formdata[1].spl_q_chipotle_reason_for_score_cmt = $ReasonForScore
        $formdata[1].onf_q_chipotle_likelihood_to_return_30_days_5pt_ltrscale = $LikelihoodtoReturnwithin30Days
        Switch ($ExperienceType){
            'Dine-In' {$formdata[2].onf_q_chipotle_experience_type_alt = '10'}
            'Carry-Out' {$formdata[2].onf_q_chipotle_experience_type_alt = '20'}
            'Catering' {$formdata[2].onf_q_chipotle_experience_type_alt = '30'}
            'Delivery' {$formdata[2].onf_q_chipotle_experience_type_alt = '40'}
        }
        Switch ($OrderType){
            'In-Person' {$formdata[2].onf_q_chipotle_order_medium_alt = '10'}
            'Chipotle.com' {$formdata[2].onf_q_chipotle_order_medium_alt = '20'}
            'Chipotle app' {$formdata[2].onf_q_chipotle_order_medium_alt = '30'}
            'Delivery app' {$formdata[2].onf_q_chipotle_order_medium_alt = '40'}
            'Other' {$formdata[2].onf_q_chipotle_order_medium_alt = '50'}
        }
        $formdata[3].onf_q_chipotle_taste_of_food_5pt_sat_scale = $TasteofFood
        $formdata[3].onf_q_chipotle_cleanliness_of_restaurant_5pt_sat_scale = $CleanlinessofRestaurant
        $formdata[3].onf_q_chipotle_ease_of_placing_order_5pt_sat_scale = $EaseofPlacingOrder
        $formdata[3].onf_q_chipotle_speed_of_service_5pt_sat_scale = $SpeedofService
        $formdata[3].onf_q_chipotle_friendliness_of_staff_5pt_sat_scale = $FriendlinessofStaff
        Switch ($FoodQuantity) {
            'Less than I wanted' {$formdata[4].onf_q_chipotle_food_quantity_received_alt = '10'}
            'Just What I wanted' {$formdata[4].onf_q_chipotle_food_quantity_received_alt = '20'}
            'More than I wanted' {$formdata[4].onf_q_chipotle_food_quantity_received_alt = '30'}
        }
        Switch ($OrderAssembledtoyourLiking){
            'yes' {$formdata[4].onf_q_chipotle_order_assembled_liking_yn = '1'}
            'no' {$formdata[4].onf_q_chipotle_order_assembled_liking_yn = '2'}
        }
        Switch ($RestaurantEnvironmentPleasant){
            'yes' {$formdata[4].onf_q_chipotle_restaurant_environment_yn = '1'}
            'no' {$formdata[4].onf_q_chipotle_restaurant_environment_yn = '2'}
        }
        Switch ($FoodItemsUnavailable){
            'yes' {$formdata[5].onf_q_chipotle_food_item_unavailable_yn = '1'}
            'no' {$formdata[5].onf_q_chipotle_food_item_unavailable_yn = '2'}
        }
        Switch ($ExperiencedProblem){
            'yes' {$formdata[5].onf_q_chipotle_experienced_problem_on_visit_yn = '1'}
            'no' {$formdata[5].onf_q_chipotle_experienced_problem_on_visit_yn = '2'}
        }
        Switch ($AccurateOrder){
            'yes' {$formdata[5].onf_q_chipotle_accurate_order_yn = '1'}
            'no' {$formdata[5].onf_q_chipotle_accurate_order_yn = '2'}
        }
        Switch ($OrdersinLast6Months){
            'First visit' {$formdata[6].onf_q_chipotle_orders_in_last_6_months_alt = '10'}
            '1' {$formdata[6].onf_q_chipotle_orders_in_last_6_months_alt = '15'}
            '2-3' {$formdata[6].onf_q_chipotle_orders_in_last_6_months_alt = '20'}
            '4-5' {$formdata[6].onf_q_chipotle_orders_in_last_6_months_alt = '30'}
            '6+' {$formdata[6].onf_q_chipotle_orders_in_last_6_months_alt = '40'}
        }
        Switch ($AgeGroup){
            'Under 18' {$formdata[6].onf_q_chipotle_age_group_alt = '10'}
            '18-24' {$formdata[6].onf_q_chipotle_age_group_alt = '20'}
            '25-34' {$formdata[6].onf_q_chipotle_age_group_alt = '30'}
            '35-49' {$formdata[6].onf_q_chipotle_age_group_alt = '40'}
            '50-64' {$formdata[6].onf_q_chipotle_age_group_alt = '50'}
            '65 and older' {$formdata[6].onf_q_chipotle_age_group_alt = '60'}
            'Prefer not to answer' {$formdata[6].onf_q_chipotle_age_group_alt = '70'}
        }
        If ($EnterSweepstakes -eq 'yes'){
            $formdata[7].spl_q_chipotle_customer_first_name_txt = $FirstName
            $formdata[7].spl_q_chipotle_customer_last_name_txt = $LastName
            $formdata[7].spl_q_chipotle_customer_email_address_txt = $EmailAddress
        }
        If ($ExportAnswerFile){
            $formdata | ConvertTo-Json | set-content -Path "$PSScriptRoot\SurveyAnswers.json"
        }
    }
    #
    Send-surveyanswers -Formdata $formdata
}

function send-surveyanswers {
    [Cmdletbinding()]
    Param($Formdata)
    $url = 'https://www.chipotlefeedback.com'
    #initial connection and retreive first formdata
    $webrequest = invoke-webrequest $url -SessionVariable websession
    $WebForm = $webrequest.forms[0]
    #nodeID appears to be unique to the session.  set it now then append it to each form for submission
    $nodeID = $webform.fields.nodeId
    $nextballotVer = '2'
    #loop through json array, for each set of form data, post the form data
    foreach ($item in $formdata){
        #update nodeID field
        $item.nodeId = $nodeID
        $item.ballotVer = $nextballotVer
        $hashtable = $item | ConvertPSObjectToHashtable
        #submit form data
        write-verbose $hashtable
        $return = invoke-webrequest -uri "$url$($WebForm.action)" -Method POST -Body $hashtable -WebSession $websession
        $nextballotVer = $return.forms[0].fields.ballotVer
    }
}

function ConvertPSObjectToHashtable
{
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )

    process
    {
        if ($null -eq $InputObject) { return $null }

        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
        {
            $collection = @(
                foreach ($object in $InputObject) { ConvertPSObjectToHashtable $object }
            )

            Write-Output -NoEnumerate $collection
        }
        elseif ($InputObject -is [psobject])
        {
            $hash = @{}

            foreach ($property in $InputObject.PSObject.Properties)
            {
                $hash[$property.Name] = ConvertPSObjectToHashtable $property.Value
            }

            $hash
        }
        else
        {
            $InputObject
        }
    }
}