-- Core duplicate detection query
-- Rule: same vendor_name + invoice_number + invoice_amount + invoice_date
-- Excludes cancelled/rejected invoices from duplicate checks.

WITH normalized_invoices AS (
    SELECT
        invoice_id,
        vendor_id,
        UPPER(TRIM(vendor_name)) AS vendor_name_clean,
        UPPER(REPLACE(TRIM(invoice_number), ' ', '')) AS invoice_number_clean,
        invoice_date,
        ROUND(invoice_amount, 2) AS invoice_amount_clean,
        currency,
        status,
        created_at,
        CONCAT(
            UPPER(TRIM(vendor_name)), '|',
            UPPER(REPLACE(TRIM(invoice_number), ' ', '')), '|',
            DATE_FORMAT(invoice_date, '%Y-%m-%d'), '|',
            ROUND(invoice_amount, 2)
        ) AS duplicate_key
    FROM ap_invoices
    WHERE status NOT IN ('Cancelled', 'Rejected')
), duplicate_groups AS (
    SELECT
        duplicate_key,
        vendor_name_clean AS vendor_name,
        invoice_number_clean AS invoice_number,
        invoice_date,
        invoice_amount_clean AS invoice_amount,
        COUNT(*) AS duplicate_count,
        GROUP_CONCAT(invoice_id ORDER BY invoice_id SEPARATOR ', ') AS invoice_ids,
        SUM(invoice_amount_clean) AS total_invoice_value,
        SUM(invoice_amount_clean) - MIN(invoice_amount_clean) AS potential_duplicate_exposure
    FROM normalized_invoices
    GROUP BY duplicate_key, vendor_name_clean, invoice_number_clean, invoice_date, invoice_amount_clean
    HAVING COUNT(*) > 1
)
SELECT
    duplicate_key,
    vendor_name,
    invoice_number,
    invoice_date,
    invoice_amount,
    duplicate_count,
    invoice_ids,
    total_invoice_value,
    potential_duplicate_exposure,
    CASE
        WHEN potential_duplicate_exposure >= 100000 THEN 'High Risk'
        WHEN potential_duplicate_exposure >= 25000 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM duplicate_groups
ORDER BY potential_duplicate_exposure DESC;
