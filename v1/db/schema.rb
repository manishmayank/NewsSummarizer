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

ActiveRecord::Schema.define(version: 20150524080613) do

  create_table "articles", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "content",     limit: 65535
    t.string   "image_url",   limit: 255
    t.string   "category",    limit: 255
    t.string   "source",      limit: 255
    t.string   "source_url",  limit: 255
    t.datetime "report_time"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "articles_keywords", id: false, force: :cascade do |t|
    t.integer "article_id", limit: 4
    t.integer "keyword_id", limit: 4
  end

  add_index "articles_keywords", ["article_id", "keyword_id"], name: "index_articles_keywords_on_article_id_and_keyword_id", using: :btree

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "article_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "bookmarks", ["user_id", "article_id"], name: "index_bookmarks_on_user_id_and_article_id", using: :btree

  create_table "keywords", force: :cascade do |t|
    t.string   "keyword",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "summaries", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.text     "summary",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "summaries", ["article_id"], name: "index_summaries_on_article_id", using: :btree

  create_table "user_article_views", id: false, force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "article_id", limit: 4
    t.string   "type",       limit: 255
    t.text     "data",       limit: 65535
    t.datetime "view_time"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "user_article_views", ["user_id", "article_id"], name: "index_user_article_views_on_user_id_and_article_id", using: :btree

  create_table "user_recommends", id: false, force: :cascade do |t|
    t.integer "user_id",    limit: 4
    t.integer "article_id", limit: 4
  end

  add_index "user_recommends", ["user_id", "article_id"], name: "index_user_recommends_on_user_id_and_article_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 255
    t.string   "first_name",      limit: 255
    t.string   "last_name",       limit: 255
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

end
