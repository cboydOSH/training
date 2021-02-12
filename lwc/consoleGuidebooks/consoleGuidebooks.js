import { LightningElement, api, track } from 'lwc';
import { BaseState } from "vlocity_ins/baseState";

export default class consoleGuidebooks extends BaseState(LightningElement) {

    @track showGuidebook = false;
    @track showMessage = false;
    
    @api url;

    @api 
    get programURL() {
        return this.url;
    }
    
    connectedCallback() {
        var jsonSource = JSON.parse(JSON.stringify(this.obj));
        var guidebookURL = JSON.parse(JSON.stringify(this.obj.urlForIFrame));
        console.log("Guidebook URL:" + guidebookURL);
        var hasAsset = jsonSource.hasAsset;
        console.log("JSON:" + jsonSource);
        if (this.hasAsset = "true") {
            //var guidebookURL = JSON.parse(JSON.stringify(this.obj.urlForIFrame));
            this.url = jsonSource.urlForIFrame;
            console.log("Has Asset:" + hasAsset);
            console.log("Guidebook URL:" + guidebookURL);
            this.showGuidebook = true;
        } else {
            this.showMessage = true;
            console.log("There is no active asset for this account.");
        }
        
        
    }

}