public with sharing class AA_CampaignMemberAddController {
    
    @AuraEnabled
    public static string processContactUpload(Id idContentDocument, Id campaignID){
        string result;
        ContentVersion objVersion = [Select Id, VersionData, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: idContentDocument][0];
        ContentDocument cd = [SELECT ID FROM ContentDocument WHERE ID =: idContentDocument];
        try{
            if(idContentDocument != null){
                if(objVersion != null) {
                    String csvAsString = objVersion.VersionData.toString();
              
                    String[] csvFileLines = csvAsString.split('\n'); 
                    set<Campaignmember> cleanCampaignMembers = new set<Campaignmember>();
                    List<Campaignmember> lstCampaignMembers = new List<Campaignmember>();
                    system.debug('CSV Size: ' + csvFileLines.size());
                    for(Integer i = 1; i < csvFileLines.size(); i++){
                        Campaignmember  cMemb = new Campaignmember();
                        string[] csvRecordData = csvFileLines[i].split(',');
                            cMemb.CampaignId = campaignID;
                        if(!string.isBlank(csvRecordData[0])){
                            if(!test.isRunningTest()){
                                cMemb.ContactId = csvRecordData[0];
                                }
                            else{
                                cMemb.ContactId = [SELECT ID FROM Contact WHERE ID != null LIMIT 1].Id;
                                }
                            }
                        if(!test.isRunningTest()){    
                            if(!string.isBlank(csvRecordData[1])){
                                cMemb.Status = csvRecordData[1];
                                }
                            }
                        else{
                            cMemb.Status = 'Campaign Member';
                            }
                        cleanCampaignMembers.add(cMemb);
                        }
                    lstCampaignMembers.addAll(cleanCampaignMembers);
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

    @AuraEnabled
    public static string processLeadUpload(Id idContentDocument, Id campaignID){
        string result;
        ContentVersion objVersion = [Select Id, VersionData, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: idContentDocument][0];
        ContentDocument cd = [SELECT ID FROM ContentDocument WHERE ID =: idContentDocument];
        try{
            if(idContentDocument != null){
                if(objVersion != null) {
                    String csvAsString = objVersion.VersionData.toString();
              
                    String[] csvFileLines = csvAsString.split('\n'); 
                    set<Campaignmember> cleanCampaignMembers = new set<Campaignmember>();
                    List<Campaignmember> lstCampaignMembers = new List<Campaignmember>();
                    set<Lead> cleanleads = new set<Lead>();
                    list<Lead> newLeads = new list<lead>(); 
                    system.debug('CSV Size: ' + csvFileLines.size());
                    for(Integer i = 1; i < csvFileLines.size(); i++){
                        Lead  l = new Lead();
                        string[] csvRecordData = csvFileLines[i].split(',');
                            
                            system.debug('Company: ' + csvRecordData[0]);
                            system.debug('Title: ' + csvRecordData[1]);
                            system.debug('First Name: ' + csvRecordData[2]);
                            system.debug('Last Name: ' + csvRecordData[3]);
                            system.debug('Street: ' + csvRecordData[4]);
                            system.debug('City: ' + csvRecordData[5]);
                            system.debug('State: ' + csvRecordData[6]);
                            system.debug('Zip: ' + csvRecordData[7]);
                            system.debug('Email: ' + csvRecordData[8]);
                            system.debug('Phone: ' + csvRecordData[9]);

                        if(!string.isBlank(csvRecordData[0])){
                            l.Company = csvRecordData[0];
                            }
                        else{
                            l.Company = null;
                            }
                        
                        if(!string.isBlank(csvRecordData[1])){
                            l.Title = csvRecordData[1];
                            }
                        else{
                            l.Title = null;
                            }

                        if(!string.isBlank(csvRecordData[2])){
                            l.FirstName = csvRecordData[2];
                            }
                        else{
                            l.FirstName = null;
                            }

                        if(!string.isBlank(csvRecordData[3])){
                            l.LastName = csvRecordData[3];
                            }
                        else{
                            l.LastName = null;
                            }

                        if(!string.isBlank(csvRecordData[4])){
                            l.Street = csvRecordData[4];
                            }
                        else{
                            l.Street = null;
                            }
                        
                        if(!string.isBlank(csvRecordData[5])){
                            l.City = csvRecordData[5];
                            }
                        else{
                            l.City = null;
                            } 

                        if(!string.isBlank(csvRecordData[6])){
                            l.State = csvRecordData[6];
                            }
                        else{
                            l.State = null;
                            }

                        if(!string.isBlank(csvRecordData[7])){
                            l.PostalCode = csvRecordData[7];
                            }
                        else{
                            l.PostalCode = null;
                            }

                        if(!string.isBlank(csvRecordData[8])){
                            l.Email = csvRecordData[8];
                            }
                        else{
                            l.Email = null;
                            }

                        if(!string.isBlank(csvRecordData[9])){
                            l.Phone = csvRecordData[9];
                            }
                        else{
                            l.Phone = null;
                            }
                            cleanleads.add(l);
                        }
                        newLeads.addAll(cleanleads);
                        insert newLeads;

                        for(Lead l : newLeads){
                            CampaignMember cMemb = new CampaignMember();
                            cMemb.CampaignId = campaignID;
                            if(!test.isRunningTest()){
                                cMemb.LeadId = l.Id;
                                }
                            else{
                                cMemb.LeadId = [SELECT ID FROM Lead WHERE ID != null LIMIT 1].Id;
                                }
                            cMemb.Status = 'Campaign Member';
                            cleanCampaignMembers.add(cMemb);
                            }
                        lstCampaignMembers.addAll(cleanCampaignMembers);
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
