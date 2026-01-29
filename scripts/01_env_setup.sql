/* STEP 1: ENVIRONMENT SETUP & MAPPING
   Purpose: Create supporting structures and reference tables.
*/

-- Create a temporary mapping table to localize Brazilian states to Vietnam regions
-- This demonstrates the ability to enrich raw data with local context.
CREATE TEMP TABLE vn_region_mapping (
    original_state CHAR(2),
    vn_city VARCHAR(50),
    vn_region VARCHAR(20)
);

INSERT INTO vn_region_mapping VALUES 
('SP', 'Ho Chi Minh City', 'South'),
('PR', 'Hai Phong', 'North'),
('MG', 'Da Nang', 'Central'),
('SC', 'Binh Duong', 'South'),
('RJ', 'Ha Noi', 'North'),
('RS', 'Can Tho', 'South'),
('GO', 'Bac Ninh', 'North');

-- Verify mapping
SELECT * FROM vn_region_mapping LIMIT 100;