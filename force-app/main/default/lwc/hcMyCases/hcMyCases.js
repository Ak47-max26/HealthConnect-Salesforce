import { LightningElement, wire } from 'lwc';
import getMyCases from '@salesforce/apex/HCMyCasesController.getMyCases';

export default class HcMyCases extends LightningElement {
    @wire(getMyCases)
    casesResult;

    get cases() {
        return this.casesResult.data || [];
    }

    get hasCases() {
        return this.cases.length > 0;
    }

    get errorMessage() {
        return this.casesResult.error
            ? 'Unable to load your cases. Check your login and permissions.'
            : '';
    }

    get hasError() {
        return Boolean(this.errorMessage);
    }
}