class DataTranslator
  class << self
    def import_from input_file_path
      data = File.read(input_file_path)
      JSON.parse(data)
    end

    def export_to output_file_path, data
      IO.write output_file_path, JSON.pretty_generate(data)
    end
  end
end
