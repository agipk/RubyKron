# Contoh aplikasi CLI memanfaatkan Ruby API untuk Kronologger JSON API
# Agi Putra Kharisma agi[dot]banget[at]gmail[dot]com
# http://agilini.us
# versi 0.1.0
# license: Creative Commons Attribution-Share Alike 2.5

require 'kronologger'

class KronCLIClient 
  def self.start
    self.menu
  end
  
  def self.menu
    puts "----------------------------------------"
    puts "| Aplikasi Kronologger Dengan Ruby API |"
    puts "----------------------------------------"
    puts "[1] 20 Kron terbaru"
    puts "[2] Update status"
    puts "[3] Kirim komentar"
    puts "[4] Lihat komentar"
    puts "[X] Keluar"
    print "Pilihan menu: "
    option = gets
    case option.chomp
    when "1"
      getLatestKron
    when "2"
      newKron
    when "3"
      newKronComment
    when "4"
      getKronComments
    when "X", "x"
      exit
    else
      puts "Error: Menu tidak dikenali"
      menu
    end
  end

  def self.getLatestKron
    krons = Kronologger.getLatestKrons
    krons.each do |k|
      puts "\e[1m" + k.username + " > " + "\e[0m" + k.isipesan + " [#{k.postingid}]"
    end
    self.menu
  end

  def self.newKron
    print "username: "
    username = gets
    print "token: "
    token = gets
    print "isi pesan: "
    isipesan = gets
    print "ping.fm [0/1]: "
    ispingfm = gets
    print "facebook [0/1]: "
    isfacebook = gets
    Kronologger.newKron(username.chomp, token.chomp, isipesan.chomp, ispingfm.chomp, isfacebook.chomp)
    puts "\n\n\n-== Terima kasih ==- \n\n\n"
    self.menu
  end
  
  def self.newKronComment
    print "username: "
    username = gets
    print "token: "
    token = gets
    print "posting id: "
    postingid = gets
    print "isi komentar: "
    isirespond = gets
    Kronologger.newKronComment(username.chomp, token.chomp, postingid.chomp, isirespond.chomp)
    puts "\n\n\n-== Terima kasih ==- \n\n\n"
    self.menu
  end
  
  def self.getKronComments
    print "posting id: "
    postingid = gets
    kronComms = Kronologger.getKronComments(postingid)
    kronComms.each do |kc|
      puts "\e[1m" + kc.username + " > " + "\e[0m" + kc.response
    end
    self.menu
  end
end

KronCLIClient.start
