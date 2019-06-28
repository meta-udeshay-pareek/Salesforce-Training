import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import FAX_FIELD from '@salesforce/schema/Contact.Fax';

export default class ContactFormLWC extends LightningElement {

    
    @track error;

    @track contacts;

    @track firstname = '';
    @track lastname = '';
    @track email = '';
    @track fax = '';

    handleChange(event) {  
        
        const field = event.target.name;
        switch(field){
            case 'firstname':
                this.firstname = event.target.value;
                break;
            case 'lastname':
                this.lastname = event.target.value;
                break;
            case 'email':
                this.email = event.target.value;
                break;
            case 'phone':
                this.phone = event.target.value;
                break;
            case 'fax':
                this.fax = event.target.value;
                break;
            default:
                // eslint-disable-next-line no-alert
                alert('Invalid Data');
        }
    }

    
    createContact() {
        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputFields) => {
                inputFields.reportValidity();
                return validSoFar && inputFields.checkValidity();
            }, true);

        if (allValid) {
            // Create the recordInput object
            const fields = {};
            fields[FIRSTNAME_FIELD.fieldApiName] = this.firstname;
            fields[LASTNAME_FIELD.fieldApiName] = this.lastname;
            fields[EMAIL_FIELD.fieldApiName] = this.email;
            fields[PHONE_FIELD.fieldApiName] = this.phone;
            fields[FAX_FIELD.fieldApiName] = this.fax;
            const recordInput = { apiName : CONTACT_OBJECT.objectApiName, fields };
            

            createRecord(recordInput)
                .then(contact => {
                    this.contactId = contact.id;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Contact Created',
                            variant: 'success'
                        })
                    );
                    
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
               window.location.reload();        
            }
        else {
            // The form is not valid
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Something is wrong',
                    message: 'Check your input and try again.',
                    variant: 'error'
                })
             );
        }
           
    }
}