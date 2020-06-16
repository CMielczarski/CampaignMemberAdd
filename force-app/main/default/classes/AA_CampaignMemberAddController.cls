public with sharing class AA_CampaignMemberAddController {
    
    @AuraEnabled
    public static string processUpload(Id idContentDocument, Id campaignID){
        string result;
        ContentVersion objVersion = [Select Id, VersionData, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: idContentDocument][0];
        ContentDocument cd = [SELECT ID FROM ContentDocument WHERE ID =: idContentDocument];
        try{
            if(idContentDocument != null){
                if(objVersion != null) {
                    String csvAsString = objVersion.VersionData.toString();
              
                    String[] csvFileLines = csvAsString.split('\n'); 
                    
                    List<Campaignmember> lstCampaignMembers = new List<Campaignmember>();
                    
                    for(Integer i=1;i<csvFileLines.size();i++){
                        Campaignmember  cMemb = new Campaignmember();
                        string[] csvRecordData = csvFileLines[i].split(',');
                            cMemb.CampaignId = campaignID;
                        if(!string.isBlank(csvRecordData[0])){
                            cMemb.ContactId = csvRecordData[0];
                            }
                        if(!string.isBlank(csvRecordData[1])){
                            cMemb.LeadId = csvRecordData[1];
                            }
                        if(!string.isBlank(csvRecordData[2])){
                            cMemb.Status = csvRecordData[2];
                            }
                        lstCampaignMembers.add(cMemb);
                        }
                    
                    if(!lstCampaignMembers.isEmpty()){
                        insert lstCampaignMembers;
                        delete cd;
                        result = 'Records successfully added as Campaign Members';
                        }
                        }
                else{
                    result = 'No records available to add.  Check values and try again.';
                    delete cd;
                    }
                }
                }
            catch (Exception e){
                system.debug('Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
                result = 'Error: ' + e.getMessage() + ' Line: ' + e.getLineNumber();
                delete cd;
                }
            return result;
            }
}
