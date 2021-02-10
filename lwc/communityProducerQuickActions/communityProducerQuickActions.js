import { LightningElement, api, track } from 'lwc';
import { BaseState } from "vlocity_ins/baseState";

// import { LightningElement, wire, track } from 'lwc';

// import {getRecord} from 'lightning/uiRecordApi';

// import USER_ID from '@salesforce/user/Id';

// import CONTACT_ID_FIELD from '@salesforce/schema/User.ContactId';

// import ACCOUNT_ID_FIELD from '@salesforce/schema/Contact.AccountId';
// import LIST_BILL_FIELD from '@salesforce/schema/Account.List_Bill_Certification_Requirements_Met__c';

export default class ProducerCommunityHeader extends BaseState(LightningElement){
    // @api recordId;
    @track certified;

    connectedCallback() {
        var userCertified = JSON.parse(JSON.stringify(this.obj));
        if (userCertified.certified == 'Yes'){
            this.certified = true;
        } else {
            this.certified = false;
        }
    }

    // @track error ;
    // @track contactId;
    // @track accountId;
    // // @track authorized;
    
    // @wire(getRecord, {
    //     recordId: USER_ID,
    //     fields: [CONTACT_ID_FIELD]
    // }) wireuser({
    //     error,
    //     data
    // }) {
    //     if (error) {
    //        this.error = error ; 
    //     } else if (data) {
    //         this.contactId = data.fields.ContactId.value;
    //     }
    // }

    // @wire(getRecord, {
    //     recordId: CONTACT_ID_FIELD,
    //     fields: [ACCOUNT_ID_FIELD]
    // }) wireuser({
    //     error,
    //     data
    // }) {
    //     if (error) {
    //        this.error = error ; 
    //     } else if (data) {
    //         this.accountId = data.fields.accountId.value;
    //     }
    // }

    // @wire(getRecord, {
    //     recordId: ACCOUNT_ID,
    //     fields: [LIST_BILL_FIELD]
    // }) wireuser({
    //     error,
    //     data
    // }) {
    //     if (error) {
    //        this.error = error ; 
    //     } else if (data) {
    //         this.authorized = data.fields.authorized.value;
    //     }
    // }

    
    
}