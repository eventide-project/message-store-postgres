module MessageStore
  module StreamName
    Error = Class.new(RuntimeError)

    def self.id_separator
      '-'
    end

    def self.compound_id_separator
      ID.compound_id_separator
    end

    def self.category_type_separator
      ':'
    end

    def self.compound_type_separator
      '+'
    end

    def self.stream_name(category, stream_id=nil, cardinal_id: nil, id: nil, ids: nil, type: nil, types: nil)
      if category == nil
        raise Error, "Category must not be omitted from stream name"
      end

      stream_name = category

      type_list = []
      type_list.concat(Array(type))
      type_list.concat(Array(types))

      type_part = type_list.join(compound_type_separator)

      if not type_part.empty?
        stream_name = "#{stream_name}#{category_type_separator}#{type_part}"
      end

      id_list = []
      id_list << cardinal_id if not cardinal_id.nil?

      id_list.concat(Array(stream_id))
      id_list.concat(Array(id))
      id_list.concat(Array(ids))

      id_part = nil
      if not id_list.empty?
        id_part = ID.compound_id(id_list)
        stream_name = "#{stream_name}#{id_separator}#{id_part}"
      end

      stream_name
    end

    def self.split(stream_name)
      stream_name.split(id_separator, 2)
    end

    def self.get_id(stream_name)
      split(stream_name)[1]
    end

    def self.get_ids(stream_name)
      ids = get_id(stream_name)

      return [] if ids.nil?

      ID.parse(ids)
    end

    def self.get_cardinal_id(stream_name)
      id = get_id(stream_name)

      return nil if id.nil?

      ID.get_cardinal_id(id)
    end

    def self.get_category(stream_name)
      split(stream_name)[0]
    end

    def self.category?(stream_name)
      !stream_name.include?(id_separator)
    end

    def self.get_category_type(stream_name)
      return nil unless stream_name.include?(category_type_separator)

      category = get_category(stream_name)

      category.split(category_type_separator)[1]
    end

    def self.get_type(*args)
      get_category_type(*args)
    end

    def self.get_category_types(stream_name)
      type_list = get_type(stream_name)

      return [] if type_list.nil?

      type_list.split(compound_type_separator)
    end

    def self.get_types(*args)
      get_category_types(*args)
    end

    def self.get_entity_name(stream_name)
      get_category(stream_name).split(category_type_separator)[0]
    end
  end
end
