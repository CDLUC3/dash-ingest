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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140813182405) do

  create_table "alternate_identifiers", :force => true do |t|
    t.string   "alternateIdentifierName"
    t.string   "alternateIdentifierType"
    t.integer  "record_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "citations", :force => true do |t|
    t.text     "citationName"
    t.integer  "record_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "contributors", :force => true do |t|
    t.string   "contributorType"
    t.string   "contributorName"
    t.integer  "record_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "creators", :force => true do |t|
    t.string   "creatorName"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "record_id"
  end

  create_table "datauploads", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "record_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "descriptions", :force => true do |t|
    t.string   "descriptionType"
    t.text     "descriptionText"
    t.integer  "record_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "institutions", :force => true do |t|
    t.string   "abbreviation"
    t.string   "short_name"
    t.string   "long_name"
    t.string   "landing_page"
    t.string   "external_id_strip"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "campus"
    t.string   "logo"
  end

  create_table "records", :force => true do |t|
    t.string   "identifier"
    t.string   "identifierType"
    t.string   "publisher"
    t.string   "publicationyear"
    t.string   "resourcetype"
    t.text     "rights"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_id"
    t.string   "title"
    t.string   "local_id"
    t.text     "abstract"
    t.text     "methods"
    t.text     "rights_uri"
    t.integer  "institution_id"
  end

  add_index "records", ["institution_id"], :name => "index_records_on_institution_id"

  create_table "relations", :force => true do |t|
    t.string   "relationText"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "record_id"
  end

  create_table "subjects", :force => true do |t|
    t.string   "subjectName"
    t.string   "subjectScheme"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "record_id"
  end

  create_table "submission_logs", :force => true do |t|
    t.text     "archiveresponse"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "record_id"
  end

  create_table "upload_archives", :force => true do |t|
    t.string   "upload_file_name"
    t.string   "upload_file_size"
    t.integer  "submission_log_id"
    t.string   "upload_content_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "uploads", :force => true do |t|
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "record_id"
  end

  create_table "users", :force => true do |t|
    t.string   "external_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "email"
    t.integer  "institution_id"
  end

  add_index "users", ["institution_id"], :name => "index_users_on_institution_id"

end
