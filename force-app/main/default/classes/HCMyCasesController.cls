public with sharing class HCMyCasesController {
    @AuraEnabled(cacheable=true)
    public static List<Case> getMyCases() {
        Id contactId;

        List<User> currentUsers = [
            SELECT ContactId
            FROM User
            WHERE Id = :UserInfo.getUserId()
            WITH USER_MODE
            LIMIT 1
        ];

        if (currentUsers.isEmpty()) {
            return new List<Case>();
        }

        contactId = currentUsers[0].ContactId;

        if (contactId == null) {
            return new List<Case>();
        }

        return [
            SELECT Id, CaseNumber, Subject, Status, Priority, CreatedDate
            FROM Case
            WHERE ContactId = :contactId
            WITH USER_MODE
            ORDER BY CreatedDate DESC
            LIMIT 50
        ];
    }
}