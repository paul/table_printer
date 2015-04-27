require "table_printer/version"

module TablePrinter

  def print_table(data, &config)
    Table.new(data, &config).render
  end

  class Table
    attr_reader :columns, :data

    def initialize(data = [], &block)
      @data = data
      @columns = []
      instance_eval(&block) if block_given?
      generate_default_columns!
      load_column_values!
    end

    def column(*names)
      options = names.last.is_a?(Hash) ? names.pop : {}
      names.each do |name|
        columns << Column.new(name, options)
      end
    end

    def render
      "".tap do |output|
        output << render_header
        output << render_body
        output << "\n"
      end
    end

    def to_s
      render
    end

    private

    def generate_default_columns!
      return unless columns.empty?
      if data_is_hashes?
        data.first.keys.each { |name| columns << Column.new(name) }
      else
        data.first.size.times { columns << Column.new(nil) }
      end
    end

    def load_column_values!
      if data_is_hashes?
        load_column_values_from_hash
      else
        load_column_values_from_array
      end
    end

    def load_column_values_from_hash
      data.each do |row|
        row.each do |name, value|
          column = columns.detect { |c| c.name == name }
          column.values << value if column
        end
      end
    end

    def load_column_values_from_array
      data.each do |row|
        row.each.with_index do |value, i|
          columns[i].values << value
        end
      end
    end

    def render_header
      "".tap do |str|
        if columns.any? { |col| col.has_header? }
          str << " " << columns.map { |col| col.header }.join(" | ") << "\n"
          str << columns.map { |col| col.separator }.join("|") << "\n"
        end
      end
    end

    def render_body
      "".tap do |str|
        data.each.with_index do |row, i|
          str << " " << columns.map { |col| col.justified_values[i] }.join(" | ") << "\n"
        end
      end
    end

    def data_is_hashes?
      return @data_is_hashes if defined? @data_is_hashes
      @data_is_hashes = !data.empty? && data.first.respond_to?(:keys)
    end

    class Column
      attr_reader :name, :values, :options

      def initialize(name, options = {})
        @name, @options = name, options
        @values = []
      end

      def has_header?
        !name.nil?
      end

      def header
        title.center(width)
      end

      def separator
        case justification
          when :ljust  then l, r = " ", " "
          when :rjust  then l, r = " ", ":"
          when :center then l, r = ":", ":"
        end
        [l, "-" * width, r].join
      end

      def formatted_values
        @formatted_values ||= @values.map { |v| format(v) }
      end

      def justified_values
        @justified_values ||= formatted_values.map { |v| v.send(justification, width) }
      end

      def title
        options[:title] || name.to_s
      end

      protected

      ### FIXME: values is expecting to know the width, err: stack level too deep
      def width
        @width ||= [title, formatted_values].flatten.map(&:length).max
      end

      def numeric?
        @values.all? { |v| v.is_a?(Numeric) }
      end

      def format(value)
        case options[:format]
          when Proc      then options[:format].call(value)
          when String    then (options[:format] % value)
          when :percent  then "%0.1f%%" % (value * 100)
          when :bytes    then format_bytes(value)
          when :time     then format_time(value)
          when :duration then format_duration(value)
          else value.to_s
        end
      end

      def justification
        case options[:justify].to_s
          when "left"   then :ljust
          when "right"  then :rjust
          when "center" then :center
          else (numeric? ? :rjust : :ljust)
        end
      end

      IEC = %w[KiB MiB GiB TiB PiB EiB ZiB YiB]
      def format_bytes(value, level = 0)
        format = "B"
        iec = IEC.dup
        while value > 512 and iec.any?
          value /= 1024.0
          format = iec.shift
        end
        value = value.round(2) if value.is_a?(Float)
        "#{value} #{format}"
      end

      DEFAULT_TIME_FORMAT="%FT%TZ"
      def format_time(time)
        time = Time.at(time) unless time.respond_to?(:strftime)
        time.utc.strftime(DEFAULT_TIME_FORMAT)
      end

      def format_duration(seconds)
        minutes, seconds = seconds.divmod(60)
        hours, minutes = minutes.divmod(60)
        out = []
        out << hours if hours > 0
        out << minutes if hours > 0 or minutes > 0
        out << seconds
        out.map { |v| "%02d" % v }.join(":")
      end



    end

  end
end
