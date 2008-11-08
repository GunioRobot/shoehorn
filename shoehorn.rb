# my_mp3player08.rb
#  made from shoes - thanks _why
#  influenced by Satoshi Asakawa thanks Satoshi


require 'yaml'  


Shoes.app :width => 400, :height => 140, :title => 'Shoehorn the MP3 Player', :resizable => false do
  background silver.to_s..gray.to_s, :angle => 60
  
  def read_yaml filename
    begin
       (YAML.load_file(filename)).to_a  
    rescue
      para "#{filename} is missing"
    end
  end

  def get_file_list path
    Dir.chdir(path)
    mp3_list =  Dir.entries(".")  
    mp3_list.delete('.')
    mp3_list.delete('..')
    mp3_list
  end
  
  def display_list file_list  
    stack do
      background black.to_s..silver.to_s, :angle => 30    
      list_box :width => 390, :items => file_list, :height => 30 do |file| 
        @mp3_file = file.text 
        @vid = video(@mp3_file); @vid.hide
      end
    end 
  end
  
  def display_controls
    stack do
    background white 
    para "controls: ",
      link("play")  {@vid.show; timer(0.01){@vid.play; @vid.hide}}, ", ",
      link("pause") { @vid.pause if @vid.playing?  }, ", ",
      link("stop")  { @vid.stop if @vid.playing?  }, ", ",
   #   link("hide")  { @vid.hide }, ", ",
   #   link("show")  { @vid.show }, ", ",
      link("+5 sec") { @vid.time += 5000 }
    end   
  end
  
  def display_timer
    @l = para '', :stroke => firebrick, :left => 0, :top => 70
    animate do
      @l.replace strong "Remaining: #{@m3_file} #{(@vid.length.to_i - @vid.time.to_i) / 1000}\nElapsed:  #{@vid.time.to_i / 1000} seconds "  if @mp3_file
    end
  end
  
  # set a path to the music files
  config_array = read_yaml 'shoehorn.yaml'
  
  # get a list of mp3 files - assumes all files are mp3
  # will probably blow up if other files types are encountered
  file_list = get_file_list config_array[0]
  
  #create display  Shoes ListBox populating it with the list of files
  display_list file_list
  
  #display control links play pause stop
  display_controls
  
  #display elapsed and remaining time in seconds
  display_timer

  
end


