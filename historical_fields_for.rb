gem 'activerecord', '~> 2.3'

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
        
        attributes.each do |attribute|
          self.class_eval do
            has_many "#{attribute}".pluralize, :class_name => "HistoricalField", :as => :parent, :dependent => :destroy
          end
        end
        
        send :define_method, "create_the_historical_fields".to_sym do
          attributes.each do |attribute|
            if self.changed.include?(attribute.to_s) and self.changes[attribute.to_s][0] != self.changes[attribute.to_s][1]
              self.send("#{attribute}".pluralize) << HistoricalField.new(
                :parent_type => self.class.to_s,
                :parent_id => self.id,
                :field_name => attribute.to_s,
                :field_value => self.changes[attribute.to_s][1].to_s
              )
            end
          end
          true
        end
        
        self.class_eval do
          before_save :create_the_historical_fields
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, CoHack::HistoricalFields
