import { LightningElement, wire, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import styles from '@salesforce/resourceUrl/ResourceLoader';
import TRAILHEAD_LOGO from '@salesforce/resourceUrl/ProducerPortalHomeScreenImage';

import {getRecord} from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import FIRST_NAME_FIELD from '@salesforce/schema/User.FirstName';

export default class CommunityMemberHeader extends LightningElement {

    trailheadLogoUrl = TRAILHEAD_LOGO;

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


    connectedCallback() {
        loadStyle(this, styles)
    }
}