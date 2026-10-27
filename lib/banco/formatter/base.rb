# frozen_string_literal: true

module Banco
  module Formatter
    class Base
      def self.inherited(subclass)
        super
        registry << subclass
      end

      def self.registry
        @registry ||= []
      end

      def self.for_name(name)
        registry.find { |f| f.format_name == name.to_s } ||
          raise(ArgumentError, "Unknown format: #{name}. Available: #{names.join(', ')}")
      end

      def self.names
        registry.map(&:format_name)
      end

      def self.format_name
        name.split('::').last.downcase
      end

      def initialize(report)
        @report = report
      end

      def call
        raise NotImplementedError, "#{self.class} must implement #call"
      end
    end
  end
end
