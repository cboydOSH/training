import { LightningElement, track } from 'lwc';
import { BaseState } from "vlocity_ins/baseState";

export default class CommunityMemberCustomList extends BaseState(LightningElement){
    @track quotes;
    @track showSpinner;
    @track isOneElement = false;
    @track firstQuote;
    @track domain;
    @track newInfoPacketLink;

    @track showTable = false;
    @track showMessage = false;

    connectedCallback() {
        var jsonSource = JSON.parse(JSON.stringify(this.obj));
        this.quotes = jsonSource.Quotes.QuoteList;
        this.countQuotes = jsonSource.CountQuotes;
        this.domain = jsonSource.Domain;
        this.newInfoPacketLink = "https://";
        this.newInfoPacketLink += this.domain;
        this.newInfoPacketLink += "/membercommunity/s/new-information-packet";
       
        if(this.quotes == undefined){
            this.showMessage = true;
        } 
        else if (this.quotes.length == 1) {
            this.firstQuote = this.quotes[0];
            this.showTable = true;
            this.isOneElement = true;
        } else {
            this.showTable = true;
        }

        for(let i = 0; i < this.quotes.length; i++){
                const quote = this.quotes[i];
                quote.EnrollLink = "https://";
                quote.EnrollLink += this.domain; 
                quote.EnrollLink += "/membercommunity/s/enroll-now?ContextId=";
                quote.EnrollLink += quote.Id;
                quote.EnrollLink += "&Thisisdirect=true&thisIsCommunity=true";
        }
    }
    
}