import { LightningElement, api } from 'lwc';

import processContactUpload from '@salesforce/apex/AA_CampaignMemberAddController.processContactUpload';
import processLeadUpload from '@salesforce/apex/AA_CampaignMemberAddController.processLeadUpload';

export default class CampaignMemberAdd extends LightningElement {

@api recordId;
@api acceptedFormats = '.csv'
@api Spinner = false;

    connectedCallback(){
        console.log('RecordID present?: ' + this.recordId);
        }

    handleContactUploadFinished(event){
        this.Spinner = true;
        const uploadedFiles = event.detail.files;
        processContactUpload(
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

    handleLeadUploadFinished(event){
            this.Spinner = true;
            const uploadedFiles = event.detail.files;
            processLeadUpload(
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