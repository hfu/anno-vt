require 'find'
require 'json'

def report(count, dict)
  #print "[#{name}]"
  #return
  dict.keys.sort{|a, b| dict[b] <=> dict[a]}.each {|k|
    print "#{k}: #{dict[k]}\n"
  }
  print "\n"
end

w = File.open('data.ndjson', 'w')
count = 0
dict = Hash.new{|h, k| h[k] = 0}
name = ''
Find.find('/Volumes/Extreme 900/experimental_anno') {|path|
  next unless path.end_with?('geojson')
  begin
    JSON::parse(File.read(path))['features'].each {|f|
      dict[f["properties"]["annoCtg"]] += 1
      minzoom = 12
      minzoom = 9 if %w{山地（山、岳、峰等） 行政区画（市区町村） 河川、湖沼（河川、用水等） 島（島）}.include?(f["properties"]["annoCtg"])
      minzoom = 4 if %w{陸域自然地名（高原、森等） 海上交通施設（港湾） 山地（山の総称） 島（群島、列島等）}.include?(f["properties"]["annoCtg"])
      f["tippecanoe"] = {"minzoom" => minzoom}
      %w{rID lfSpanFr lfSpanTo tmpFlg noChar devDate admCode}.each{|k|
        f["properties"].delete(k)
      }
      1.upto(22) {|i| f["properties"].delete("charG#{i}")}
      w.print JSON::dump(f), "\n"
      count += 1
      report(count, dict) if count % 10000 == 0
    }
  rescue
    print "\nerror in #{path}: #{$!}\n"
  end
}
w.close
