import { LightningElement, api, track } from 'lwc';
import { BaseState } from "vlocity_ins/baseState";

export default class Banner extends BaseState(LightningElement) {

    @api url = 'https://www.google.com';
    //@api url = 'https://www.onesharehealth.com/hubfs/Member%20GuideBooks/July.16.2020/OSHNationalClassicCrown.PDF.pdf#page=7';

    @api 
    get programURL() {
        return this.url;
    }
    

    connectedCallback() {
        this.url = JSON.parse(JSON.stringify(this.obj.urlForIFrame));        
    }

}