SET
    FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS migrate_products;

CREATE TABLE migrate_products (
    code VARCHAR(20) NOT NULL,
    latin_name VARCHAR(100) DEFAULT NULL,
    genus VARCHAR(100) DEFAULT NULL,
    name_nl VARCHAR(50) DEFAULT NULL,
    name_fr VARCHAR(50) DEFAULT NULL,
    name_en VARCHAR(50) DEFAULT NULL,
    name_de VARCHAR(50) DEFAULT NULL,
    description_nl longtext,
    description_fr longtext,
    description_en longtext,
    description_de longtext,
    vat VARCHAR(50) DEFAULT NULL,
    group_id INT DEFAULT NULL,
    sub_group_id INT DEFAULT NULL,
    variation_ids VARCHAR(255) DEFAULT NULL,
    last_changed TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (code),
    KEY ndx_groups (group_id, sub_group_id)
);

INSERT INTO
    migrate_products (
        code,
        latin_name,
        genus,
        name_nl,
        name_fr,
        name_en,
        name_de,
        description_nl,
        description_fr,
        description_en,
        description_de,
        vat,
        group_id,
        sub_group_id,
        variation_ids,
        last_changed
    )
SELECT
    a.Code,
    a.Name,
    a.ArtName,
    a.Memo2,
    a.Memo1,
    '',
    '',
    a.Memo6,
    a.Memo5,
    '',
    '',
    a.VatCode,
    g.id,
    sg.id,
    GROUP_CONCAT(
        DISTINCT a.id
        ORDER BY
            a.id ASC
    ) AS variation_ids,
    MAX(a.LastUpdate) as LastUpdate
FROM
    articles a
    LEFT JOIN artgroup g ON a.GroupCode = g.Code
    LEFT JOIN artsubgroup sg ON a.SubgroupCode = sg.Code
WHERE
    a.Cat = 1
    AND a.Name <> ''
    AND g.Webshop = 1
GROUP BY
    a.Code
ORDER BY
    a.Code ASC;

SET
    FOREIGN_KEY_CHECKS = 1;