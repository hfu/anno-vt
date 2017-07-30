task :default do
  sh "ruby data.rb"
  sh "../tippecanoe/tippecanoe --minimum-zoom=0 --maximum-zoom=12 -P -B12 -f --layer=anno -o data.mbtiles data.ndjson"
  #sh "ruby fan-out.rb"
  #sh "git add -v ."
  #sh "git commit -m 'update'"
  #sh "git push -v origin master"
end
