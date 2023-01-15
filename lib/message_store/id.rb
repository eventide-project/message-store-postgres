module MessageStore
  module ID
    Error = Class.new(RuntimeError)

    def self.compound_id_separator
      '+'
    end

    def self.id(id)
      if id.is_a?(Array)
        id = compound_id(id)
      else
        if id.nil?
          raise Error, "ID must not be omitted"
        end
      end

      id
    end

    def self.compound_id(ids)
      if ids.empty?
        raise Error, "IDs must not be omitted"
      end

      ids.join(compound_id_separator)
    end

    def self.get_cardinal_id(id)
      parse(id).first
    end

    def self.parse(id)
      if id.nil?
        raise Error, "ID must not be omitted"
      end

      id.split(compound_id_separator)
    end
  end
end
