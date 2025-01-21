SELECT TOP 1000  -- Number of Users Sampled
    Users.Id AS UserId,                   
    Users.DisplayName,                    
    Users.Reputation,                     
    Users.CreationDate,                   
    Users.LastAccessDate,                 
    Users.UpVotes,                        
    Users.DownVotes,                      
    AggregatedData.QuestionCount,         -- Number of questions asked
    AggregatedData.AnswerCount,           -- Number of answers provided
    AggregatedData.TotalCommentCount      -- Total comments posted
FROM Users
LEFT JOIN (
    
    SELECT 
        OwnerUserId,  -- User ID from Posts table
        COUNT(CASE WHEN PostTypeId = 1 THEN 1 END) AS QuestionCount,  -- Total questions
        COUNT(CASE WHEN PostTypeId = 2 THEN 1 END) AS AnswerCount,    -- Total answers
        SUM(CommentCount) AS TotalCommentCount                       -- Total comments from all posts
    FROM Posts
    GROUP BY OwnerUserId
) AS AggregatedData
ON Users.Id = AggregatedData.OwnerUserId
WHERE Users.Reputation IS NOT NULL          -- Ensure reputation data exists
  AND Users.CreationDate IS NOT NULL        -- Ensure creation date exists
ORDER BY NEWID();                           
