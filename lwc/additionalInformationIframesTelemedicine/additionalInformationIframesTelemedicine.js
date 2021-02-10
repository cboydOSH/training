import { LightningElement, track, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_ins/omniscriptBaseMixin';

export default class AdditionalInformationIframesTelemedicine extends OmniscriptBaseMixin(LightningElement) {

    @api urlForIFrame = 'https://www.google.com';
    @api found = false;
    @api discountName = '';

    connectedCallback() {
        //Get Json Data
        var jsonData = JSON.parse(JSON.stringify(this.omniJsonData));
        console.log(window.location.href);
        var urlArray = window.location.href.split('/');
        console.log(urlArray);
        var dropdownSelection = urlArray[urlArray.length-1];
        console.log(dropdownSelection);
        dropdownSelection = dropdownSelection.replaceAll("-", " ");
        this.discountName = dropdownSelection + ' Discount Information';
        console.log('key for search', dropdownSelection);
        console.log('where to search', jsonData);
        if(jsonData.urlArray!=undefined){
            jsonData.urlArray.forEach(element => {
                if((element.Type == dropdownSelection || element.Type.includes(dropdownSelection)) && element.url!=""){
                    this.found = true;
                    this.urlForIFrame = element.url;
                }
            });
        }
    }

}