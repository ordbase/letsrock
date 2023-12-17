require 'pixelart'


require_relative 'base'



specs = parse_data( <<DATA )
 ## archetypes

 maxibiz
 black
 default
 albino
 brown
 dark
 demon
 golden-block
 golden
 pink
 gray-block
 gray
 green
 memepool
 pepe
 alien
 deathbot
 safemode
 zombie

 maxibiz, vr, mohawk
 black, vr, mohawk-purple 
 default, vr, mohawk-blonde 
 albino,  vr, mohawk-red
 brown, vr, mohawk2
 dark, vr, mohawk2-green
 demon,  vr, halo
 golden-block,  vr
 golden,  vr, crown
 pink, bob-blonde, vr  
 pink, bob-blonde
 pink, bob-blonde, eyes-left-blue
 gray-block,  vr
 gray, vr, mohawk2-pink
 green,  vr, mohawk2-red
 memepool,  vr, peakspike
 pepe,  vr, peakspike-blonde
 alien,  vr, peakspike-purple
 deathbot,  vr, wildhair-red
 safemode,  vr, wildhair
 zombie,   vr, mohawk-red


 maxibiz, lasereyes red, tophat
 black,  3dglasses, knittedcap
 default, eyes-big, headband
 albino, eyes-blend, cap
 brown, eyes-blue, bandana
 dark, eyes-zombie, cap mcd red
 demon, eyes-cool, cap mcd black
 golden-block, eyes-rainbow
 golden, eyes-rainbow, crown
 pink, wildhair-blonde, eyes-cool  
 gray-block, eyes-pepe
 gray, eyes-polarized, cap subway
 green, lasereyes gold, cap burgerking
 memepool, eyes-big, knittedcap2
 pepe, eyes-red, cap mcb
 alien, eyes-blue, cap mcd white
 deathbot, 3dglasses, cowboyhat
 safemode, eyes-bored, bandana2
 zombie,  eyes-red,  bandana
DATA



cols = 10
rows = specs.size / cols 
rows += 1    if specs.size % cols != 0

composite  = ImageComposite.new( cols, rows, 
                                  width: 28, height: 28 )

specs.each_with_index do |spec, i|
     img = generate( *spec)
     img.save( "./tmp/rock#{i}.png" )
     img.zoom(10).save( "./tmp/rock#{i}@10x.png" )
     composite << img
end


composite.save( "./tmp/rocks.png" )
composite.zoom(4).save( "./tmp/rocks@4x.png" )

puts "bye"
