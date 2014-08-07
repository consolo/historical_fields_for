gem 'activerecord'

##
# Tracks fields historically over time when they get updated
# Note, this should be placed after all the other before_save calls,
# that might set values and such.
#
module CoHack
  module HistoricalFields
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def historical_fields_for(*attributes)
        
        self.class_eval do
          has_many :historical_fields, :as => :parent, :dependent => :destroy
        end
        
        attributes.collect(&:to_s).each do |attribute|
          self.class_eval do
            has_many attribute.pluralize, -> { where('historical_fields.field_name = ?', attribute).order('historical_fields.created_at ASC') }, :class_name => 'HistoricalField', :as => :parent
            
            send :define_method, "#{attribute}=" do |new_value|
              if send(attribute) != new_value
                calculated_value = new_value.is_a?(String) ? new_value : new_value.to_json
                self.historical_fields.build(field_name: attribute, field_value: calculated_value)
              end
              super(new_value)
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, CoHack::HistoricalFields
