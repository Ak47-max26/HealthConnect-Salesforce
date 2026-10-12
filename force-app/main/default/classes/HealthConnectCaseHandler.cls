public class HealthConnectCaseHandler {
    public static void beforeSave(List<Case> newCases) {
        for (Case c : newCases) {
            if (c.ContactId == null) {
                c.addError('A patient Contact is required.');
            }

            if (c.Care_Category__c == 'Follow-up'
                && c.Status != 'Closed'
                && c.Follow_Up_Date__c == null) {
                c.addError(
                    'Enter a follow-up date for an open follow-up Case.'
                );
            }

            if (c.Status == 'Closed'
                && String.isBlank(c.Resolution_Notes__c)) {
                c.addError(
                    'Enter resolution notes before closing this Case.'
                );
            }
        }
    }
}
