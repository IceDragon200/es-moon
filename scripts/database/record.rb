module Database
  module Record
    module ClassMethods
      def init_record_cache
        ##
        # DB Cache is used to store externally loaded files
        # @type [Hash<filename: String, object: Object>]
        @record_cache = {}
        ##
        # DB Pool stores all the active records including those loaded into the
        # record_cache, as of such, its possible to have a pool that has entries
        # that the cache doesn't have
        @record_pool = []
      end

      def record_cache
        @record_cache ||= {}
      end

      def record_pool
        @record_pool ||= []
      end

      private def add_to_pool(obj)
        record_pool << obj
      end

      def all
        record_pool.to_a
      end

      def create(options)
        object = new options
        add_to_pool object
        yield object if block_given?
        object
      end

      def where(options = {})
        if block_given?
          record_pool.select { |e| yield e }
        else
          return record_pool if options.empty?
          record_pool.select do |e|
            options.all? { |k, v| e.query(k, v) }
          end
        end
      end

      def find(id_or_ids = nil, &block)
        if id_or_ids.is_a?(Enumerable)
          where { |e| id_or_ids.any? { |i| e.query(:id, i) } }
        else
          where(id: id_or_ids, &block)
        end
      end

      def find_by(options = {}, &block)
        where(options, &block).first
      end

      def take
        record_pool.sample
      end

      def first
        record_pool.first
      end

      def last
        record_pool.last
      end

      def load_file(basename)
        record_cache[basename] ||= begin
          object = load Moon::DataLoader.file(basename)
          object.record_basename = basename
          record_cache[basename] = object
          add_to_pool(object)
          object
        end
      end

      def clear
        record_cache.clear
        record_pool.clear
      end

      def self.extended(mod)
        mod.init_record_cache
        super
      end
    end

    module InstanceMethods
      include Queryable

      attr_accessor :record_basename
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
