class Unit
  include DataMapper::Resource

  property :id,           Integer,  :serial => true    # primary serial key
  property :provider,     String
  property :phrase,       String,   :nullable => false # cannot be null
  property :translation,  Text
  property :count,        Integer,  :default => 0
  property :created_at,   DateTime
  property :updated_at,   DateTime
  
  default_scope(:default).update(:order => [:updated_at.desc])
end