import { LightningElement, api, track } from 'lwc';
import { BaseState } from "vlocity_ins/baseState";

export default class consoleGuidebooks extends BaseState(LightningElement) {

    @api url;

    @api 
    get programURL() {
        return this.url;
    }
    
    connectedCallback() {
        var guidebookURL = JSON.parse(JSON.stringify(this.obj.urlForIFrame));
        this.url = guidebookURL;
        console.log(guidebookURL);
    }

}