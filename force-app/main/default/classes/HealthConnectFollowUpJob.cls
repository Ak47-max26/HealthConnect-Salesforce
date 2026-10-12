public class HealthConnectFollowUpJob
    implements Queueable {

    public void execute(QueueableContext context) {
        List<Case> dueCases = [
            SELECT Id, CaseNumber, Subject, ContactId,
                   OwnerId, Follow_Up_Date__c
            FROM Case
            WHERE Status != 'Closed'
              AND Follow_Up_Date__c <= TODAY
              AND Follow_Up_Date__c != null
            ORDER BY Follow_Up_Date__c ASC
            LIMIT 200
        ];

        List<Task> tasksToInsert = new List<Task>();

        for (Case c : dueCases) {
            Task t = new Task();
            t.Subject = 'HealthConnect follow-up: Case '
                + c.CaseNumber;
            t.WhatId = c.Id;
            t.WhoId = c.ContactId;
            t.OwnerId = c.OwnerId;
            t.ActivityDate = Date.today();
            t.Status = 'Not Started';
            t.Priority = 'Normal';
            tasksToInsert.add(t);
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }
}
