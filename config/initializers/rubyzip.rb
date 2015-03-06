#https://github.com/rubyzip/rubyzip

Zip.setup do |z|
  #z.on_exists_proc = true
  #z.continue_on_exists_proc = true
  #z.unicode_names = true
  #z.default_compression = Zlib::BEST_COMPRESSION
  z.write_zip64_support = true
end