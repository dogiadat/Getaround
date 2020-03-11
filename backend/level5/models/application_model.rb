class ApplicationModel
  include Virtus.model

  class << self
    attr_accessor :all_record

    def find id
      new @all_record.detect {|f| f["id"] == id }
    end
  end
end
