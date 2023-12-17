require 'pixelart'

require_relative 'base'




specs = read_csv( "./letsrock.csv" )


cols = 50
rows = specs.size / cols 
rows += 1    if specs.size % cols != 0

composite = ImageComposite.new( cols, rows, 
                                  width: 28, height: 28 )




specs.each_with_index do |rec, i|
     base        = rec['type']
     accessories = (rec['accessories'] || '' ).split( '/').map { |acc| acc.strip }
     background  = rec['background']
     
     spec = ["bg #{background}", base] + accessories

     img = generate( *spec )
      
     num = "%03d" % i
     puts "==> rock #{num}"
     img.save( "./i/rock#{num}.png" )
     img.zoom(8).save( "./i@8x/rock#{num}@8x.png" )
     
     composite << img
end


composite.save( "./letsrock.png" )

puts "bye"
