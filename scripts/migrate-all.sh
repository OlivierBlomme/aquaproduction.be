#!/bin/bash

die() {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "2 arguments required, $# provided"

LOCAL_PATH=$1
SITE_URI=$2

cd "$LOCAL_PATH" || die "Directory does not exist"

# Make drush available
export PATH="$PATH:$LOCAL_PATH/vendor/drush/drush"

run_drush() {
    $LOCAL_PATH/vendor/drush/drush/drush -l "$SITE_URI" "$@"
}

start_date_time="$(date "+%Y-%m-%d %H:%M:%S")"
echo "Migrate Verdesoft tables: [START] -- ${start_date_time}"
echo "------------------------------------------------------"

echo "Resetting all migrations"

migrations=(
    plantgroups_root_terms_default
    plantgroups_sub_terms_default
    plantgroups_root_term_translations:nl
    plantgroups_root_term_translations:en
    plantgroups_sub_term_translations:nl
    plantgroups_sub_term_translations:en
    volume_discounts_base
    product_properties_vocabularies_default
    product_properties_terms_default
    product_properties_term_translations:nl
    product_properties_term_translations:en
    product_images_base
    commerce_product_attribute_size
    commerce_product_variations_default
    commerce_products_default
    commerce_products_properties:properties
    commerce_product_translations:nl
    commerce_product_translations:en
)

for migration in "${migrations[@]}"; do
    run_drush mrs "$migration"
done

echo "Synching"

sync_migrations=(
    product_images_base
    volume_discounts_base
    "--group=categories"
    "--group=properties"
    "--group=products"
)

for sync_migration in "${sync_migrations[@]}"; do
    run_drush mim "$sync_migration"
done

end_date_time="$(date "+%Y-%m-%d %H:%M:%S")"
echo "Migrate Verdesoft tables: [END] -- ${end_date_time}"
echo "------------------------------------------------------"
