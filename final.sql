-- Ex1
SELECT
  *
FROM 
  dsv1069.final_assignments_qa;
-- No, we need the date to compute any metrics for last 30 day

-- Ex2
SELECT
    item_id
  , test_a AS test_assignment
  , (CASE WHEN test_a IS NOT NULL
      THEN 'test_a'
      ELSE NULL
    END) AS test_number
  , (CASE WHEN test_a IS NOT NULL
      THEN '2013-01-05 00:00:00'
    END) AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT
    item_id
  , test_b AS test_assignment
  , (CASE WHEN test_b IS NOT NULL
      THEN 'test_b'
      ELSE NULL
    END) AS test_number
  , (CASE WHEN test_b IS NOT NULL
      THEN '2013-01-05 00:00:00'
    END) AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT
    item_id
  , test_c AS test_assignment
  , (CASE WHEN test_c IS NOT NULL
      THEN 'test_c'
      ELSE NULL
    END) AS test_number
  , (CASE WHEN test_c IS NOT NULL
      THEN '2013-01-05 00:00:00'
    END) AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT
    item_id
  , test_d AS test_assignment
  , (CASE WHEN test_d IS NOT NULL
      THEN 'test_d'
      ELSE NULL
    END) AS test_number
  , (CASE WHEN test_d IS NOT NULL
      THEN '2013-01-05 00:00:00'
    END) AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT
    item_id
  , test_e AS test_assignment
  , (CASE WHEN test_e IS NOT NULL
      THEN 'test_e'
      ELSE NULL
    END) AS test_number
  , (CASE WHEN test_e IS NOT NULL
      THEN '2013-01-05 00:00:00'
    END) AS test_start_date
FROM 
  dsv1069.final_assignments_qa
UNION
SELECT
    item_id
  , test_f AS test_assignment
  , (CASE WHEN test_f IS NOT NULL
      THEN 'test_f'
      ELSE NULL
    END) AS test_number
  , (CASE WHEN test_f IS NOT NULL
      THEN '2013-01-05 00:00:00'
    END) AS test_start_date
FROM 
  dsv1069.final_assignments_qa
ORDER BY
    item_id
  , test_number;
  
-- Ex3
SELECT
  test_assignment
  , COUNT(DISTINCT item_id) AS number_of_item
  , SUM(order_binary_30) AS items_ordered_30d
FROM
  (SELECT
    item_id
    , test_assignment
    , MAX(CASE WHEN created_at > test_start_date 
            AND  DATE_PART('day', created_at - test_start_date) <= 30
          THEN 1
          ELSE 0
      END) AS order_binary_30
  FROM
    (SELECT
        assignment.item_id
      , test_assignment
      , test_number
      , test_start_date
      , DATE(created_at) AS created_at
    FROM dsv1069.final_assignments AS assignment
    LEFT JOIN 
      dsv1069.orders AS orders
    ON
      assignment.item_id = orders.item_id
    WHERE
      test_number = 'item_test_2') AS test_2
  GROUP BY
      item_id
    , test_assignment) AS test_2_binary
GROUP BY 
  test_assignment;
  
-- Ex4
SELECT
    test_assignment
  , COUNT(DISTINCT item_id) AS number_of_item
  , SUM(view_binary_30d) AS items_viewed_30d
FROM
  (SELECT
        item_id
      , test_assignment
      , MAX(CASE WHEN DATE_PART('day', event_time - test_start_date) BETWEEN 0 AND 30
            THEN 1
            ELSE 0
          END) AS view_binary_30d
  FROM
    (SELECT
          event_id
        , assignments.item_id
        , DATE(event_time)               AS event_time
        , test_assignment
        , test_number
        , test_start_date
    FROM
        dsv1069.final_assignments AS assignments
    LEFT JOIN
      (SELECT
          event_time
          , event_id
          , (CASE WHEN parameter_name = 'item_id' 
                THEN CAST(parameter_value AS NUMERIC)
                ELSE NULL
              END) AS item_id
      FROM 
        dsv1069.events
      WHERE
        event_name = 'view_item') AS events
    ON
      assignments.item_id = events.item_id
    WHERE
      test_number = 'item_test_2') AS test_2
  GROUP BY
      item_id
    , test_assignment) AS viewed_binary_30d
GROUP BY
  test_assignment;
  
-- Ex5
-- For order binary for the 30 day window the p-vlaue is 