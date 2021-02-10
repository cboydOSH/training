import { LightningElement, track} from 'lwc';
import { BaseState } from "vlocity_ins/baseState";

export default class CommunityProducerCards extends BaseState(LightningElement){
    @track prospects;
    @track applications;
    @track cases;
    @track URL;

    connectedCallback() {
        var jsonSource = JSON.parse(JSON.stringify(this.obj));
        this.prospects = jsonSource.Prospects;
        this.applications = jsonSource.ApplicationsInProgress;
        this.cases = jsonSource.OpenCases;
        this.URL = window.location.origin + "/producercommunity/s/open-cases-report";
    }
}