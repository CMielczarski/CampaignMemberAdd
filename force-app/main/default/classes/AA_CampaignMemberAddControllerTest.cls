@isTest
private class AA_CampaignMemberAddControllerTest {

    static testMethod void myUnitTest() {
        list<Contact> ctcs = new list<Contact>();
        for(integer i = 0; i < 8; i++){
            Contact ct = new Contact(LastName = 'Testing' + i, FirstName = 'Test'+i, email = i+'Test@none.com');
            ctcs.add(ct);
            }
            insert ctcs;
            String str = 'ContactID, Status\n';
            for(integer i = 0; i < ctcs.size(); i++){
                str += ctcs[i].Id + ', Campaign Member\n ';
                }
                blob csvFileBody = Blob.valueOf(str);
                system.debug('File Body: ' + str);
                ContentVersion contentVersionInsert = new ContentVersion(
                    Title = 'Test',
                    PathOnClient = 'Test.csv',
                    VersionData = csvFileBody,
                    IsMajorVersion = true
                    );
                insert contentVersionInsert;
                Campaign cpn = new Campaign(IsActive = true, Name = 'Test Campaign');
                insert cpn;

                ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
                test.startTest();
                AA_CampaignMemberAddController.processUpload(documents[0].Id, cpn.Id);
                test.stopTest();
        }
}
