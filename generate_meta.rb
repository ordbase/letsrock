

CATEGORIES = {
  'base' => [ 
  'maxibiz',
  'black',
  'default',
  ['albino', 'dark'],  ## alternate albino & dark 
  'brown',
  'demon',
  ['golden', 'golden', 'golden', 'golden', 'golden block'],
  ['gray', 'gray', 'gray', 'gray', 'gray block'],
  'green',
  'memepool',
  'pepe',
  'alien',
  'deathbot',
  'safemode',
  'pink',
  'zombie',
   ],

  ## use for maxibiz/black/default    
  'hair_black' => [
                  'mohawk', 'mohawk2',
                  'peakspike',
                  'wildhair',  
                ],  
                  
  'hair' => [
      'mohawk',
      'mohawk blonde',
      'mohawk purple',
      'mohawk red',
      'mohawk2',
      'mohawk2 green',
      'mohawk2 pink',
      'mohawk2 red',
      'peakspike',
      'peakspike purple',
      'peakspike red',
      'wildhair',
      'wildhair blonde',
      'wildhair red',
      'wildhair white',
  ],
  ## use for pink (barbie)
  'hair_blonde_f' => [ 
          'mohawk blonde', 
          'peakspike blonde',           ## exclusive
          'wildhair blonde',
          ['bob blonde', 'eyes left blue'],                 ## exclusive
          ['bob blonde', 'eyes left blue', 'crown'],   ## exclusive hair+hat combos
          ['bob blonde', 'eyes left blue', 'cap mcb'],
          ['bob blonde', 'eyes left blue', 'cap mcd red'],
     ],   

  'hat' => [
    'bandana',
    'bandana2',
    'cowboyhat',
    'headband',
    'knittedcap',
    'knittedcap2',
    'tophat',
    'cap',
    'cap mcb',
    'cap mcd red',
    'cap mcd white',
    'cap mcd black',
    'cap burgerking',
    'cap subway',
    'crown',
    'halo',
   ],
   'hat_blonde_f' => [   ### no top hats, no headband - what else?
   'bandana',
   'bandana2',
   'cowboyhat',
   'knittedcap',
   'knittedcap2',
   'cap',
   'cap mcb',
   'cap mcd red',
   'cap mcd white',
   'cap mcd black',
   'cap burgerking',
   'cap subway',
   'crown',
   'halo',
  ],

'lasereyes_black' => [
  'maxibiz lasereyes red',
  'maxibiz lasereyes green',
  'maxibiz lasereyes blue',
],
'lasereyes' => [
  'lasereyes red',
  'lasereyes green',
  'lasereyes gold',
],
'lasereyes_blonde_f' => [
  'lasereyes blue',   # exclusive
],

'eyes' => [
  '3dglasses',
  'eyes big',
  'eyes blend',
  'eyes blue',
  'eyes bored',
  'eyes cool',   ## exclusive (to non-blondes)
  'eyes green',
  'eyes monobrow',
  'eyes pepe',
  'eyes polarized',
  'eyes rainbow',
  'eyes red',
  'eyes zombie',
  'vr',
],
'eyes_blonde_f' => [
  '3dglasses',
  'eyes big blue',
  'eyes blend',
  'eyes blue',
  # 'eyes bored',
  'eyes green',
  'eyes monobrow',
  'eyes pepe',
  'eyes polarized',
  'eyes rainbow',
  'eyes red',
  'eyes zombie',
  'vr',
], 
} 


pp CATEGORIES



def random_attributes( base )
  attributes = []

  style  =  if ['black', 'default', 'maxibiz' ].include?( base )    ## maxibiz/black/default 
               :black 
            elsif ['pink'].include?( base )  ## pink (barbie)
               :blonde
            elsif  base.index( 'block' )   
               :block  ## e.g. golden block, gray block
            else                       ## "standard" humans incl. orc
               :default
            end

  hair_attributes =  case style
                      when :black then   CATEGORIES['hair_black']
                      when :blonde then  CATEGORIES['hair_blonde_f']
                      when :block  then   nil  # no hair
                      else               CATEGORIES['hair']  
                      end

  hat_attributes =   case style
                     when :blonde then  CATEGORIES['hat_blonde_f']
                     when :block then    nil  # not hat (+ hoodies)
                     else               CATEGORIES['hat']
                     end

   eyes_attributes =    case style
                        when :black    then  CATEGORIES['eyes']+CATEGORIES['lasereyes_black']
                        when :blonde   then  CATEGORIES['eyes_blonde_f']+CATEGORIES['lasereyes_blonde_f']
                        else               CATEGORIES['eyes']+CATEGORIES['lasereyes']
                        end

   ##   0,1,2,3,4    - hair   (50%)
   ##   5,6,7,8        - hat (40%)
   ##   9 -none           (10%) 
   hair_dist, hat_dist =  case style 
                          when :blonde then [[0,1,2,3,4,5], [6,7,8],]  # more hair
                          else              [[0,1,2,3,4],[5,6,7,8],]   # more hats 
                          end
   hair_or_hat  = rand( 10 )
   if hair_dist.include?( hair_or_hat ) && hair_attributes
      attributes << hair_attributes[ rand( hair_attributes.size ) ]
   elsif hat_dist.include?( hair_or_hat ) && hat_attributes
      attributes << hat_attributes[ rand( hat_attributes.size ) ]
   else
     ## none; continue
   end


   ## 70% if hair or hat
   ## 90% if no hair or hat
   eyes  = rand( 10 )
   eyes_dist =   hair_or_hat == 9 ?  [0,1,2,3,4,5,6,7,8] : [0,1,2,3,4,5,6]
   if eyes_dist.include?( eyes ) || [:block].include?( style )    ## block always get eyes
      attributes << eyes_attributes[ rand( eyes_attributes.size ) ]
   else
     ## none; continue
   end



   ## note: might included nested attributes (combos) - flatten
   attributes.flatten
end



def generate_meta( max=1000, seed: 4242 )

  srand( seed )   ## make deterministic

  recs = []

  backgrounds = [ 
    'bitcoin pattern',
    'red',  
    'green',  
    'dollar pattern', 
    'blue',
    'euro pattern',
    'aqua',
    'classic',
    'rainbow',
    'ukraine',
    'usa',
    'china',
    'great britain',
    'europe',
    'austria',
  ] 
  bases  = CATEGORIES['base']

  ## track uniques (that is, duplicates)
  uniques = Hash.new(0)

  id = 0
  loop do
      base_candidates = bases[ id % bases.size ] 
      base = base_candidates.is_a?( Array ) ? base_candidates[ rand( base_candidates.size) ] :  base_candidates

      accessories = random_attributes( base )

      bg =  if base.index( 'default' )
              'default'   ### bg default exclusive for default
            elsif base.index( 'maxibiz' )
              'bitcoin orange'
            elsif base.index( 'golden' ) 
              'yellow'   ## bg yellow exclusive for gold
            else
               backgrounds[id % backgrounds.size ] 
            end

      attributes = [bg, base] + accessories
      print "==> #{id}: "
      pp attributes

      ## downcase and remove non alphnum - to normalize key (names)
      key = attributes.map { |attr| attr.downcase.gsub( /[^a-z0-9]/, '') }.join('+')
      if uniques.has_key?( key )
        puts "!!  WARN - duplicate: #{attributes.inspect}; retry"
        uniques[ key ] += 1
        next
      else
        uniques[ key ] += 1
      end

    rec = []
    rec << id.to_s   ## add id - starting at one
    rec << base
    rec << accessories.join(' / ')
    rec << bg

    recs << rec

    id += 1
    break if id >= max
  end

##
#  dump duplicates for stats
  puts "duplicates:"
  uniques.each do |key,count|
     puts "  #{count} - #{key}"   if count > 1
  end

  recs
end



recs = generate_meta( 1000 )
## pp recs


headers = ['id', 'type', 'accessories', 'background']
File.open( "./letsrock.csv", "w:utf-8" ) do |f|
   f.write( headers.join( ', '))
   f.write( "\n")
   recs.each do |values|
     f.write( values.join( ', ' ))
     f.write( "\n" )
   end
end


puts "bye"


