
function send-surveyanswers {
    Param($Formdata)
    #initial connection and retreive first formdata
    $web = invoke-webrequest https://chipotlefeedback.com
    $WebForm = $web.forms[0]
    #nodeID appears to be unique to the session.  set it now then append it to each form for submission
    $nodeID = $webform.fields.nodeID
    #loop through json array, for each set of form data, post the form data
    foreach ($item in $formdata){
        $hashtable = $item | ConvertPSObjectToHashtable
        #remove the current items in the formdata.fields list
        do {
            $KeyToRemove = $webform.fields.keys | select-object -first 1
            $WebForm.fields.remove($KeyToRemove)
        } until (
            $WebForm.fields.keys.count -eq 0
        )
        #add new form data
        foreach ($item in $hashtable.keys){
            $WebForm.fields.add($item,$($hashtable.$item))
        }
        #update nodeID field
        $webform.fields.nodeID = $nodeID
        #submit form data
        invoke-restmethod -uri "https://chipotlefeedback.com$($WebForm.action)" -Method POST -Body $WebForm.fields
    }
}

Function Convert-ReceiptCode {
    Param(
        [Parameter(Mandatory=$True)]
        [ValidatePattern({^\d{24,24}$})]
        [String]$ReceiptCode
    )
    #receipt code needs to be in the format "ddd ddd ddd ddd etc"

}