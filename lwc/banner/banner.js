import { LightningElement, api, track } from 'lwc';
import { BaseState } from "vlocity_ins/baseState";

export default class Banner extends BaseState(LightningElement) {
    @api accountAllData;

    @api 
    get accountData() {
        return this.accountAllData;
    }
    
    connectedCallback() {
    this.accountAllData = JSON.parse(JSON.stringify(this.obj.Account));
    console.log('Test data: ', this.accountAllData);
    var InactiveDate = account.InactiveDate;
    console.log('AffiList: ', InactiveDate);
    }
}