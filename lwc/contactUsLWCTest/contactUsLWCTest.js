import { LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_ins/omniscriptBaseMixin';

export default class ContactUsLWCTest extends OmniscriptBaseMixin(LightningElement) {
  myMap = new Map();
  errorMessage = "";
  errors = false;

   checkValidity() {
     if(this.myMap.size > 0){
      if(this.myMap.get("phone").length!=10){
        this.errorMessage = "Phone should be 10 caracters only!";
        this.errors = true;
        return false;
      }else if(!this.myMap.get("email").contains('@')){
        this.errorMessage = this.errorMessage + "\nEmail format is not correct";
        this.errors = true;
        return false;
      }
     }
     this.errors = false;
     return true;
   }

  handleChange(evt) {
    this.myMap.set(evt.target.name, evt.target.value);
    let saveData = {[evt.target.name] : evt.target.value};
    this.omniUpdateDataJson(saveData);
  }

  nextButton(evt) {
    if(this.checkValidity() && this.myMap.size !=0){
      if (evt) {
        this.omniNextStep();
      }
    }
  }
}