import { LightningElement, track, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_ins/omniscriptBaseMixin';

export default class Test extends OmniscriptBaseMixin(LightningElement) {

    @api urlForIFrame = '';

    connectedCallback() {
        //Get Json Data
        var jsonData = JSON.parse(JSON.stringify(this.omniJsonData));
        console.log(jsonData);
        //Get url for Iframe
        this.urlForIFrame = jsonData.urlForIFrame;
    }

}