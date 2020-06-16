import { LightningElement, api } from 'lwc';

import processUpload from '@salesforce/apex/AA_CampaignMemberAddController.processUpload';

export default class CampaignMemberAdd extends LightningElement {

@api recordId;
@api acceptedFormats = '.csv'
@api Spinner = false;

    connectedCallback(){
        console.log('RecordID present?: ' + this.recordId);
        }

    handleUploadFinished(event){
        this.Spinner = true;
        const uploadedFiles = event.detail.files;
        processUpload(
                        {idContentDocument : uploadedFiles[0].documentId,
                         campaignID : this.recordId
                        }
                     )
            .then(result => {
                this.Spinner = false;
                alert(result);
                window.location.href =  '/'+ this.recordId;
                })
        .catch(error => {
                this.Spinner = false;
                alert(error.message);
                });
    }

}