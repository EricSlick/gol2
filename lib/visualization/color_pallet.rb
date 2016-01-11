require 'gosu'

module Gol2
  class ColorPallet
    attr_accessor :colors

    def initialize
      self.colors = {}
    end

    # generates a good color pallet based on how many colors and varitions on those colors desired
    # implements strategy found here: http://gamedevelopment.tutsplus.com/articles/picking-a-color-palette-for-your-games-artwork--gamedev-1174
    def generate(hues = 10, variations = 5 )
      (0..360).step(360/(hues - 1)) do |hue|
        self.colors[hue] ||= {}
        index = 0
        (0.0).step(1, 1.0/(variations - 1)) do |value|
          color = Gosu::Color.new
          color.hue = hue
          color.saturation = value
          color.value = value
          self.colors[hue][index] = color
          index += 1
        end
      end
      self.colors
    end
  end
end

# green, brown yellow grey
# http://www.colorblender.com/?preloadblend=5CA42687F037A39726F0DD375C5C5CA3A3A3
#5CA426 92/164/38  darker green
#87F037 135/240/55 lighter green
#A39726 163/151/38 yellow green (brownish)
#F0DD37 240/221/55 yellow
#5CTC5C 92/92/92   dark grey
#A3A3A3 163/163/163 light grey
#
# green, brown yellow grey
#http://www.colorblender.com/?preloadblend=5CA42687F037A39726F0DD375C5C5CA3A3A3#
# 669030 102/144/48  darker green
# 9CDB48 156/219/72  lighter green
# 8F782F 143/120/47  brown
# DBB948 219/185/72  light brown
# 707070 112/112/112 dark gray
# #8F8F8F 143/143/143 lighter gray

# black green read orange white
#http://www.colorblender.com/?preloadblend=000000335401961113CC0425FF9900FFFFFF
#HTML#000000RGB0/0/0
#HTML#335401RGB51/84/1
#HTML#961113RGB150/17/19
#HTML#CC0425RGB204/4/37
#HTML#FF9900RGB255/153/0
#HTML#FFFFFFRGB255/255/255
