import { LightningElement, track, api  } from 'lwc';
import { OmniscriptBaseMixin } from "vlocity_ins/omniscriptBaseMixin";

export default class GoBackLWC extends OmniscriptBaseMixin(LightningElement){
    renderedCallback() {
        this.omniPrevStep(); 
    }
}