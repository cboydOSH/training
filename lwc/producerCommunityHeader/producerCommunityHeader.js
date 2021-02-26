import { LightningElement, wire, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import styles from '@salesforce/resourceUrl/ResourceLoader';
import TRAILHEAD_LOGO from '@salesforce/resourceUrl/ProducerPortalHomeScreenImage';

import {getRecord} from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import FIRST_NAME_FIELD from '@salesforce/schema/User.FirstName';
import { BaseState } from "vlocity_ins/baseState";

export default class ProducerCommunityHeader extends BaseState(LightningElement){

    trailheadLogoUrl = TRAILHEAD_LOGO;

    @track placeholder = "What would you like to do today...";

    @track error ;
    @track firstname;
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [FIRST_NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
           this.error = error ; 
        } else if (data) {
            this.firstname = data.fields.FirstName.value;
        }
    }

    clearValue() {
        this.placeholder = "";
    }

    manageValue() {
        if(this.placeholder == ""){
            this.placeholder = "What would you like to do today...";
        }
    }

    connectedCallback() {
        loadStyle(this, styles)
    }
}