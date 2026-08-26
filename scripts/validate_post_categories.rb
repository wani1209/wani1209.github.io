#!/usr/bin/env ruby

require "yaml"

ROOT = File.expand_path("..", __dir__)
POST_EXTENSIONS = %w[md markdown mkdown mkdn mkd].freeze

paths = POST_EXTENSIONS.flat_map do |extension|
  Dir.glob(File.join(ROOT, "_posts", "**", "*.#{extension}"))
end
errors = []

paths.each do |path|
  relative_path = path.delete_prefix("#{ROOT}/_posts/")
  directory_parts = File.dirname(relative_path).split(File::SEPARATOR)
  source = File.read(path)
  front_matter = source[/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m, 1]

  unless front_matter
    errors << "#{relative_path}: front matter is required"
    next
  end

  data = YAML.safe_load(front_matter, permitted_classes: [Date, Time], aliases: true) || {}
  categories = data["categories"]
  categories = [categories] if categories.is_a?(String)

  unless categories.is_a?(Array) && categories.all? { |category| category.is_a?(String) && !category.empty? }
    errors << "#{relative_path}: categories must be a non-empty string array"
    next
  end

  unless directory_parts == ["."] || directory_parts.empty? || categories.first(directory_parts.length) == directory_parts
    errors << "#{relative_path}: directory #{directory_parts.join('/')} must match the beginning of categories #{categories.inspect}"
  end
end

if errors.empty?
  puts "Validated #{paths.length} post(s): directory names match categories."
else
  warn errors.join("\n")
  exit 1
end