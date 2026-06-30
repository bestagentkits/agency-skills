#!/usr/bin/env ruby
# frozen_string_literal: true

require "cgi"
require "fileutils"
require "json"
require "open3"
require_relative "readme-writer"

ROOT = File.expand_path(ARGV[0] || Dir.pwd)
MANIFEST_PATH = File.join(ROOT, "data", "skills-manifest.json")
OUTPUT_DIR = File.join(ROOT, "assets", "categories")
WIDTH = 1600
HEIGHT = 640

def fail_with(message)
  warn "Category banner generation failed: #{message}"
  exit 1
end

def xml(value)
  CGI.escapeHTML(value.to_s)
end

def hatch(x, y, width, height, spacing = 18)
  (-height..width).step(spacing).map do |offset|
    %(<path d="M #{x + offset} #{y + height} L #{x + offset + height} #{y}" class="thin hatch"/>)
  end.join("\n")
end

def motif_for(category)
  case category
  when /scientific/ then ["M 1075 325 l 90 -52 92 54 -90 52 z", "M 1148 282 l 0 -82 l 40 0 l 0 82", "M 1112 340 c 42 42 106 42 148 0"]
  when /engineering/ then ["M 1110 270 l 90 -52 90 52 -90 52 z", "M 1128 334 l 72 -42 72 42 -72 42 z", "M 1200 218 l 0 158"]
  when /marketing|paid/ then ["M 1095 320 l 150 -90 l 0 150 z", "M 1065 310 l 44 25 l 0 78 l -44 -25 z", "M 1245 230 l 62 -24"]
  when /finance|sales/ then ["M 1075 380 l 0 -130 l 250 -82 l 0 130 z", "M 1125 340 l 0 -80", "M 1185 318 l 0 -105", "M 1245 294 l 0 -142"]
  when /security/ then ["M 1185 178 l 118 54 c -6 120 -44 180 -118 224 c -74 -44 -112 -104 -118 -224 z", "M 1138 300 l 34 34 l 70 -86"]
  when /game/ then ["M 1072 292 c 20 -60 238 -60 258 0 l 20 72 c 10 38 -35 70 -70 38 l -22 -24 l -134 0 l -22 24 c -35 32 -80 0 -70 -38 z", "M 1128 328 l 64 0", "M 1160 296 l 0 64"]
  when /gis|spatial/ then ["M 1068 360 l 118 -150 l 112 150 z", "M 1148 360 l 96 -116 l 88 116 z", "M 1048 392 l 330 0"]
  when /design/ then ["M 1070 392 l 62 -212 l 48 128 z", "M 1132 180 l 54 26", "M 1210 390 l 128 -128"]
  when /product|pm|project/ then ["M 1058 250 l 266 0 l 0 162 l -266 0 z", "M 1100 292 l 70 0", "M 1100 336 l 146 0", "M 1100 380 l 104 0"]
  when /support|testing/ then ["M 1070 225 l 230 0 l 0 205 l -230 0 z", "M 1110 285 l 34 34 l 64 -82", "M 1110 370 l 34 34 l 64 -82"]
  when /academic/ then ["M 1078 258 l 98 -54 l 98 54 l -98 54 z", "M 1078 258 l 0 120 l 98 54 l 0 -120", "M 1274 258 l 0 120 l -98 54"]
  when /baoyu/ then ["M 1090 390 c 80 -150 126 -190 230 -214", "M 1210 224 c 42 28 54 70 38 124", "M 1078 408 c 62 -10 104 0 150 34"]
  when /claude/ then ["M 1128 252 c 18 -70 144 -70 162 0 c 58 8 72 92 18 120 c -22 60 -134 62 -158 0 c -56 -26 -76 -112 -22 -120", "M 1144 324 l 130 0", "M 1208 254 l 0 140"]
  else ["M 1060 382 l 118 -166 l 160 92 l -118 166 z", "M 1178 216 l 0 180", "M 1060 382 l 160 92"]
  end
end

def banner_svg(category, count)
  title = readme_label(category)
  subtitle = "#{count} skills"
  paths = motif_for(category).map { |d| %(<path d="#{d}" class="ink"/>) }.join("\n")
  <<~SVG
    <svg xmlns="http://www.w3.org/2000/svg" width="#{WIDTH}" height="#{HEIGHT}" viewBox="0 0 #{WIDTH} #{HEIGHT}">
      <defs>
        <style>
          .ink{fill:none;stroke:#151515;stroke-width:3.2;stroke-linecap:round;stroke-linejoin:round}
          .thin{fill:none;stroke:#151515;stroke-width:1.2;stroke-linecap:round;stroke-linejoin:round}
          .hatch{opacity:.42}.label{font-family:Georgia,'Times New Roman',serif;fill:#111}
        </style>
      </defs>
      <rect width="100%" height="100%" fill="#fff"/>
      <path d="M 90 500 L 505 260 L 900 488 L 485 572 Z" class="thin"/>
      <path d="M 505 260 L 505 96 L 900 324 L 900 488" class="thin"/>
      <path d="M 180 458 L 512 272 L 802 438" class="thin"/>
      #{hatch(128, 360, 765, 150)}
      <path d="M 970 470 L 1176 350 L 1378 466 L 1172 586 Z" class="thin"/>
      <path d="M 1176 350 L 1176 160 L 1378 276 L 1378 466" class="thin"/>
      #{paths}
      #{hatch(1040, 398, 310, 110, 16)}
      <text x="130" y="205" class="label" font-size="72" letter-spacing="0">#{xml(title)}</text>
      <text x="134" y="260" class="label" font-size="31" letter-spacing="0">#{xml(subtitle)} - isometric patent sketch</text>
      <path d="M 132 292 L 760 292" class="ink"/>
      <text x="132" y="345" class="label" font-size="22">thin ink lines - cross-hatching - white paper - section cutaway</text>
      <path d="M 96 96 L 1504 96 L 1504 544 L 96 544 Z" class="thin"/>
    </svg>
  SVG
end

manifest = JSON.parse(File.read(MANIFEST_PATH))
groups = manifest.group_by { |entry| entry.fetch("division") }.sort
FileUtils.mkdir_p(OUTPUT_DIR)

groups.each do |category, items|
  svg_path = File.join(OUTPUT_DIR, "#{category}.svg")
  png_path = File.join(OUTPUT_DIR, "#{category}.png")
  File.write(svg_path, banner_svg(category, items.length))
  output, status = Open3.capture2e(
    "magick",
    svg_path,
    "-resize",
    "#{WIDTH}x#{HEIGHT}!",
    "-strip",
    "-define",
    "png:exclude-chunk=all",
    png_path
  )
  fail_with(output.strip) unless status.success?
  FileUtils.rm_f(svg_path)
end

puts "Generated #{groups.length} category banners in #{OUTPUT_DIR}."
