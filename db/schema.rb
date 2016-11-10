# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160919134306) do

  create_table "categories", force: :cascade do |t|
    t.boolean  "is_active",              default: true
    t.string   "slug",       limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "categories", ["is_active"], name: "index_categories_on_is_active", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "categories_experiments", id: false, force: :cascade do |t|
    t.integer "category_id",   limit: 4, null: false
    t.integer "experiment_id", limit: 4, null: false
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id", limit: 4,     null: false
    t.string   "locale",      limit: 255,   null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.string   "slug",        limit: 255
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree
  add_index "category_translations", ["slug"], name: "index_category_translations_on_slug", using: :btree
  add_index "category_translations", ["title"], name: "index_category_translations_on_title", using: :btree

  create_table "direction_images", force: :cascade do |t|
    t.integer  "direction_id",       limit: 4
    t.integer  "sort_order",         limit: 1,   default: 1
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  add_index "direction_images", ["direction_id"], name: "index_direction_images_on_direction_id", using: :btree
  add_index "direction_images", ["sort_order"], name: "index_direction_images_on_sort_order", using: :btree

  create_table "direction_translations", force: :cascade do |t|
    t.integer  "direction_id", limit: 4,     null: false
    t.string   "locale",       limit: 255,   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "content",      limit: 65535
  end

  add_index "direction_translations", ["direction_id"], name: "index_direction_translations_on_direction_id", using: :btree
  add_index "direction_translations", ["locale"], name: "index_direction_translations_on_locale", using: :btree

  create_table "directions", force: :cascade do |t|
    t.integer  "experiment_id", limit: 4
    t.integer  "sort_order",    limit: 1, default: 1
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "directions", ["experiment_id"], name: "index_directions_on_experiment_id", using: :btree
  add_index "directions", ["sort_order"], name: "index_directions_on_sort_order", using: :btree

  create_table "experiment_translations", force: :cascade do |t|
    t.integer  "experiment_id", limit: 4,     null: false
    t.string   "locale",        limit: 255,   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "title",         limit: 255
    t.text     "intro",         limit: 65535
    t.text     "explanation",   limit: 65535
    t.text     "warning",       limit: 65535
    t.string   "slug",          limit: 255
  end

  add_index "experiment_translations", ["experiment_id"], name: "index_experiment_translations_on_experiment_id", using: :btree
  add_index "experiment_translations", ["locale"], name: "index_experiment_translations_on_locale", using: :btree
  add_index "experiment_translations", ["slug"], name: "index_experiment_translations_on_slug", using: :btree
  add_index "experiment_translations", ["title"], name: "index_experiment_translations_on_title", using: :btree

  create_table "experiments", force: :cascade do |t|
    t.boolean  "needs_adult_supervision",                   default: false
    t.boolean  "is_active",                                 default: false
    t.datetime "active_at"
    t.string   "slug",                          limit: 255
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "thumbnail1_file_name",          limit: 255
    t.string   "thumbnail1_content_type",       limit: 255
    t.integer  "thumbnail1_file_size",          limit: 4
    t.datetime "thumbnail1_updated_at"
    t.string   "thumbnail2_file_name",          limit: 255
    t.string   "thumbnail2_content_type",       limit: 255
    t.integer  "thumbnail2_file_size",          limit: 4
    t.datetime "thumbnail2_updated_at"
    t.string   "ingredient_image_file_name",    limit: 255
    t.string   "ingredient_image_content_type", limit: 255
    t.integer  "ingredient_image_file_size",    limit: 4
    t.datetime "ingredient_image_updated_at"
  end

  add_index "experiments", ["is_active"], name: "index_experiments_on_is_active", using: :btree
  add_index "experiments", ["slug"], name: "index_experiments_on_slug", unique: true, using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "ingredient_translations", force: :cascade do |t|
    t.integer  "ingredient_id", limit: 4,   null: false
    t.string   "locale",        limit: 255, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "content",       limit: 255
  end

  add_index "ingredient_translations", ["ingredient_id"], name: "index_ingredient_translations_on_ingredient_id", using: :btree
  add_index "ingredient_translations", ["locale"], name: "index_ingredient_translations_on_locale", using: :btree

  create_table "ingredients", force: :cascade do |t|
    t.integer  "experiment_id", limit: 4
    t.integer  "sort_order",    limit: 1, default: 1
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "ingredients", ["sort_order"], name: "index_ingredients_on_sort_order", using: :btree

  create_table "page_content_translations", force: :cascade do |t|
    t.integer  "page_content_id", limit: 4,     null: false
    t.string   "locale",          limit: 255,   null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "title",           limit: 255
    t.text     "content",         limit: 65535
  end

  add_index "page_content_translations", ["locale"], name: "index_page_content_translations_on_locale", using: :btree
  add_index "page_content_translations", ["page_content_id"], name: "index_page_content_translations_on_page_content_id", using: :btree

  create_table "page_contents", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id",                limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

end
