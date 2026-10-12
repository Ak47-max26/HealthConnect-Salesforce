@IsTest
private class HealthConnectFollowUpJobTest {
    @IsTest
    static void createsFollowUpTaskForDueCase() {
        Account a = new Account(
            Name = 'HealthConnect Test Center'
        );
        insert a;

        Contact patient = new Contact(
            LastName = 'Test Patient',
            AccountId = a.Id
        );
        insert patient;

        Case c = new Case(
            ContactId = patient.Id,
            AccountId = a.Id,
            Subject = 'Follow-up test',
            Status = 'New',
            Origin = 'Phone',
            Priority = 'Normal',
            Care_Category__c = 'Follow-up',
            Follow_Up_Date__c = Date.today()
        );
        insert c;

        Test.startTest();
        System.enqueueJob(new HealthConnectFollowUpJob());
        Test.stopTest();

        List<Task> createdTasks = [
            SELECT Id, Subject, WhatId, WhoId
            FROM Task
            WHERE WhatId = :c.Id
        ];

        System.assertEquals(
            1,
            createdTasks.size(),
            'One follow-up Task should be created.'
        );
        System.assertEquals(c.Id, createdTasks[0].WhatId);
        System.assertEquals(
            patient.Id,
            createdTasks[0].WhoId
        );
    }
}
