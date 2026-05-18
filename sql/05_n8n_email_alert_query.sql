-- Query used by n8n to fetch open duplicate invoice alerts.

SELECT
    alert_id,
    vendor_name,
    invoice_number,
    invoice_date,
    invoice_amount,
    duplicate_count,
    invoice_ids,
    total_duplicate_exposure,
    CASE
        WHEN total_duplicate_exposure >= 100000 THEN 'High Risk'
        WHEN total_duplicate_exposure >= 25000 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category,
    created_at
FROM duplicate_invoice_alerts
WHERE alert_status = 'Open'
ORDER BY total_duplicate_exposure DESC, created_at DESC;
