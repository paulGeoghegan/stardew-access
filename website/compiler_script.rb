#!/usr/bin/env ruby
# A ruby script that converts the markdown docs of the Docusaurus site
# (website/docs and website/guides) to standalone html using kramdown
# (https://kramdown.gettalong.org/rdoc/index.html), so they can be shipped
# with the mod and read offline.
# The html is saved in the stardew-access/compiled-docs directory:
#   website/docs/*.md   -> compiled-docs/*.html
#   website/guides/*.md -> compiled-docs/guides/*.html
# Use the following command to execute this script:
#   ruby compiler_script.rb
# Note that you have to cd into the website directory before running the above command

require 'kramdown'
require 'fileutils'

compiled_docs_dir = File.join("..", "stardew-access", "compiled-docs")
FileUtils.mkdir_p(compiled_docs_dir) unless File.directory?(compiled_docs_dir)

# [source dir, output sub dir]
sources = [["docs", ""], ["guides", "guides"]]

# Docusaurus links are site routes (/docs/setup#x, /guides/, ...); turn them
# into relative links between the compiled html files.
def rewrite_routes(html, out_sub_dir)
  up = out_sub_dir.empty? ? "" : "../"
  html.gsub(%r{href="/(docs|guides)/?([^"#]*)(#[^"]*)?"}) do
    section, page, anchor = $1, $2, $3.to_s
    page = "index" if page.empty?
    target = section == "guides" ? File.join("guides", page) : page
    "href=\"#{up}#{target}.html#{anchor}\""
  end
end

puts "Searching for files to convert/compile to html...";

sources.each do |source_dir, out_sub_dir|
  # https://lofic.github.io/tips/ruby-recursive_globbing.html
  Dir[File.join(source_dir, "**", "*.md")].each do |file_name|
    relative_name = file_name.sub(/\A#{source_dir}\//, "")
    # Skips the changelogs directory
    next if relative_name.start_with?("changelogs/")

    puts "Found: " + file_name + ", compiling..."

    compiled_file_name = File.join(compiled_docs_dir, out_sub_dir, relative_name.sub(".md", ".html"))
    # Create parent dirs if not exit (ref: https://stackoverflow.com/a/12617369/12026423)
    dirname = File.dirname(compiled_file_name)
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

    compiled_html_content = Kramdown::Document.new(File.read(file_name, encoding: "UTF-8")).to_html
    compiled_html_content = compiled_html_content.gsub(".md", ".html")
    compiled_html_content = rewrite_routes(compiled_html_content, out_sub_dir)
    File.write(compiled_file_name, compiled_html_content, encoding: "UTF-8")

    puts "File " + file_name + " compiled and saved at: " + compiled_file_name
  end
end
