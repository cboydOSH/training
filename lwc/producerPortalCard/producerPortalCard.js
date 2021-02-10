import { LightningElement } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import styles from '@salesforce/resourceUrl/ResourceLoader';
import TRAILHEAD_LOGO from '@salesforce/resourceUrl/ProducerPortalHomeScreenImage';

export default class producerPortalCard extends LightningElement {
    trailheadLogoUrl = TRAILHEAD_LOGO;
    connectedCallback() {
        loadStyle(this, styles)
    }
}