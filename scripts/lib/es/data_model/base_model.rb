#
# es/scripts/lib/es/gdata/data_model.rb
#   by IceDragon
# DataModel serves as the base class for all other Data objects in ES
# This was copied from the original Earthen source and updated to with moon.
module ES
  module DataModel
    class BaseModel

      class MissingOption < StandardError

        def initialize(type)
          super("missing option #{type}")
        end

      end

      def self.fields
        (@fields ||= [])
      end

      def self.all_fields
        ancestors.reverse.inject([]) do |r, c|
          c.respond_to?(:fields) ? r + c.fields : r
        end + fields
      end

      def self.field(sym, options)
        raise MissingOption.new(:type) unless options.key?(:type)
        fields << [sym, options]

        type = options[:type]
        allow_nil = options[:allow_nil]
        setter = "_#{sym}_set"

        attr_accessor sym
        alias_method setter, "#{sym}="

        define_method "#{sym}=" do |obj|
          unless obj.is_a?(type) || (allow_nil && (obj == nil))
            raise TypeError,
                  "wrong type #{obj.class.inspect} (expected #{type.inspect})"
          end
          send(setter, obj)
        end
      end

      @@dmid = 0

      attr_reader :dmid          # DataModel ID
      field :id,   type: Integer, default: 0         # ID
      field :name, type: String,  default: proc {""} # Name of this model
      field :note, type: String,  default: proc {""} # A string for describing this DataModel
      field :tags, type: Array,   default: proc {[]} # Used for lookups
      field :meta, type: Hash,    default: proc {{}} # Meta Data, String Values and String Keys

      def initialize(opts={})
        opts.each { |k, v| send(k.to_s + "=", v) }
        initialize_fields(opts.keys)
        @dmid = @@dmid += 1
      end

      def initialize_fields(dont_init=[])
        self.class.all_fields.each do |k, options|
          next if dont_init.include?(k)
          case v = options[:default]
          when Proc
            send(k.to_s + "=", v.call(options[:type], self))
          else
            send(k.to_s + "=", v)
          end
        end
      end

      def to_h
        hsh = Hash.new
        self.class.all_fields.each do |_, k|
          hsh[k] = send(k)
        end
        hsh
      end

      private :initialize_fields

    end
  end
end