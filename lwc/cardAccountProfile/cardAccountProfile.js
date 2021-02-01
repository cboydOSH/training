import { LightningElement , wire, track, api} from 'lwc';
import { BaseState } from "vlocity_ins/baseState";

export default class ProfileCardState extends BaseState(LightningElement) {
    
    mapMarkers = [{
        location: {
            Street: '1 Market St',
            City: 'San Francisco',
            Country: 'USA'
        },
       
    }];

    renderedCallback() {
        const style = document.createElement('style');
        style.innerText = `.custom .slds-icon {
            fill: white  !important;
        }`;
        this.template.querySelector('lightning-icon').appendChild(style);
    }

}